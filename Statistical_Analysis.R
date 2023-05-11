
install.packages("ggstatsplot")
install.packages("qqplotr")
install.packages("RVAideMemoire")
install.packages("fBasics")
install.packages("car")
install.packages("corrplot")
install.packages("caret")
install.packages("doBy")
install.packages("TTR")
install.packages("forecast")

library(car)
library(corrplot)
library(caret)
library(tidyverse)
library(fBasics)
library(RVAideMemoire)
library(datarium)
library(qqplotr)
library(ggplot2)
library(car)
library(doBy)
library(ggstatsplot)
library(dplyr)
library(TTR)
library(forecast)

dataset <- read.csv('R_HIV_dataset.csv', header = TRUE)

### Descriptive analysis ###
head(dataset)
dataset$HDI = as.factor(dataset$HDI)
summary(dataset)
str(dataset)
hist(dataset$Deaths.by.AIDS)

#select unique values in team and points columns
dataset %>% distinct(Country, HDI)

numeric_data = dataset[ ,c("Deaths.by.AIDS","TOTAL.PLWH","TOTAL.PNIWH")]
head(numeric_data)
boxplot(numeric_data)

#basic stats
basicStats(numeric_data)
options(scipen = 999)
basicStats(numeric_data)
plot(numeric_data)

boxplot(numeric_data,horizontal = TRUE)

#normality test visual before transformation
qqnorm(dataset$Deaths.by.AIDS, col=6)
qqline(dataset$Deaths.by.AIDS, col=3)

#Transformation
norm_deaths = as.data.frame(log10(dataset$Deaths.by.AIDS))
norm_PLWH = as.data.frame(log10(dataset$TOTAL.PLWH))
norm_PNIWH = as.data.frame(log10(dataset$TOTAL.PNIWH))

#Renaming column name
names(norm_deaths)[names(norm_deaths)=="log10(dataset$Deaths.by.AIDS)"] = "Deaths"
names(norm_PLWH)[names(norm_PLWH)=="log10(dataset$TOTAL.PLWH)"] = "PLWH"
names(norm_PNIWH)[names(norm_PNIWH)=="log10(dataset$TOTAL.PNIWH)"] = "PNIWH"

norms_d = data.frame(norm_deaths,norm_PLWH,norm_PNIWH)

numeric_data = norms_d

#Merging with dataset
new_dataset = data.frame(dataset,numeric_data)
numeric_data = new_dataset[ ,c("Deaths", "ART.PLWH", "ART.PMTCT.LWH", "Undernourished",
                               "PLWH", "PNIWH")]

#normality test visual after transformation
qqnorm(new_dataset$Deaths, col=6)
qqline(new_dataset$Deaths, col=3)

#outlier
boxplot(Deaths.by.AIDS ~ HDI, data = dataset, names=c("High","Low"),
        xlab="HDI", ylab="# of Deaths",
        main="Deaths by HDI")

#resolved outlier
boxplot(Deaths ~ HDI, data = new_dataset, names=c("High","Low"),
        xlab="HDI", ylab="# of Deaths",
        main="Deaths by HDI")


### correlation ###
corrplot(cor(numeric_data),method = "number", type = "upper")


### Regression ###
#MLR
#splitting my data set
least_dev = new_dataset[new_dataset$HDI=='Low',]
least_dev

developed = new_dataset[new_dataset$HDI=='High',]
developed

#numerical var for least dev
least_dev_num_var = least_dev[ ,c("Deaths", "ART.PLWH", "ART.PMTCT.LWH", "Undernourished",
                                  "PLWH", "PNIWH")]
least_dev_num_var

corrplot(cor(least_dev_num_var),method = "number", type = "lower")

#model trials
model_1 = lm(Deaths ~ PNIWH, least_dev_num_var)
summary.lm(model_1)

model_2 = lm(Deaths ~ PNIWH + PLWH, least_dev_num_var)
summary.lm(model_2)

model_3 = lm(Deaths ~ PNIWH + PLWH + Undernourished, least_dev_num_var)
summary.lm(model_3)
pairs(least_dev_num_var[,c(1,6,5,4)], lower.panel = NULL, pch = 19, cex = 0.2)

model_3a = lm(Deaths ~ PNIWH + Undernourished, least_dev_num_var)
summary.lm(model_3a)
pairs(least_dev_num_var[,c(1,6,5,4)], lower.panel = NULL, pch = 19, cex = 0.2)
vif(model_3a)

