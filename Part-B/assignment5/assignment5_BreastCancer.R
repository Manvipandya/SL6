########ASSIGNMENT 5 : BREAST CANCER DATASET#########
# Name : Manvi Pandya 
# Roll no. : 33235


library("readxl")

df_bc = read.csv2(file.choose(),header = T, sep = ',')
View(df_bc)

#naming the columns
names(df_bc) <- c("ID","CT","CellSize","CellShape","MA","ECellSize","BN","BC","NN","Mit","Class")
View(df_bc)

#subsets
subset1 <- df_bc[c(1:100),c(1,2,4,6,10)]
subset1

subset2 <- df_bc[c(1:50),c(1,2,5,7)]
subset2 

#transpose
subset1 <- subset1[order(subset1$`CT`),]
t(subset1)

library(reshape2)

#melting
subset2 <- df_bc[c(10:20),c(1,2,5,7)]
melt1 <- melt(subset2, id <- c("ID","MA"))
melt1

melt1 <- melt1[order(melt1$`ID`,melt1$`MA`),]
melt1

#casting molten data
cast1 <- dcast(melt1,`ID` + `MA`~ variable,value.var = "value")
cast1

