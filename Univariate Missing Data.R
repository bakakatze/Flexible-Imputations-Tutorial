
require(mice)
require(tidyverse)
require(MASS)

# Packages to draw imputations from non-normal distributions
require(ImputeRobust)
require(gamlss)

# Source: https://stefvanbuuren.name/fimd

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

# 3.5 Classification and Regression Trees (CART) ====

# CART methods are robush against outliers, can deal with multicolinearity and skewed distributions, and
# are flexible to fit interactions and non-linear interactions

# The method is similar to the predictive mean matching, but the "mean" is calculated by the tree model instead.
# The uncertainty parameter is gained through bootstraping.

# 3.6 Categorical Data ====

# There are different methods that can be use to impute categorical data

## 3.6.1 Generalised Linear Model ----

# in mice package, this comes under method = "logreg"

## 3.6.2 Perfect Prediction ----

# Many options but the recommendation is to use:
# 1. Data Augmentation
# 2. Bayesian sampling with weak Cauchy distribution

## 3.6.3 Limitation of GLM ----

# The model breaks if missing data > 40%
# Less robust combared to pmm (predictive mean matching), cart (classification and regression trees), or rf (random forest)

# 3.7 Other Data Types ====

## Methods available from mice package for Count data:
# 1. gamlssPO (Poisson)
# 2. gamlssZIBI (zero-inflated binomial)
# 3. gamlssZIP (zero-inflated Poisson)


# Literatures are still evolving around censored, truncated, and rounded data. Read more if interested.

# 3.8 Non Ignorable Missing Data ====

# Options:
# 1. Selection Model

# 2. Selection and pattern-mixture models
# This combines the distribution of the missing data and the observed data to get a selection sample distribution to draw from.

# 3. Adding/Multiplying a constant
# Do regular imputation and add/substract a constant that reflects the nature of the missing data based on prior knowledge

## 3.8.6 Sensitivity Analysis ----

# It is important to conduct sensitivity analysis after you have done your imputation.
# However, before doing the sensitvity analysis, there should be a reasonable evidence that the MAR assumption is inadequate.
# The scenarios for sensitivity analysis can be gained from the subject matter experts.

# In practice, we may lack such insights necessary to construct the scenario for sensitivity analysis.
# It's better to construct a good imputation model (based on all available data) over a poorly constructed sensitivity analysis.













