library(ggplot2)
# plot.vsTerms
# total=as.data.table(total)
# max_terms <- max(total[, Terms])
# dt_false <-
#     density(total[Markov_Success1 == FALSE, Terms], from = 0, to = max_terms)
# dt_true <-
#     density(total[Markov_Success1 == TRUE, Terms], from = 0, to = max_terms)
# 
# density_point_x <- dt_true$x[dt_false$y < dt_true$y][[1]]
# density_point_x <- round(density_point_x)
# density_point_y <- dt_true$y[dt_false$y < dt_true$y][[1]]
# geom_point(aes(x = density_point_x, y = density_point_y), colour = "grey50")

plot.vs=function(total,variable="Terms"){
    total=as.data.frame(total)
    Terms=rep(total$Terms,3)
    Nchar=rep(total$Nchar,3)
    Nchar_Digits=rep(total$Nchar_Digits,3)
    Avrg_Digits=rep(total$Avrg_Digits,3)
    Markov_Success=c(total$Markov_Success1,total$Markov_Success2,total$Markov_Success3)
    Type=rep(c("First Order Markov","Second Order Markov","
    Chinese Remainder Theorem"),each=10000);Type=as.factor(Type)
    newTotal=data.frame(Terms,Nchar,Nchar_Digits,Avrg_Digits,Markov_Success,Type)
    p= ggplot(newTotal,aes_string(x=variable))+
        geom_density(alpha = 0.5, aes(fill=Markov_Success,group = Markov_Success))+
        facet_wrap(~Type)+
        ggtitle(paste("Success_Failure related to",variable))
    if(variable=="Avrg_Digits"){
        p=p+xlim(0,10)
    }
    p
}
plot.vs2=function(total){
    total=as.data.frame(total)
    Terms=rep(total$Terms,3)
    Nchar=rep(total$Nchar,3)
    Nchar_Digits=rep(total$Nchar_Digits,3)
    Avrg_Digits=rep(total$Avrg_Digits,3)
    Markov_Success=c(total$Markov_Success1,total$Markov_Success2,total$Markov_Success3)
    Type=rep(c("First Order Markov","Second Order Markov","
               Chinese Remainder Theorem"),each=10000);Type=as.factor(Type)
    newTotal=data.frame(Terms,Nchar,Nchar_Digits,Avrg_Digits,Markov_Success,Type)
    ggplot(newTotal, aes(x = Terms, y = Nchar_Digits, colour = Markov_Success)) +
        geom_point(aes(group = Markov_Success), size = .2, alpha = .2) +
        geom_density2d(aes(group = Markov_Success), size = .5)+
        facet_wrap(~Type)
}

