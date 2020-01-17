
require(mice)


# Suppose that you are interested on determining ß in the linear model
# model: y = α + x_i ß + ε_i    |  ε_i ~ N(0, σ^2)
# suppose the true value are α = 0, ß = 1, and σ^2 = 1.
# we have 50% missing data and compare two imputation methods = regression imputation and stocastic regression imputation.

# A function to create data
create.data = function(beta = 1, sigma2 = 1, n = 50, run = 1){
  set.seed(seed = run)
  x = rnorm(n)
  y = beta * x + rnorm(n, sd = sqrt(sigma2))
  cbind(x = x, y = y)
}

#
# A function to remove some data

make.missing = function(data, p = 0.5){
  rx = rbinom(nrow(data), 1, p)
  data[rx == 0, "x"] = NA
  data
}

#
# A function to do tests from mice package

test.impute = function(data, m = 5, method = "norm", ...){
  
  imp = mice(data, method = method, m = m, print = FALSE, ...)
  fit = with(imp, lm(y ~ x))
  tab = summary(pool(fit), "all", conf.int = TRUE)
  as.numeric(tab["x", c("estimate", "2.5 %", "97.5 %")])
}

#
# Then, this is a function that simulates everything

simulate = function(runs = 10){
  res = array(NA, dim = c(2, runs, 3))
  dimnames(res) = list(c("norm.predict", "norm.nob"),
                       as.character(1:runs),
                       c("estimate", "2.5 %", "97.5 %"))
  
  for(run in 1:runs){
    data = create.data(run = run)
    data = make.missing(data)
    res[1, run, ] = test.impute(data, method = "norm.predict", m = 2)
    res[2, run, ] = test.impute(data, method = "norm.nob")
  }
  
  res
}

#
## run it 1000 times
res = simulate(1000)

# lower and upper CI
apply(res, c(1, 3), mean, na.rm = TRUE)

#
# And then calculate the evalution statistics
true = 1 # this is the true ß value

raw_bias = rowMeans(res[,, "estimate"]) - true
percent_bias = 100 * abs((rowMeans(res[,, "estimate"]) - true)/true)
coverage_rate = rowMeans(res[,,"2.5 %"] < true & true < res[,, "97.5 %"])   # proportion of CI that contain the true value
average_width = rowMeans(res[,, "97.5 %"] - res[,, "2.5 %"])   # average width of the confidence interval
rmse = sqrt(rowMeans((res[,, "estimate"] - true)^2 ))

data.frame(raw_bias, percent_bias, coverage_rate, average_width, rmse)

# norm.predict = is the standard regression imputation
# norm.nob = is the stochastic regression imputation






