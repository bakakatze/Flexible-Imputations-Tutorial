
require(mice)
require(tidyverse)
require(MASS)

# Packages to draw imputations from non-normal distributions
require(ImputeRobust)
require(gamlss)

#
# We will look at "whiteside" dataset from MASS
# It recorded weekly gas consumption (in cubic feet) and average external temperature (in Centigrade).
# Termostat was set at 20 Centigrade at all time.

# 3.1 METHODS ====
## 3.1.1 Regression Imputation (Predict Method) ----

# Just the global mean from a linear regression
# May not reflect true value

## 3.1.2 Stochastic Regression Imputation (Predict + noise method) ----

# Add a standard deviation from the full dataset.
# Get multiple draw and average them out.

# This method assumes that the intercept, the slope, and the standard deviation of the residuals are known. << Not the case in reality.

## 3.1.3 Bayesian or Bayesian Bootsrap Imputation (Predict + noise + parameter of uncertainty) ----

# Bayesian method
# OR
# Bootstrap method

# the intercept, slope, and SD may vary

## 3.1.4 A second predictor ----

# Use the marginal mean based on existing confoundings.

## 3.1.5 Predictive Mean Matching (drawing from observed samples) ----

# run linear regression, get global mean, select small numbers of observations close to the global mean, draw randomly from that.
# Multiple draws will reflect the uncertainty of the actual value.

# 3.2 Imputation under the normal linear model ====

## Regression Imputation
# method = "norm.predict"

## Stochastic Regression Imputation
# method = "norm.nob"

## Bayesian multiple imputation
# The ß0, ß1, and σ are random draws from their posterior distribution, given the data.
# method = "norm"

## Bayesian multiple imputation (bootstrap)
# The ß0, ß1, and σ are the least squares estimates calculated from a bootstrap sample taken from the data.
# Compared to the non-bootstrap approach, this avoids the Choleski decomposition and does not need to draw from the chi squared distribution.
# method = "norm.boot"

## 3.2.2 Algorithm ----

# Read more about imputations if you are interested.

# 3.3 Imputation under non-normal distributions ====

# The effect of non-normality is generally small for measures that rely on the center of the distribution, like mean or regression weights.
# BUT, the effect could be substantial for estimates like variance or a percentile.

# Yucel 2008, found that non-normality do not hamper good performance of multiple imputation for the mean structure in N > 400, 
# even for high percentages (75%) of missing data in one variable.

# TWO approaches to handle imputations for non-normal distribution:
# 1. Predictive Mean Matching
# 2. Draw samples from non-normal distribution

## 3.3.2 Imputation from the t-distribution ----

# get a dataset about head circumference and age
data(db)
head(db)

data = subset(db, age > 1 & age <2, c("age", "head"))
names(data) = c("age", "hc")

synthetic = rep(c(FALSE, TRUE), each = nrow(data))
data2 = rbind(data, data)
row.names(data2) = 1:nrow(data2)
data2[synthetic, "hc"] = NA

# now impute under t-distrbution
imp = mice(data2, m = 1, meth = "gamlssTF", seed = 88009, print = FALSE)
syn = subset(mice::complete(imp), synthetic)

hist(syn$hc, breaks = 50) # rounder distribution for the drawn imputations from the t-disitribution

#
# 3.4 Predictive Mean Matching ====

# This model is less vulnerable to model misspecification compared with previous models.

# There are 4 different types of matching. Read more to learn more.

# number of donors are usually set at 5.

# 3.5 Classification and Regression Trees ====




