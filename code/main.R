library(matlab)
library(markovchain)

MAXNUM=10000
crt.count=0
getBigMatrix=function(A,num,target){
    # 矩阵A, 一共num个对象，目标为target,当前质数为i
    #A <- matrix(c(1,2,3,4), nrow=2, ncol=2)
    x=ncol(A);
    y=nrow(A);
    if(x!=y || num %% x!=0){
        return(NULL)
    }
    times=num/x
    k=target%%x
    A=as.vector(A[(k+1),])
    temp=rep(A,times)
    return(temp)
}
findPrimeMultiple=function(num,len){
   # num=20;len=20
    if(num<=1){
        num=2;
    }
    if(num<10){
        temp=primes(num*5)
    }else{
        temp=primes(num)
    }

    ans=1;i=1;
    result=c()
    while(TRUE){
        p=temp[i]
        if(len>1){
            x=floor(log(len-1,base = p))
        }else{
            x=1
        }
        if(x==0){
            x=1
        }
        if(ans*p^x>num*2){
            result=c(result,p^x)
            break;
        }else if(ans*p^x>num){
            result=c(result,p^x,temp[i+1])
            break;
        }else{
            ans=ans*p^x;
            result=c(result,p^x)
        }
        i=i+1;
    }
    return(result)
    # t=cumprod(p)
    # m=min(which(t>num))
    # if(p[m+1]>len && length(p)>=4){
    #     p[1:4]=c(5,7,8,9)
    #     t=cumprod(p)
    #     m=min(which(t>num))
    # }
    # return(p[1:(m+1)])
}
reorderMatrix=function(A,states,p){
    # 矩阵A，根据states进行重排，质数p
    #p=13
    #A=mk$estimate@transitionMatrix
    #states=mk$estimate@states
    states=as.integer(states)
    o=order(states)
    s=sort(states)
    
    len=length(o)
    A2=matrix(rep(0,len*len),len,len)
    for(i in 1:len){
        for (j in 1:len){
            A2[i,j]=A[o[i],o[j]]
        }
    }

    
    C=matrix(rep(1/p,p*p),p,p)
    C[s+1,]=rep(0,p)
    #[,s+1]=rep(0,p)
    for (i in 1:len){
        for (j in 1:len){
            C[s[i]+1,s[j]+1]=A2[i,j]
        }
    }
    #全零修正
    for (i in 1:p){
        if(sum(C[i,]==0)==p){
            C[i,]=rep(1/p,p)
        }
    }
    colnames(C)=0:(p-1)
    row.names(C)=0:(p-1)
    return(C)
}
processInteger=function(v){
    test= unlist(str_split(v, ","))
    test=as.numeric(test)
    if(sum(is.na(test))==0){
        return(test)
    }else{
        return(NULL)
    }
}
markov_predict <- function(my_problem, is.Integer=FALSE, n = 1L, method=1L,m2="mle") {
    # my_problem=training$Problem[1]
    #    n=1;method=2
    if(!is.Integer){
        my_problem <- unlist(str_split(my_problem, ","))
    }
    len=length(my_problem)
    if(method==2){
        if(len<2){
            answer <-
                list("Markov_Prediction" = 0,
                     "Markov_Loglikelihood" = 100) 
            return(answer)
        }
        ans=numeric(len-1)
        for (i in 1:(len-1)){
            temp=my_problem[i:(i+1)]
            temp=paste(temp,collapse = ",")
            ans[i]=temp
        }
        new_data <- ans[(len - n):len-1]
        mk <- markovchainFit(ans)
        prediction <- predict(object = mk$estimate,
                              newdata = new_data,
                              n.ahead = 1L)
        loglike <- mk$logLikelihood
        
        answer <-
            list("Markov_Prediction" = unlist(strsplit(prediction,","))[2],
                 "Markov_Loglikelihood" = loglike) 
    }
    if(method==1){
        new_data <- my_problem[(len - n + 1L):len]
        mk <- markovchainFit(my_problem,method = m2)
        prediction <- predict(object = mk$estimate,
                              newdata = new_data,
                              n.ahead = 1L)
        loglike <- mk$logLikelihood
        
        answer <-
            list("Markov_Prediction" = prediction,
                 "Markov_Loglikelihood" = loglike) 
    }
    
    return(answer)
}
crt.predict=function(v){
    #v=training[1,Problem]
    v=c(3,7,10,8,9,17,17,16)
    if(is.character(v)){
        v=processInteger(v)
    }
    if(length(v)==0){
        answer <-
            list("Markov_Prediction" = 0,
                 "Markov_Loglikelihood" = 100) 
        return(answer)
    }
        min.val=min(v)
        v=v-min.val
        if(max(v)>MAXNUM){
            return(markov_predict(v,is.Integer = T))
        }
        NUM=v[length(v)]
        prime=findPrimeMultiple(max(v),length(v))
        n=prod(prime)
        #print(prime)
        #print(n)
        ans=rep(1,n)
        for (i in prime){
            mk <- markovchainFit(v%%i)
            tempMatrix=reorderMatrix(mk$estimate@transitionMatrix,mk$estimate@states,i)
            temp=getBigMatrix(tempMatrix,n,NUM)
            ans=ans*temp
        }
        answerTemp=which(ans==max(ans))-1
        prediction=0
        if(length(answerTemp)>1) {
            prediction=sample(answerTemp,1)
        }else{
            prediction=answerTemp
        }
        answer <-
            list("Markov_Prediction" = prediction+min.val,
                 "Markov_Loglikelihood" = "oo") #log(1/length(answerTemp)
        crt.count=crt.count+1
        return(answer)
}
print_accuracy=function(predict_ans){
    m=(length(colnames(predict_ans))-1)/3
    markov_accuracy <-
        (100 * predict_ans[Markov_Success1 == TRUE, .N]) / predict_ans[, .N]
    cat("Markov Accuracy with first order:", round(markov_accuracy , 4), "%\n")
    if(m>=2){
        markov_accuracy <-
            (100 * predict_ans[Markov_Success2 == TRUE, .N]) / predict_ans[, .N]
        cat("Markov Accuracy with second order:", round(markov_accuracy , 4), "%\n")
    }
    if(m>=3){
        markov_accuracy <-
            (100 * predict_ans[Markov_Success3 == TRUE, .N]) / predict_ans[, .N]
        cat("Markov Accuracy with crt:", round(markov_accuracy , 4), "%\n")
    }
}
print_accuracy2=function(predict_ans){
    m=(length(colnames(predict_ans))-1)/3
    markov_accuracy <-
        (100 * predict_ans[Markov_Success1 == TRUE, .N]) / predict_ans[, .N]
    cat("Markov Accuracy with mle:", round(markov_accuracy , 4), "%\n")
    if(m>=2){
        markov_accuracy <-
            (100 * predict_ans[Markov_Success2 == TRUE, .N]) / predict_ans[, .N]
        cat("Markov Accuracy with laplace:", round(markov_accuracy , 4), "%\n")
    }
    if(m>=3){
        markov_accuracy <-
            (100 * predict_ans[Markov_Success3 == TRUE, .N]) / predict_ans[, .N]
        cat("Markov Accuracy with crt:", round(markov_accuracy , 4), "%\n")
    }
}

crt.predict(primes(20))

