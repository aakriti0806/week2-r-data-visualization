# ==========================================
# Week 2: Data Visualization in R with ggplot2
# ==========================================

# 1. Automatically install any missing required packages
required_packages <- c("ggplot2", "dplyr", "scales", "viridisLite")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if (length(new_packages) > 0) {
  install.packages(new_packages, repos = "https://cloud.r-project.org")
}

# 2. Load Libraries
library(ggplot2)
library(dplyr)
library(scales)

# Ensure outputs directory exists
if (!dir.exists("C:/Users/HP/Desktop/yuvaIntern/task2/outputs")) {
  dir.create("outputs", recursive = TRUE)
}

# Set consistent publication theme
theme_custom <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
      plot.subtitle = element_text(size = 10, color = "#7f8c8d", margin = margin(b = 10)),
      axis.title = element_text(face = "bold", size = 11, color = "#34495e"),
      axis.text = element_text(color = "#2c3e50"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "#ecf0f1"),
      legend.position = "bottom",
      legend.title = element_text(face = "bold")
    )
}

# 3. Load Dataset
data("diamonds")
df <- diamonds

cat("Dataset Loaded Successfully. Dimensions:", dim(df), "\n")

# ==========================================
# Visualization 1: Histogram (Univariate)
# ==========================================
p1 <- ggplot(df, aes(x = price)) +
  geom_histogram(binwidth = 500, fill = "#3498db", color = "#ffffff", alpha = 0.85) +
  geom_vline(aes(xintercept = median(price)), color = "#e74c3c", linetype = "dashed", linewidth = 1) +
  scale_x_continuous(labels = label_dollar()) +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Figure 1: Distribution of Diamond Prices",
    subtitle = "Right-skewed distribution with red dashed line indicating median price ($2,401)",
    x = "Price (USD)",
    y = "Count"
  ) +
  theme_custom()

ggsave("C:/Users/HP/Desktop/yuvaIntern/task2/outputs/01_distribution_histogram.png", plot = p1, width = 8, height = 5, dpi = 300)

# ==========================================
# Visualization 2: Boxplot (Categorical vs Continuous)
# ==========================================
p2 <- ggplot(df, aes(x = cut, y = price, fill = cut)) +
  geom_boxplot(outlier.alpha = 0.1, outlier.color = "#95a5a6", show.legend = FALSE) +
  scale_y_log10(labels = label_dollar()) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Figure 2: Price Variance Across Diamond Cut Quality",
    subtitle = "Logarithmic scale highlights median price stability and outlier distribution",
    x = "Cut Quality",
    y = "Price in USD (Log Scale)"
  ) +
  theme_custom()

ggsave("C:/Users/HP/Desktop/yuvaIntern/task2/outputs/02_categorical_bar_chart.png", plot = p2, width = 8, height = 5, dpi = 300)

# ==========================================
# Visualization 3: Scatter Plot (Bivariate Relationship)
# ==========================================
p3 <- ggplot(df %>% sample_n(5000), aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.5, size = 1.8) +
  geom_smooth(method = "gam", color = "#2c3e50", se = FALSE, linewidth = 1) +
  scale_x_continuous(breaks = seq(0, 5, 0.5)) +
  scale_y_continuous(labels = label_dollar()) +
  scale_color_brewer(palette = "Spectral") +
  labs(
    title = "Figure 3: Carat Weight vs. Price stratified by Clarity",
    subtitle = "Sample of 5,000 observations showing non-linear price acceleration",
    x = "Carat Weight",
    y = "Price (USD)",
    color = "Clarity Grade"
  ) +
  theme_custom()

ggsave("C:/Users/HP/Desktop/yuvaIntern/task2/outputs/03_bivariate_scatterplot.png", plot = p3, width = 8, height = 5, dpi = 300)

# ==========================================
# Visualization 4: Line Plot (Aggregated Trends)
# ==========================================
summary_df <- df %>%
  group_by(color) %>%
  summarise(
    mean_price = mean(price),
    median_price = median(price),
    .groups = 'drop'
  )

p4 <- ggplot(summary_df, aes(x = color, group = 1)) +
  geom_line(aes(y = mean_price, color = "Mean Price"), linewidth = 1.2) +
  geom_point(aes(y = mean_price, color = "Mean Price"), size = 3) +
  geom_line(aes(y = median_price, color = "Median Price"), linewidth = 1.2, linetype = "dashed") +
  geom_point(aes(y = median_price, color = "Median Price"), size = 3) +
  scale_y_continuous(labels = label_dollar()) +
  scale_color_manual(values = c("Mean Price" = "#2980b9", "Median Price" = "#e67e22")) +
  labs(
    title = "Figure 4: Mean vs. Median Price across Diamond Color Grades",
    subtitle = "Color grades range from D (Best/Colorless) to J (Slight Color)",
    x = "Diamond Color Grade",
    y = "Price (USD)",
    color = "Metric"
  ) +
  theme_custom()

ggsave("C:/Users/HP/Desktop/yuvaIntern/task2/outputs/04_timeseries_lineplot.png", plot = p4, width = 8, height = 5, dpi = 300)

cat("\nSuccess! All 4 figures generated and saved inside the 'outputs/' folder.\n")