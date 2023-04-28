# https://www.analyticsvidhya.com/blog/2016/03/practical-guide-deal-imbalanced-classification-problems/
setwd("~/Documents/PERSONAL/UNF/MCIS-DS/SEMESTER II - Spring/Data Analytics/Project")
library(rstan)
library(ROSE)

data <- read.csv('clean.csv')
str(data)

# OVERSAMPLE THE MINORITY CLASS TO BALANCE THE DATASET

# over <- ovun.sample(TenYearCHD~., data = train, method = "over", N = 5000)$data
data <- ovun.sample(TenYearCHD~., data = train, method = "over", N = 5000)$data
table(data$TenYearCHD)

 # Split data into training and validation set;

sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob=c(0.7,0.3))
train  <- data[sample, ]
test   <- data[!sample, ]


# Modal 0; consider the response variable without predictors: 

y <- train$TenYearCHD
N <- length(y)
stan_data <- list(N=N,y=y)
model1 = stan(file='null_model.stan',data=stan_data,cores=4)
print(model1,pars=c('alpha'))
y_preds = extract(model1)$y_preds
dim(y_preds)


## Model 1: Add predictors: 
y <- train$TenYearCHD;
predictors <- model.matrix(~.,data=train[,-1])
test_set <- model.matrix(~.,test[,-1])
stan_data2 <- list(N=length(y),y=y,K=ncol(predictors),predictors=predictors,N_test=nrow(test_set),test_set=test_set)

model2 <- stan(file='farmingham_predictors.stan',data=stan_data2,cores=4)
print(model2,pars=c('beta'))
y_test_preds <- extract(model2)$y_test_preds


library(loo)
loo1 = loo(model1)
loo2 = loo(model2)

loo_compare(loo1,loo2)
loo_model_weights(loo1,loo2)