model_4 = lm(Deaths ~ PNIWH + PLWH + ART.PMTCT.LWH + Undernourished, least_dev_num_var)
summary.lm(model_4)
data.frame(colnames(least_dev_num_var))
pairs(least_dev_num_var[,c(1,6,5,3,4)], lower.panel = NULL, pch = 19, cex = 0.2)

#final MLR model
model_4a = lm(Deaths ~ PNIWH + ART.PMTCT.LWH + Undernourished, least_dev_num_var)
summary.lm(model_4a)
pairs(least_dev_num_var[,c(1,6,3,4)], lower.panel = NULL, pch = 19, cex = 0.2)

plot(model_4a,1)
plot(model_4a,2)
plot(model_4a,3)
vif(model_4a)

### Time series ###
#Case study of Ghana

case_study = new_dataset[new_dataset$Country == 'Ghana', ]
case_study
ghana = case_study[ ,c("Deaths.by.AIDS")]

ghanatimeseries <- ts(ghana, frequency=1, start=c(2010,1))

#plotting
plot.ts(ghanatimeseries)

#decomposing/smoothing
ghanaSMA3 <- SMA(ghanatimeseries,n=3)
plot.ts(ghanaSMA3)

#in-sample forecast
ghanaforecasts <- HoltWinters(ghanatimeseries, gamma=FALSE)
ghanaforecasts

ghanaforecasts$SSE
plot(ghanaforecasts)

#forecasting 10 years using Holt
ghanaforecasts_2 <- forecast(ghanaforecasts, h=10)
plot(ghanaforecasts_2)

acf(ghanaforecasts_2$residuals, lag.max=10, na.action = na.pass)
Box.test(ghanaforecasts_2$residuals, lag=8, type="Ljung-Box")

# make time series plot for errors
plot.ts(ghanaforecasts_2$residuals) 

# make a histogram
ghanaforecasts_2$residuals <- ghanaforecasts_2$residuals[!is.na(ghanaforecasts_2$residuals)]

#forecast function
plotForecastErrors <- function(forecasterrors)
{
  # make a histogram of the forecast errors:
  mybinsize <- IQR(forecasterrors)/4
  mysd   <- sd(forecasterrors)
  mymin  <- min(forecasterrors) - mysd*5
  mymax  <- max(forecasterrors) + mysd*3
  # generate normally distributed data with mean 0 and standard deviation mysd
  mynorm <- rnorm(10000, mean=0, sd=mysd)
  mymin2 <- min(mynorm)
  mymax2 <- max(mynorm)
  if (mymin2 < mymin) { mymin <- mymin2 }
  if (mymax2 > mymax) { mymax <- mymax2 }
  # make a red histogram of the forecast errors, with the normally distributed data overlaid:
  mybins <- seq(mymin, mymax, mybinsize)
  hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
  # freq=FALSE ensures the area under the histogram = 1
  # generate normally distributed data with mean 0 and standard deviation mysd
  myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
  # plot the normal curve as a blue line on top of the histogram of forecast errors:
  points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
}

plotForecastErrors(ghanaforecasts_2$residuals) 

### Comparative Analysis ###
#Anova assumptions failed
one_anova = new_dataset %>%
  select(-Deaths.by.AIDS,-ART.PLWH,-ART.PMTCT.LWH,-Undernourished,-TOTAL.PLWH,-TOTAL.PNIWH,-PLWH,-PNIWH)

#Assumptions 4-6
boxplot(Deaths ~ HDI, data = one_anova, names=c("High","Low"),
        xlab="HDI", ylab="# of Deaths",
        main="Deaths by HDI")

#5
byf.shapiro(Deaths ~ HDI, data = one_anova)

bartlett.test(Deaths ~ HDI, data = one_anova)


#Wilcoxon on raw data
WilTestR = new_dataset %>%
  select(HDI,Deaths.by.AIDS)

ggplot(WilTestR) +
  aes(x = HDI, y = Deaths.by.AIDS, fill = HDI) +
  geom_boxplot() +
  theme(legend.position = "none")

testR = wilcox.test(WilTestR$Deaths.by.AIDS ~ WilTestR$HDI)
testR


#Wilcoxon on transformed data
WilTestT = new_dataset %>%
  select(HDI,Deaths)

ggplot(WilTestT) +
  aes(x = HDI, y = Deaths, fill = HDI) +
  geom_boxplot() +
  theme(legend.position = "none")

testT = wilcox.test(WilTestT$Deaths ~ WilTestR$HDI)
testT

#plot with statistical results
ggbetweenstats(
  data = WilTestT,
  x = HDI,
  y = Deaths,
  plot.type = "box",
  type = "nonparametric",
  centrality.plotting = FALSE
)

