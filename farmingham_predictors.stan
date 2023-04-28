data {
  int<lower=0> N;
  int<lower=0> K;
  int<lower=0> N_test;
  int y [N];
  matrix [N,K] predictors; 
  matrix [N_test,K] test_set;
}

parameters {
vector [K] beta;
}

model {
  y ~ bernoulli_logit(predictors*beta);
}

generated quantities{
  vector [N] log_lik;
  vector [N] y_preds;
  real y_test_preds [N_test];
  
  for (i in 1:N){
    log_lik[i] = bernoulli_logit_lpmf(y[i]|predictors[i]*beta);
    y_preds[i] = inv_logit(predictors[i]*beta);
  }
  
  for (i in 1:N_test){
    y_test_preds[i] = inv_logit(test_set[i]*beta);
  }
  
}
