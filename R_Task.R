# Load necessary libraries
library(ggplot2)
library(dplyr)
library(caret)
library(randomForest)
library(MASS)
library(corrplot)
library(gridExtra)
library(caTools)
library(glmnet)

# Load dataset
fire_data <- read.csv("D:\\Deepak\\forestfires.csv")

head(fire_data, 5)

# Explore the dataset
str(fire_data)  # Overview of the dataset
summary(fire_data)  # Summary of all variables

colnames(fire_data)

dim(fire_data)

# Check to see if any data missing - we're OK here so can proceed.
sum(is.na(fire_data))




fire_data$month <- as.factor(fire_data$month)
fire_data$day <- as.factor(fire_data$day)

numeric_vars <- fire_data %>%
  select(FFMC, DMC, DC, ISI, temp, RH, wind, rain, area)

corr_matrix <- cor(numeric_vars)
corrplot(corr_matrix, method = "color", addCoef.col = "black", number.cex = 0.7)




# Select the numeric columns using base R
numeric_vars <- fire_data[, c("FFMC", "DMC", "DC", "ISI", "temp", "RH", "wind", "rain", "area")]


# Function to detect outliers using IQR method
detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25)
  Q3 <- quantile(x, 0.75)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  return(x < lower_bound | x > upper_bound)
}

# Apply the function to each numeric column
outliers <- sapply(numeric_vars, detect_outliers)

# Check the number of outliers in each column
colSums(outliers)
show(outliers)

# Create boxplots for all numeric variables
boxplot(numeric_vars, main = "Boxplot of Numeric Variables", las = 2)




# Convert month and day string variables into numeric values
fire_data$month <- as.numeric(as.factor(fire_data$month))
fire_data$day <- as.numeric(as.factor(fire_data$day))
head(fire_data, 5)


fire_data$log_area <- log1p(fire_data$area)
head(fire_data, 5)

fire_data <- fire_data[, !colnames(fire_data) %in% "area"]
head(fire_data, 5)


# Function to replace outliers with median
replace_outliers <- function(x) {
  Q1 <- quantile(x, 0.25)
  Q3 <- quantile(x, 0.75)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  x[x < lower_bound | x > upper_bound] <- median(x)
  return(x)
}

# Apply the function to each numeric column
numeric_vars_imputed <- as.data.frame(lapply(numeric_vars, replace_outliers))

boxplot(numeric_vars_imputed, main = "Boxplot of Numeric Variables After Imputation", las = 2)

outliers <- sapply(numeric_vars_imputed, detect_outliers)
colSums(outliers)


# Data Scaling
# Remove the 'log_area' column as it's the last column in the dataset.
fire_data_no_log_area <- fire_data[, -ncol(fire_data)]

# Calculate column-wise means and standard deviations
means <- apply(fire_data_no_log_area, 2, mean)
sds <- apply(fire_data_no_log_area, 2, sd)

# Scale the data: (value - mean) / sd
fire_data_scaled <- as.data.frame(scale(fire_data_no_log_area, center = means, scale = sds))

# Add the 'log_area' column back
fire_data_scaled$log_area <- fire_data$log_area

  head(fire_data_scaled, 5)

# Train-Test Split

set.seed(123)
split <- sample.split(fire_data_scaled$log_area, SplitRatio = 0.7)
train_data <- subset(fire_data_scaled, split == TRUE)
test_data <- subset(fire_data_scaled, split == FALSE)


# Model 1: Linear Regression
lm_model <- lm(log_area ~ ., data = train_data)
summary(lm_model)

# Predictions on test set
lm_predictions <- predict(lm_model, newdata = test_data)

# Model Evaluation for Linear Regression
mse_lm <- mean((lm_predictions - test_data$log_area)^2)
cat("MSE for Linear Regression:", mse_lm, "\n")

varImpPlot(lm_model)


# Model 2: Random Forest
rf_model <- randomForest(log_area ~ ., data = train_data, ntree = 500, mtry = 3, importance = TRUE)
rf_predictions <- predict(rf_model, newdata = test_data)

# Model Evaluation for Random Forest
mse_rf <- mean((rf_predictions - test_data$log_area)^2)
cat("MSE for Random Forest:", mse_rf, "\n")

varImpPlot(rf_model)

model_comparison <- data.frame(
  Model = c("Linear Regression", "Random Forest"),
  MSE = c(mse_lm, mse_rf)
)
print(model_comparison)


# Optional: Lasso Regression for Feature Selection
x <- as.matrix(train_data[, -ncol(train_data)])
y <- train_data$log_area

lasso_model <- cv.glmnet(x, y, alpha = 1)
coef(lasso_model, s = "lambda.min")

# Lasso Predictions
lasso_predictions <- predict(lasso_model, newx = as.matrix(test_data[, -ncol(test_data)]), s = "lambda.min")
mse_lasso <- mean((lasso_predictions - test_data$log_area)^2)
cat("MSE for Lasso Regression:", mse_lasso, "\n")


model_comparison <- data.frame(
  Model = c("Linear Regression", "Random Forest", "Lasso"),
  MSE = c(mse_lm, mse_rf, mse_lasso)
)
print(model_comparison)