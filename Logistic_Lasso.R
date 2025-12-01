library(readr)
library(dplyr)
library(glmnet)
library(caret)   # 用于分训练/测试集
library(ggplot2)
library(tidyr)
library(scales)

# ------------------------------------------------------------
# 1️⃣ 读取清洗后的数据
# ------------------------------------------------------------
data <- read_csv("user_features_2025_clean_filtered.csv")
data <- data %>%
  mutate(is_active = as.integer(is_active))
data <- data %>%
  mutate(
    gender = as.factor(gender),
    primary_device = as.factor(primary_device)
  )

feature_vars <- c("age", "gender", "monthly_spend", "primary_device",
                  "search_count_last_year", "search_total_duration",
                  "watch_count_last_year", "watch_time_last_year")

# ------------------------------------------------------------
# 3️⃣ one-hot 编码 + 标准化
# ------------------------------------------------------------
# caret::dummyVars 可以同时处理分类和标准化
# 只标准化数值型变量
num_vars <- c("age", "monthly_spend", "search_count_last_year", 
              "search_total_duration", "watch_count_last_year", "watch_time_last_year")

cat_vars <- c("gender", "primary_device")

dummies <- dummyVars(~ ., data = data[, c(num_vars, cat_vars)])
X <- predict(dummies, newdata = data[, c(num_vars, cat_vars)])

# 只对数值列标准化
X[, num_vars] <- scale(X[, num_vars])

# ------------------------------------------------------------
# 4️⃣ 拆分训练 / 测试集
# ------------------------------------------------------------
set.seed(5052)
train_index <- createDataPartition(y, p = 0.8, list = FALSE)
X_train <- X[train_index, ]
y_train <- y[train_index]
X_test  <- X[-train_index, ]
y_test  <- y[-train_index]

# ------------------------------------------------------------
# 5️⃣ 普通 Logistic 回归（baseline）
# ------------------------------------------------------------
logit_model <- glm(y_train ~ X_train, family = binomial)
summary(logit_model)

# ------------------------------------------------------------
# 6️⃣ Lasso Logistic（带交叉验证）
# ------------------------------------------------------------
set.seed(5052)
cv_lasso <- cv.glmnet(
  x = X_train,
  y = y_train,
  family = "binomial",
  alpha = 1,        # alpha = 1 → Lasso
  nfolds = 10,
  standardize = FALSE  # 我们已经标准化过了
)

# 最优 λ 值
lambda_opt <- cv_lasso$lambda.min
cat("Optimal lambda:", lambda_opt, "\n")

# ------------------------------------------------------------
# 7️⃣ 提取重要变量
# ------------------------------------------------------------
lasso_coef <- coef(cv_lasso, s = "lambda.min")
lasso_df <- data.frame(
  Feature = rownames(lasso_coef),
  Coefficient = as.numeric(lasso_coef)
) %>%
  filter(Coefficient != 0)

print(lasso_df)

# ------------------------------------------------------------
# 8️⃣ 模型评估
# ------------------------------------------------------------
pred_prob <- predict(cv_lasso, newx = X_test, s = "lambda.min", type = "response")
pred_class <- ifelse(pred_prob > 0.5, 1, 0)

conf_mat <- table(True = y_test, Pred = pred_class)
print(conf_mat)

acc <- sum(diag(conf_mat)) / sum(conf_mat)
cat("Test Accuracy:", round(acc, 4), "\n")

# ------------------------------------------------------------
# 9️⃣ 可视化：重要变量系数图
# ------------------------------------------------------------
lasso_df %>%
  filter(Feature != "(Intercept)") %>%
  ggplot(aes(x = reorder(Feature, Coefficient), y = Coefficient)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(title = "Lasso Logistic Coefficients", x = NULL, y = "Coefficient (Standardized)") +
  scale_y_continuous(labels = comma)


