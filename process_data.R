library(readr)
library(dplyr)
library(lubridate)

# 1️⃣ 读取数据
users <- read_csv("users.csv")
search_logs <- read_csv("search_logs.csv")
watch_history <- read_csv("watch_history.csv")

# 2️⃣ 时间过滤：2025-01-01 ~ 2025-12-31
search_filtered <- search_logs %>%
  filter(search_date >= as.Date("2025-01-01"),
         search_date <= as.Date("2025-12-31"))

watch_filtered <- watch_history %>%
  filter(watch_date >= as.Date("2025-01-01"),
         watch_date <= as.Date("2025-12-31"))

# 3️⃣ search 聚合到 user 级别
search_summary <- search_filtered %>%
  group_by(user_id) %>%
  summarise(
    search_count_last_year = n(),
    search_total_duration = sum(search_duration_seconds, na.rm = TRUE),
    .groups = "drop"
  )

# 4️⃣ watch 聚合到 user 级别
watch_summary <- watch_filtered %>%
  group_by(user_id) %>%
  summarise(
    watch_count_last_year = n(),
    watch_time_last_year = sum(watch_duration_minutes, na.rm = TRUE),
    .groups = "drop"
  )

# 5️⃣ 合并用户信息 + 基础特征
user_features <- users %>%
  select(user_id, age, gender, monthly_spend, primary_device, is_active) %>%
  left_join(search_summary, by = "user_id") %>%
  left_join(watch_summary, by = "user_id") %>%
  mutate(
    across(c(search_count_last_year, search_total_duration,
             watch_count_last_year, watch_time_last_year),
           ~ replace_na(., 0))
  )

# 6️⃣ 应用业务规则清洗
user_features_clean <- user_features %>%
  # 年龄在 18~80 之间
  filter(!is.na(age),
         age >= 18,
         age <= 80) %>%
  # monthly_spend 合理范围：去掉 >25 的异常值
  filter(!is.na(monthly_spend),
         monthly_spend <= 25) %>%
  # 去除剩余 NA（例如 gender / primary_device / is_active 等）
  filter(if_all(everything(), ~ !is.na(.))) %>%
  # 按 user_id 去重
  distinct(user_id, .keep_all = TRUE)

# 7️⃣ 检查结果
cat("清洗后用户数:", nrow(user_features_clean), "\n")

# 8️⃣ 导出
write_csv(user_features_clean, "user_features_2025_clean_filtered.csv")

cat("✅ 已完成：时间过滤 + 特征聚合 + 年龄18-80 + 月费<=25 + 去NA + 按user_id去重。\n")