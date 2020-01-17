
require(mice)


# Exercise, using nhanes dataset

head(nhanes)

# complete cases
ncc(nhanes)

# percentage of complete cases
ncc(nhanes)/nrow(nhanes) # 52%


# do normal linear regression imputation
set.seed(1)

imp = mice(nhanes, method = "norm.predict", m = 50, print = FALSE)

fit = with(imp, lm(bmi ~ age + hyp + chl))

# calculate summary statistics of the imputations
pool(fit)
# proportin of variance due to missing data = 0.076%


## simulate different values of M (number of simulations for the imputations)

# set the parameters
m_val = seq(2,200,5)
dat = data.frame()

for(i in 1:length(m_val)) {
  set.seed(1)
  
  imp = mice(nhanes, method = "norm.predict", m = m_val[i], print = FALSE)
  fit = with(imp, lm(bmi ~ age + hyp + chl))
  
  dat[i, 1] = m_val[i]
  dat[i, 2] = pool(fit)$pooled$lambda[2]
  
}

# plot the V2 = proportion of variance due to missing data against V1 = m
plot(dat$V1, dat$V2)




