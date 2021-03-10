# install.packages(c("usethis", "devtools"))
library(usethis)
library(devtools)
library(amss)

n.years <- 4
time.n <- n.years * 52


# kActivityStates
# [1] "inactive"    "exploration" "purchase" 
activity.transition <- matrix(
  c(0.6, 0.3, 0.1,
    0.6, 0.3, 0.1,
    0.6, 0.3, 0.1),
  nrow = length(kActivityStates), byrow = TRUE
)

# kFavorabilityStates
# [1] "unaware"            "negative"           "neutral"           
# [4] "somewhat favorable" "favorable"
favorability.transition <- matrix(
  c(0.03, 0.07, 0.65, 0.20, 0.05,
    0.03, 0.07, 0.65, 0.20, 0.05,
    0.03, 0.07, 0.65, 0.20, 0.05,
    0.03, 0.07, 0.65, 0.20, 0.05,
    0.03, 0.07, 0.65, 0.20, 0.05),
  nrow = length(kFavorabilityStates), byrow = TRUE
)

# sin(x * 0.25) + 0.6
market.rate.nonoise <- SimulateSinusoidal(n.years * 52, 52, 
                                          vert.translation = 0.6,
                                          amplitude = 0.25)
plot(market.rate.nonoise)

market.rate.seas <- pmax(
  0, pmin(
    1, market.rate.nonoise, 
    SimulateAR1(length(market.rate.nonoise), 1, 0.1, 0.3)
  )
)
# plot(SimulateAR1(length(market.rate.nonoise), 1, 0.1, 0.3))


nat.mig.params <- list(
  population = 2.4e8,
  market.rate.trend = 0.68, 
  market.rate.seas = market.rate.seas, 
  prop.activity = c(0.375, 0.425, 0.2),
  prop.favorability = c(0.03, 0.07, 0.65, 0.2, 0.05),
  prop.loyalty = c(1, 0, 0), 
  transition.matrices = list(
    activity=activity.transition, 
    favorability = favorability.transition)
)

