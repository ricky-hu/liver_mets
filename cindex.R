#computes Harrell's C-Index and standard deviation from a csv file of risks, times, and events
require('Hmisc')

data <- read.csv("preds.csv")
risk <- unlist(data[1])
time <- unlist(data[2])
event <- unlist(data[3])
results <- rcorr.cens(risk, Surv(time,event))

ci = pmax(results['C Index'], (1-results['C Index']))
std = results['S.D.']/2

df = data.frame(ci, std)
write.csv(df, 'ci.csv', row.names = FALSE)
