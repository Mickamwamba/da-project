data {
  int<lower=0> N;
  int y [N];
}

parameters {
real alpha;
}

model {
  y ~ bernoulli_logit(alpha);
}

generated quantities{
  vector [N] log_lik;
  vector [N] y_preds;
  
  for (i in 1:N){
    log_lik[i] = bernoulli_logit_lpmf(y|alpha);
    y_preds[i] = inv_logit(alpha);
  }
  
}
