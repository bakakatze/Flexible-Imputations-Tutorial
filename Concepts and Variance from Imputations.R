
require(MASS)
#

logistic = function(x) exp(x) / (1 + exp(x))

set.seed(80122)

n = 300

# simulate random numbers where Y1 and Y2 are correlated with r = 0.5
# The Sigma argument is the covariance matrix
y = MASS::mvrnorm(n = n, mu = c(0, 0), Sigma = matrix(c(1, 0.5, 0.5, 1), nrow = 2))

r2.mcar = 1 - rbinom(n, 1, 0.5)
r2.mar = 1 - rbinom(n, 1, logistic(y[, 1]))
r2.mnar = 1 - rbinom(n, 1, logistic(y[, 2]))


#
## Variance of the Missing Data

require(mice)

imp = mice(nhanes, print = FALSE, m = 10, seed = 24415)
fit = with(imp, lm(bmi ~ age))
pool(fit)

# the column estimate is the mean of all m imputation simulations variances.

# ubar = within simulation variance
# b = between simulation variance
# t = total variance (ubar + b)

# dfcom = degree of freedom under the hypothetically complete data
# df = degree of freedom after the Barnard-Rubin correction

# riv = relative increase in variance
# lambda = proportion of variance due to non-response
# fmi = fraction of missing information per parameter


