n <- 1000000

#Q1
q1 = mean(rnorm(n, mean=4.1, sd=0.168) < rnorm(n, mean=4.29, sd=0.163))

#Q2
q2 = dnorm(log(80),4.29,0.163) / dnorm(log(80),4.1,0.168)

#q3
q3 = pnorm(log(90), 4.1,0.168) - pnorm(log(80), 4.1,0.168)

#q4
q4 = exp(qnorm(0.7,4.29,0.163))

#q5
q5 = 1-pnorm(log(65), 4.29, 0.163,lower.tail = FALSE)

#q6
set.seed(3304)
n <- 100
myint <- 5
myslope <- (-1)
mysd <- 0.05
xy.df <- data.frame(x = sort(rnorm(n)))
xy.df <- transform(xy.df, y = rnorm(n, myint + myslope * x, mysd))
fit4 <- lm(y ~ x, data = xy.df)
summary(fit4)
myci <- predict(fit4, xy.df, interval = "confidence", level = 0.9)
mypi <- predict(fit4, xy.df, interval = "prediction", level = 0.9)
#check some of the options
# new_values = data.frame(x=c(0))
# predict(fit4, new_values, interval = "confidence", level = 0.9)
# predict(fit4, new_values, interval = "predict", level = 0.9)

#Q8
set.seed(4321)
n <- 1000
xy0.df <- data.frame(x = seq(-1, 1.5, length = n))
xy0.df <- transform(xy0.df, y = rpois(n, lambda = exp(-1.5 - x)))
fit0 <- glm(y ~ x,poisson,data=xy0.df)
summary(fit0)
lfit0 <- predict(fit0, type = "link")
rfit0 <- predict(fit0, type = "resp")
cfit0 <- confint(fit0)


#Q7
Nsim <- 1000
betas <- matrix(0, Nsim, length(coef(fit0)))
for (i in 1:Nsim) {
  xy0.df <- transform(xy0.df, ysim = rpois(n, exp(-1.5 - x)))
  mod_i <- glm(ysim ~ x, poisson, data=xy0.df)
  betas[i, ] <- coef(mod_i)
}
(q2 <- quantile(betas[, 2], c(0.025, 0.975)))
(dd <- mean(betas[, 2] + 1))

#coverage 
captured = (-0.933 >= q2[1]) & (-0.933 <= q2[2])
mean(captured)

#Q9
Nsim <- 100
n <- 10
N <- 100
lambda <- 4
means <- numeric(Nsim)
for (i in 1:Nsim) {
  xvec <- rpois(N, lambda)
  means[i] <- mean(xvec[sample(1:N, n)])
}
