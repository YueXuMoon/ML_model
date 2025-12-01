# ------------------------------------------------------------
# 📦 依赖包
# ------------------------------------------------------------
library(readr)
library(dplyr)
library(glmnet)
library(randomForest)

library(xgboost)
library(pROC)
library(ggplot2)
library(caret)
library(scales)

# ------------------------------------------------------------
# 1️⃣ 读取数据
# ------------------------------------------------------------
data <- read_csv("user_features_2025_clean_filtered.csv")

# ------------------------------------------------------------
# 2️⃣ 数据清洗与特征工程
# ------------------------------------------------------------
data <- data %>%
  mutate(
    is_active = as.integer(is_active),
    gender = as.factor(gender),
    primary_device = as.factor(primary_device),
    
    # 平均观看时长
    avg_watch_time = ifelse(watch_count_last_year > 0,
                            watch_time_last_year / watch_count_last_year, 0),
    # 搜索/观看比例
    search_per_watch = ifelse(watch_count_last_year > 0,
                              search_count_last_year / watch_count_last_year, 0),
    
    # log-transform 平滑偏态特征
    log_watch_time = log1p(watch_time_last_year),
    log_watch_count = log1p(watch_count_last_year),
    log_search_time = log1p(search_total_duration),
    log_search_count = log1p(search_count_last_year)
  )

feature_vars <- c(
  "age", "gender", "monthly_spend", "primary_device",
  "search_count_last_year", "search_total_duration",
  "watch_count_last_year", "watch_time_last_year",
  "avg_watch_time", "search_per_watch",
  "log_watch_time", "log_watch_count",
  "log_search_time", "log_search_count"
)

num_vars <- c("age", "monthly_spend",
              "search_count_last_year", "search_total_duration",
              "watch_count_last_year", "watch_time_last_year",
              "avg_watch_time", "search_per_watch",
              "log_watch_time", "log_watch_count",
              "log_search_time", "log_search_count")

cat_vars <- c("gender", "primary_device")

# ------------------------------------------------------------
# 3️⃣ dummy 编码 + 标准化数值变量
# ------------------------------------------------------------
dummies <- dummyVars(~ ., data = data[, c(num_vars, cat_vars)])
X <- predict(dummies, newdata = data[, c(num_vars, cat_vars)])
X[, num_vars] <- scale(X[, num_vars])
y <- data$is_active

# ------------------------------------------------------------
# 4️⃣ 训练/测试集划分
# ------------------------------------------------------------
set.seed(5052)
train_index <- createDataPartition(y, p = 0.8, list = FALSE)
X_train <- X[train_index, ]
y_train <- y[train_index]
X_test <- X[-train_index, ]
y_test <- y[-train_index]

# ------------------------------------------------------------
# 5️⃣ Weighted Lasso Logistic
# ------------------------------------------------------------
wts <- ifelse(y_train == 1,
              1 / sum(y_train == 1),
              1 / sum(y_train == 0))

set.seed(5052)
cv_lasso <- cv.glmnet(
  x = X_train,
  y = y_train,
  family = "binomial",
  alpha = 1,
  nfolds = 10,
  weights = wts,
  standardize = FALSE
)

lambda_opt <- cv_lasso$lambda.min
pred_prob_lasso <- predict(cv_lasso, newx = X_test, s = "lambda.min", type = "response")
roc_lasso <- roc(y_test, as.numeric(pred_prob_lasso))
auc_lasso <- auc(roc_lasso)
cat("Weighted Lasso AUC =", round(auc_lasso, 4), "\n")

# ------------------------------------------------------------
# 6️⃣ Random Forest
# ------------------------------------------------------------
set.seed(5052)
rf_model <- randomForest(
  x = X_train,
  y = as.factor(y_train),
  ntree = 300,
  mtry = floor(sqrt(ncol(X_train))),
  classwt = c("0" = 0.85, "1" = 0.15)
)

