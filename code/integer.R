library(ggplot2)
library(markovchain)
library(data.table)
library(stringr)
rm(list=ls())
SAMPLE_SIZE <- 10000
training=read.csv("train.csv",stringsAsFactors = F)
training <- as.data.table(training)
set.seed(pi)
training <- training[sample(.N, SAMPLE_SIZE)]
training[, Last := str_extract(Sequence, "\\-?\\d*$")]
training[, Problem := gsub("\\,\\-?\\d*$", "\\1", Sequence)]

source("temp.R")

# LEN=SAMPLE_SIZE
# predict_ans=data.frame(Last=training$Last[1:LEN])
# predict_ans=as.data.table(predict_ans)
# for (m in 1:2){
#     markov_result <- t(sapply(training[1:LEN, Problem], markov_predict,n=1,method=m))
#     if(m==1) colnames(markov_result)=c("1阶预测结果","1阶预测概率")
#     if(m==2) colnames(markov_result)=c("2阶预测结果","2阶预测概率")
#     predict_ans=cbind(predict_ans,markov_result)
#     if(m==1) predict_ans$Markov_Success1 = (predict_ans$Last == as.numeric(unlist(predict_ans[,2])))
#     if(m==2) predict_ans$Markov_Success2 = (predict_ans$Last == as.numeric(unlist(predict_ans[,5])))
# }
# crt.count=0
# crt.result=t(sapply(training[1:LEN, Problem],crt.predict))
# colnames(crt.result)=c("crt result","crt likelihood")
# predict_ans=cbind(predict_ans,crt.result)
# predict_ans[,9]=ifelse(predict_ans[,9]=="oo","crt","markov")
# predict_ans$Markov_Success3 = (predict_ans$Last == as.numeric(unlist(predict_ans[,8])))
# #predict_ans[,Markov_Prediction := unlist(Markov_Prediction)]
# #predict_ans[,Markov_Loglikelihood := unlist(Markov_Loglikelihood)]
# print_accuracy(predict_ans)

LEN=SAMPLE_SIZE
predict_ans=data.frame(Last=training$Last[1:LEN])
predict_ans=as.data.table(predict_ans)

markov_result <- t(sapply(training[1:LEN, Problem], markov_predict,n=1,m2="mle"))
colnames(markov_result)=c("mle.result","1阶预测概率")
predict_ans=cbind(predict_ans,markov_result)
predict_ans$Markov_Success1 = (predict_ans$Last == as.numeric(unlist(predict_ans[,2])))

markov_result <- t(sapply(training[1:LEN, Problem], markov_predict,n=1,m2="laplace"))
colnames(markov_result)=c("laplace.result","1阶预测概率")
predict_ans=cbind(predict_ans,markov_result)
predict_ans$Markov_Success2 = (predict_ans$Last == as.numeric(unlist(predict_ans[,5])))
save(predict_ans,file = "es_method.Rdata")
print_accuracy2(predict_ans)
