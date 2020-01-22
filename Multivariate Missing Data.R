

require(mice)

#
## 4.1 Missing Data Pattern ====

# 1. Univariate

# 2. Monotone

# 3. Connected

# 4. General

# 4.1.2 Summary Statistics ----

# we can check missing data pattern from this dummy dataset
md.pattern(pattern4, plot = FALSE)

# this is only useful if you have small sample size


# check the pattern of paired missing data from a monotone missing data in the pattern4 dataset
p = md.pairs(pattern4) # rr = both observer, # rm = 1st observed + 2nd missing, so on and so forth
p


# We can calculate the proportion of usable case for use to impute the a column given the availability of the rest of the column (all combinations)
p$mr/(p$mr + p$mm)

# 1st row = I_AA
# I_AB = 0, this means B is not relevant for imputing A because there are no observed cases in B where A is missing.
# I_AC = 1, this means C is always exist wherever A is missing and is a relevant predictor for imputation.


# 4.1.3 Influx and outflux ----

# The influx coefficient combines each pairs summary statistics and compute a single aggregate statistic.
# I_j = the number of variable pairs with Y_j missing and Y_k observed, divided by the total number of observed cells.

# 0 value means there are no variables in Y_k that can be used to impute Y_j.
# 1 is the other way around.


# The outflux coefficient:
# O_j is the number of variable pairs with Y_j observed and Y_k missing, divided by the total number of incomplete data cells.

# Outflux is an indicator of the potential usefulness of Y_j for imputing other variables.
# The higher the number, the better it is for imputing other variables.

# Let's calculate the flux coefficients
flux(pattern4)[, 1:3]

# the first column is the proportion of observed data.

# PLOT them
fluxplot(pattern4) # General missingness pattern

#
# 4.2 Issues in multivariate imputation ====

# predictors for imputation can contain missing values

# circular dependence can occur (correlation between predictor and target)

# varying types of predictor, difficult to model

# collinearity

# longitudinal data, ordering can matter

# non-linearity

# imputation can produce pregnant father


# 4.3 Monotone Data Imputation ====