pred_prob_rf <- predict(rf_model, X_test, type = "prob")[, 2]
roc_rf <- roc(y_test, pred_prob_rf)
auc_rf <- auc(roc_rf)
cat("Random Forest AUC =", round(auc_rf, 4), "\n")

# ------------------------------------------------------------
# 7️⃣ XGBoost
# ------------------------------------------------------------
dtrain <- xgb.DMatrix(data = X_train, label = y_train)
dtest <- xgb.DMatrix(data = X_test, label = y_test)

set.seed(5052)
xgb_model <- xgboost(
  data = dtrain,
  objective = "binary:logistic",
  eval_metric = "auc",
  nrounds = 150,
  max_depth = 5,
  eta = 0.1,
  subsample = 0.8,
  colsample_bytree = 0.8,
  verbose = 0
)

pred_prob_xgb <- predict(xgb_model, dtest)
roc_xgb <- roc(y_test, pred_prob_xgb)
auc_xgb <- auc(roc_xgb)
cat("XGBoost AUC =", round(auc_xgb, 4), "\n")

# ------------------------------------------------------------
# 8️⃣ 汇总指标计算函数
# ------------------------------------------------------------
calc_metrics <- function(y_true, y_prob, threshold = 0.5) {
  pred <- ifelse(y_prob > threshold, 1, 0)
  cm <- table(factor(y_true, levels = c(0,1)),
              factor(pred, levels = c(0,1)))
  
  # 提取混淆矩阵元素（保证完整结构）
  TN <- cm["0","0"]
  FP <- cm["0","1"]
  FN <- cm["1","0"]
  TP <- cm["1","1"]
  
  # 避免除零错误
  acc <- (TP + TN) / sum(cm)
  prec <- ifelse((TP + FP) == 0, 0, TP / (TP + FP))
  rec <- ifelse((TP + FN) == 0, 0, TP / (TP + FN))
  f1 <- ifelse((prec + rec) == 0, 0, 2 * prec * rec / (prec + rec))
  
  return(c(Accuracy = acc, Precision = prec, Recall = rec, F1 = f1))
}

metrics_lasso <- calc_metrics(y_test, pred_prob_lasso)
metrics_rf <- calc_metrics(y_test, pred_prob_rf)
metrics_xgb <- calc_metrics(y_test, pred_prob_xgb)

# ------------------------------------------------------------
# 9️⃣ 汇总结果表
# ------------------------------------------------------------
result_df <- data.frame(
  Model = c("Weighted Lasso", "Random Forest", "XGBoost"),
  AUC = c(auc_lasso, auc_rf, auc_xgb),
  Accuracy = c(metrics_lasso["Accuracy"], metrics_rf["Accuracy"], metrics_xgb["Accuracy"]),
  Precision = c(metrics_lasso["Precision"], metrics_rf["Precision"], metrics_xgb["Precision"]),
  Recall = c(metrics_lasso["Recall"], metrics_rf["Recall"], metrics_xgb["Recall"]),
  F1 = c(metrics_lasso["F1"], metrics_rf["F1"], metrics_xgb["F1"])
)
print(result_df)

# ------------------------------------------------------------
# 🔟 绘制 ROC 曲线比较
# ------------------------------------------------------------
plot(roc_lasso, col = "steelblue", lwd = 2, main = "ROC Curve Comparison")
plot(roc_rf, col = "darkorange", lwd = 2, add = TRUE)
plot(roc_xgb, col = "forestgreen", lwd = 2, add = TRUE)
legend("bottomright", legend = c(
  paste0("Weighted Lasso (AUC=", round(auc_lasso, 3), ")"),
  paste0("Random Forest (AUC=", round(auc_rf, 3), ")"),
  paste0("XGBoost (AUC=", round(auc_xgb, 3), ")")
),
col = c("steelblue", "darkorange", "forestgreen"), lwd = 2)