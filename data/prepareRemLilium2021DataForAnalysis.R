##
library(FNN)


lp <- read.csv("data/input/lilium2021Data.csv")

lp$site2 <- NULL
lp$year <- 2021
lp$flCt <- lp$flwCt
lp$flNotConsumed <- ifelse(lp$deerHerb == 1, 0, 1)
lp$flUndamaged <- ifelse(lp$flwGone == 1, 0, 1)
lp$ovuleCt <- lp$totalOvules
lp$embryoCt <- lp$fullOvules


lp <- lp[,c("id", "site", "year", "Ax", "Ly","flCt", "flNotConsumed", "flUndamaged",
            "capsuleCt", "nCapsulesHarvested", "ovuleCt", "embryoCt")]

## calculate distance to first through tenth nearest flowering neighbors
nn <- knn.dist(lp[,c("Ax", "Ly")], k = 10, algorithm = "brute")

## set maximum distance of 250 m to be conservative and account for unsearched patches
nn[nn > 250] <- 250

lp <- cbind(lp, nn)

colnames(lp) <- c("id", "site", "year", "Ax", "Ly", "flCt", "flNotConsumed", "flUndamaged",
                    "capsuleCt", "nCapsulesHarvested", "ovuleCt", "embryoCt",
                  paste0("nn", c(1:10), "Dist"))



## calculate distances excluding plants whose flowers were consumed by deer

lp2 <- lp[lp$flNotConsumed == 1,]

nn2 <- knn.dist(lp2[,c("Ax", "Ly")], k = 10, algorithm = "brute")
## set maximum distance of 250 m to be conservative and account for unsearched patches
nn2[nn2 > 250] <- 250
colnames(nn2) <- paste0("nn", c(1:10), "DistNotConsumed")

nn2 <- data.frame(nn2)
nn2$id <- lp2$id


## merge

out <- merge(lp, nn2, by = "id", all.x = T)

write.csv(out, "data/output/remLilium2021Data.csv", row.names = F)
