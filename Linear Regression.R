setwd("~/RWork/SLR")
library(dplyr)
library(caTools)
library(ggplot2)
library(stringr)
Batting<- read.csv("Team batting.csv", header=TRUE, stringsAsFactors = FALSE)

#Select only Player, Player year, Runs and Batting Avg column
dfbat<-
  Batting %>%
  select(Country, Matches.Won , Highest.Team.Score.Batting)



#Split Training and Testing data
split<- sample.split(dfbat$Matches.Won, SplitRatio = 0.75)

training<-subset(dfbat, split==TRUE)

test<-subset(dfbat, split==FALSE)

#train model for training data
my_model<-lm(formula = Matches.Won ~ Highest.Team.Score.Batting, data= training)

#predict with test data
prediction<-predict(my_model, newdata = test)


#plot for Training data
ggplot()+
  geom_point(aes(x=training$Highest.Team.Score.Batting, y=training$Matches.Won), color = 'blue') +
  geom_line(aes(training$Highest.Team.Score.Batting, y= predict(my_model, newdata= training)), color= 'red') +
  ggtitle('Matches Won vs Highest Totals (Training)')+
  xlab('Highest Totals')+
  ylab('Matches Won')


#plot for testing data
ggplot()+
  geom_point(aes(x=test$Highest.Team.Score.Batting, y=test$Matches.Won), color = 'blue') +
  geom_line(aes(test$Highest.Team.Score.Batting, y= predict(my_model, newdata= test)), color= 'red') +
  ggtitle('Matches Won vs Highest Totals (Testing Data)')+
  xlab('Highest Totals')+
  ylab('Matches Won')



summary(my_model)
#my_model$coefficients

#p-value lower than 0.05 means there is a definite relation between the two variales.

#RSE percentage. Lower the better
sigma(my_model)*100/mean(dfbat$Matches.Won)

#R squared = 0.5431
