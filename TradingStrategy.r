### author: Yi Rong
### update on 12/30/20

rm(lis=ls())

# Packages required
library(TTR)
library(quantmod)

# Getting the data
stockData <- new.env()
lookup.symb=c("GOOG","FB","AAPL","NFLX","AMZN")
from.date=first.date <- Sys.Date()-365
getSymbols(lookup.symb, from=from.date, env=stockData, src="yahoo")
ReturnMatrix=NULL
PriceMatrix=NULL
for(i in 1:length(lookup.symb))
{
  tmp <- get(lookup.symb[i], pos=stockData)   # get data from stockData environment  
  PriceMatrix=cbind(PriceMatrix,Cl(tmp))
  ReturnMatrix=cbind(ReturnMatrix,   (Cl(tmp)-Op(tmp)) / Op(tmp)   )
  colnames(PriceMatrix)[i]=lookup.symb[i]
  colnames(ReturnMatrix)[i]=lookup.symb[i]
}

# Finding Moving Averages
DAYMA50=function(x) SMA(x,n=50)
DAYMA200=function(x) SMA(x,n=200)
DF50=apply(PriceMatrix,2,DAYMA50)
DF200=apply(PriceMatrix,2,DAYMA200)

# Computing Signals
temp=as.data.frame(tail(DF200,1)<tail(DF50,1))
LastPrice=as.data.frame(tail(PriceMatrix,1))
# Make the data frame
result=data.frame("Ticker"=character(),"Signal"=character(),"Quant"=integer())


for(i in lookup.symb){
  if(temp[i]==TRUE){signal="BUY"}else{signal="SELL"}
  t=data.frame("Ticker"=i,"Signal"=signal,"Quant"=floor(as.numeric(10000/LastPrice[i])))
  result=rbind(result,t)  
}
write.csv(result,"Signals.csv")



















