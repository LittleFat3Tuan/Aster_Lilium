# This script is writted to develope the procedure for computing expected fitness of
# random effect aster model with a subsampling node. The principle idea of this procedure 
# is borrowed from Prof. Daniel Eck's summer project write-up and Prof. Geyer's TR696(
# https://conservancy.umn.edu/handle/11299/152355). Please refer to those technical reports
# for theoretical details.


library(aster)
library(tidyverse)
redata <- read.csv("Lilium_processed.csv")
redata$site <- as.factor(redata$site)
redata$varb <- as.factor(redata$varb)
redata$Nid <- as.numeric(gsub("[^0-9.-]", "", redata$id))

orgdata <- read.csv("data/output/remLilium2021Data.csv")
orgdata <- orgdata[orgdata$site != "lf",]
orgdata <- orgdata[orgdata$site != "wrrx",]
orgdata <- orgdata %>% mutate(flNotConsumed = replace(flNotConsumed, flCt==0&flNotConsumed==1, 0))
orgdata[is.na(orgdata$nCapsulesHarvested), 'nCapsulesHarvested'] <- 0
orgdata[is.na(orgdata$ovuleCt), 'ovuleCt'] <- 0
orgdata[is.na(orgdata$embryoCt), 'embryoCt'] <- 0

sitebeng <- as.numeric(redata$site == "beng")
sitehegg <- as.numeric(redata$site == "hegg")
sitesppe <- as.numeric(redata$site == "sppe")
sitesppw <- as.numeric(redata$site == "sppw")
varbflCt <- as.numeric(redata$varb == "flCt")
varbflNotConsumed <- as.numeric(redata$varb == "flNotConsumed")
varbcapsuleCt <- as.numeric(redata$varb == "capsuleCt")
varbisHarvested <- as.numeric(redata$varb == "isHarvested")
varbovuleCt <- as.numeric(redata$varb == "ovuleCt")
varbembryoCt <- as.numeric(redata$varb == "embryoCt")
redata <- cbind(redata, sitebeng, sitehegg, sitesppe, sitesppw, 
                varbflCt, varbflNotConsumed, varbcapsuleCt, varbisHarvested, varbovuleCt, varbembryoCt)


# Fit random effects model
pred <- c(0,1,2,3,4,5)
fam <- c(2,1,2,1,2,1)

remodel1 <- reaster(resp ~ -1 +  varb + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                                        + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                    list(site = ~0 + fit:site),
                    pred, fam,varb,Nid,root,data=redata)

remodel1 <- reaster(resp ~ varbcapsuleCt  + varbflNotConsumed + varbflCt
                    + varbisHarvested + varbovuleCt + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                                             + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                    list(site = ~0 + fit:site),
                    pred, fam,varb,Nid,root,data=redata)

remodel1 <- reaster(resp ~ varb + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                                             + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                    list(site = ~0 + fit:site),
                    pred, fam,varb,Nid,root,data=redata)

# Fit fixed effects model
femodel1 <- aster(resp ~ -1 + varbembryoCt +  varbcapsuleCt  + varbflNotConsumed + varbflCt
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                          + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

femodel1 <- aster(resp ~ -1 + varbcapsuleCt  + varbflNotConsumed + varbflCt
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

femodel1 <- aster(resp ~ -1 + varbflNotConsumed + varbflCt
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

femodel1 <- aster(resp ~ varbcapsuleCt  +  varbflCt
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)



femodel1 <- aster(resp ~ varbcapsuleCt  + varbflNotConsumed + varbflCt
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

femodel1 <- aster(resp ~ varbcapsuleCt  + varbflNotConsumed + varbflCt
                  + varbisHarvested + varbovuleCt + fit:(sitebeng+sitehegg+sitesppw)
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

# remove ovuleCt
femodel1 <- aster(resp ~ varbcapsuleCt  + varbflNotConsumed + varbflCt
                  + varbisHarvested + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

# remove flCt
femodel1 <- aster(resp ~ varbcapsuleCt  + varbflNotConsumed 
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

# remove capsuleCt
femodel1 <- aster(resp ~ varbflNotConsumed + varbflCt
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

# remove flNotConsumed
femodel1 <- aster(resp ~ varbcapsuleCt  + varbflCt
                  + varbisHarvested + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)

# remove isHarvested
femodel1 <- aster(resp ~ varbcapsuleCt  + varbflNotConsumed + varbflCt
                  + varbovuleCt + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)




femodel1 <- aster(resp ~  varb + fit:site
                  + fit:(nn1Dist + nn2Dist + nn3Dist + nn4Dist + nn5Dist
                         + nn6Dist + nn7Dist + nn8Dist + nn9Dist + nn10Dist), 
                  pred, fam,varb,Nid,root,data=redata)





names(femodel1$coefficients)

# Get estimated coefficients of random effects model
alpha.hat1 <- remodel1$alpha
b.hat1 <- remodel1$b
fred1 <- c(alpha.hat1, b.hat1)
idx1 <- match(names(femodel1$coefficients), names(fred1))
idx1
fred1[-idx1]

# Transformation
pred1 <- predict(femodel1, varvar=varb, idvar=id, root=root,se.fit=TRUE, newcoef=fred1[idx1], 
                 model.type = 'conditional', info.tol  = 1e-12, is.always.parameter = TRUE)

#pred1 <- predict(femodel1, varvar=varb, idvar=id, root=root, newcoef=fred1[idx1])

#pred1 <- predict(femodel2, se.fit=TRUE,  info.tol  = 1e-11)


# Get conditional mean value parameters
xis1 <- pred1$fit
names(xis1) <- redata$X


# Delta method
foo1 <- pred1$gradient
rownames(foo1) <- redata$X
colnames(foo1) <- names(femodel1$coefficients)
#thegradient1 <- foo1[, c("fit:sitebeng", "fit:sitehegg", "fit:sitesppe", "fit:sitesppw")]
#thegradient1 <- foo1[, c("fit:sitebeng", "fit:sitehegg", "fit:sitesppe")]
thegradient1 <- foo1[, c("fit:sitebeng", "fit:sitehegg", "fit:sitesppw")]
thevariance1 <- thegradient1 %*% t(thegradient1) * remodel1$nu
rownames(thevariance1) <- redata$X


# Calculate expected fitness
Ids <- unique(redata$id)
exp_fitness1 <- rep(0,697)
names(exp_fitness1) <- Ids
for (id in Ids) {
  exp_fitness1[id] <- prod(xis1[grep(id, names(xis1))][-4])
}


# Delta method
var_expfit1 <- rep(0,697)
names(var_expfit1) <- Ids
for (id in Ids) {
  ind <- paste(id,'\\.', sep='')
  xi <- xis1[grep(ind, names(xis1))][-4]
  var <- thevariance1[grep(ind, rownames(thevariance1))[-4], 
                      grep(ind, colnames(thevariance1))[-4]]
  grad <- c(prod(xi[-1]), prod(xi[-2]), prod(xi[-3]), prod(xi[-4]), prod(xi[-5]))
  var_expfit1[id] <- t(grad) %*% var %*% grad
}

sd_expfit1 = sqrt(var_expfit1)
head(cbind(exp_fitness1,sd_expfit1),20)

ref_fred1 = fred1[idx1]
ref_res = cbind(exp_fitness1,sd_expfit1)