library(bestglm)
library(DAAG)

#p226
model1 <- function(xin){
	sumx <- 0
	for(i in 1:10){
		sumx <- sumx + xin[i]
	}
	if(sumx>5){
		yout <- 1
	}else{
		yout <- 0
	}
	return(yout)
}
model <- function(xin){
	yout <- 10*xin[1]+9*xin[2]+8*xin[3]+7*xin[4]+6*xin[5]+5*xin[6]+4**xin[7]+3*xin[8]+2*xin[9]+1*xin[10]
	#yout <- 5*xin[1]+4*xin[2]+3*xin[3]+2*xin[4]+1*xin[5]
	#print(yout)
	return(yout)
}


d_hassei1 <- function(kazu){
#一様分布(0,1)で20個
X <- numeric(0)
for(i in 1:kazu){
	#set.seed(5)
	x <- c(runif(20,min=0,max=1))
	X <- rbind(X,x)
}
rownames(X) <- 1:kazu
colnames(X) <- paste("X",1:20,sep="")
#X <- scale(X)
#Yつくる
Y <- numeric(0)
for(i in 1:kazu){
	Y <- rbind(Y,model(X[i,]))
}
colnames(Y) <- "output"
D <- cbind(as.data.frame(X),output=Y)#D[,21]がY
return(D)
}

d_hassei <- function(kazu){
d <- list(NULL)
for(i in 1:kazu){
	d[[i]] <- d_hassei1(80)
}
return(d)
}

#データ100サンプル発生
d <- d_hassei(100)

#best subset regression
errmat <- matrix(0,nrow=100,ncol=20)
testSize <- 10000
test <- d_hassei1(testSize)#テストサンプル生成
for(i in 1:100){
	for(j in 1:20){
		moji <- paste(paste("X",1:j,sep=""), collapse="+" )
		out <- lm(paste("output~",moji),data=d[[i]])#パラメータ決定
		testX <- cbind(rep(1,testSize),test[,1:j])
		testy <- test[,21]
		tmp <- as.matrix(testX)%*%(as.matrix(out$coefficients)) - testy
		errmat[i,j] <- mean(tmp * tmp)
	}
	
}
err_mean <- colMeans(errmat)
plot(err_mean,xlab="Subset Size p",ylab="Error",xlim=c(1,20),ylim=c(min(errmat),max(errmat)),type="n",col="red",lwd=3)
for(i in 1:100){
	lines(errmat[i,],xlim=c(1,20),ylim=c(min(errmat),max(errmat)),type="l",col=i)
}
lines(err_mean,xlim=c(1,20),ylim=c(min(errmat),max(errmat)),type="l",col="red",lwd=3)
title("Prediction Error")


#K-fold closs validation
cverrs_kfold <- numeric(0)
for(i in 1:100){
	out <- bestglm(d[[i]],IC="CV",CVArgs=list(Method="HTF",K=10,REP=1))
	#out <- CVHTF(d[[i]][,-21],d[[i]][,21],K=10,REP=1,family=gaussian)
	#out<-cv.lm(df=d[[i]], form.lm=formula(paste("output~",moji)),m=10,printit=TRUE,plotit="Residual")
	cverrs_kfold <- rbind(cverrs_kfold,out$Subsets[,"CV"])
}
cverrs_kfold_mean <- colMeans(cverrs_kfold)
plot(cverrs_kfold_mean[-1],xlab="Subset Size p",ylab="Error",xlim=c(1,20),ylim=c(min(cverrs_kfold),max(cverrs_kfold)),type="n",col=1,lwd=3)
for(i in 1:100){
	lines(cverrs_kfold[i,-1],xlim=c(1,20),ylim=c(min(cverrs_kfold),max(cverrs_kfold)),type="l",col=i)
}
lines(err_mean,xlim=c(1,20),ylim=c(min(cverrs_kfold),max(cverrs_kfold)),type="l",col="red",lwd=3)
lines(cverrs_kfold_mean[-1],xlim=c(1,20),ylim=c(min(cverrs_kfold),max(cverrs_kfold)),type="l",col=1,lwd=3)
title("10-Fold CV Error")

#Leave-one-out closs varidation
cverrs_loo <- numeric(0)
for(i in 1:100){
	out <- bestglm(d[[i]],IC="LOOCV")
	cverrs_loo <- rbind(cverrs_loo,out$Subsets[,"LOOCV"])
}
cverrs_loo_mean <- colMeans(cverrs_loo)
plot(cverrs_loo_mean[-1],xlab="Subset Size p",ylab="Error",xlim=c(1,20),ylim=c(min(cverrs_loo),max(cverrs_loo)),type="n",col=1,lwd=3)
for(i in 1:100){
	lines(cverrs_loo[i,-1],xlim=c(1,20),ylim=c(min(cverrs_loo),max(cverrs_loo)),type="l",col=i)
}
lines(err_mean,xlim=c(1,20),ylim=c(min(cverrs_loo),max(cverrs_loo)),type="l",col="red",lwd=3)
lines(cverrs_loo_mean[-1],xlim=c(1,20),ylim=c(min(cverrs_loo),max(cverrs_loo)),type="l",col=1,lwd=3)
title("Leave-One-Out CV Error")


#Approximation Error
Err <- numeric(0)
for(i in 1:100)Err<-rbind(Err,t(err_mean))
CVK_Err <- cverrs_kfold[,-1]-Err
CVK_ErrT <- cverrs_kfold[,-1]-errmat
CVN_Err <- cverrs_loo[,-1]-Err
CVN_ErrT <- cverrs_loo[,-1]-errmat
CVK_Err <- apply(CVK_Err,c(1,2),abs)
CVK_ErrT <- apply(CVK_ErrT,c(1,2),abs)
CVN_Err <- apply(CVN_Err,c(1,2),abs)
CVN_ErrT <- apply(CVN_ErrT,c(1,2),abs)
CVK_Err <- colMeans(CVK_Err)
CVK_ErrT <- colMeans(CVK_ErrT)
CVN_Err <- colMeans(CVN_Err)
CVN_ErrT <- colMeans(CVN_ErrT)
a <- c(CVK_Err,CVK_ErrT,CVN_Err,CVN_ErrT)
plot(CVK_Err,xlab="SubSet Size p",ylab="Mean Absolute Deviation",xlim=c(1,20),ylim=c(min(a),max(a)),type="b",pch=20,col=1)
lines(CVK_ErrT,xlim=c(1,20),ylim=c(min(a),max(a)),type="b",pch=20,col=2)
lines(CVN_Err,xlim=c(1,20),ylim=c(min(a),max(a)),type="b",pch=5,col=1)
lines(CVN_ErrT,xlim=c(1,20),ylim=c(min(a),max(a)),type="b",pch=5,col=2)
title("Approximation Error")
legend("topright",legend=c("CV10_Err","CV10_ErrT","CVN_Err","CVN_ErrT"),col=c("black","red","black","red"),lty=c(2,2,2,2),pch=c(20,20,5,5))



