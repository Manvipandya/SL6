#Assignment 5
#Name : Manvi Pandya
#Batch : L-10
#Roll no. : 33235

mydata <- read.csv2(file.choose(),header = T, sep = ';')
View(mydata)

sub1 <- mydata[c(1 : 150),c(2,16:18)]
View(sub1)
head(sub1)

mean(sub1$comment)

sub2 <- subset(mydata,comment>(mean(sub1$comment)))
View(sub2)


#merge data
sub3 <- mydata[c(10:12),c(2,6:7)]
sub4 <- mydata[c(11:14),c(2,7:9)]
sub3
sub4

#Join
mergedata <- merge(sub3,sub4,by="Paid")
View(mergedata)
mergedata

sub5 <- mydata[c(1:10),c(2,6:7)]
sub6 <- mydata[c(11:20),c(2,6:7)]

mergeh <- rbind(sub5,sub6)
View(mergeh)
mergeh

sub7 <- mydata[c(1:10),c(2)]
sub8 <- mydata[c(1:10),c(6)]
mergev <- cbind(sub7,sub8)
View(mergev)
mergev

#Sort data
sort1 <- mydata[order(-mydata$Page.total.likes),]
View (sort1)
head(sort1)

sort2 <- mydata[order(mydata$comment,-mydata$Page.total.likes),]
mycomment <- sort2$comment
mylikes <- sort2$Page.total.likes
df <- cbind(mycomment,mylikes)
View(df)

#Transposing data
View(t(mydata))

library("reshape2")
library("reshape")

#Long format
#Melting data
sub9 <- mydata[c(1:10),c(1:19)]
melt1<- melt(sub9,id <- c("Type","Lifetime.Post.Total.Reach"))

melt2<- melt1
View(melt1)
head(melt1)

#sub5 <- mydata[c(11:14),c(2,7:9)]
#melt1 <- melt(sub5, id <-  c("Type","Lifetime.Post.Total.Reach"))
View(melt1)
head(melt1)
tail(melt1)
#wide format
#Casting data
#cast1 <- dcast(melt2,Type+Lifetime.Post.Total.Reach-variable, value.var = "value")
#renaming variable
#levels(melt1$variable)[levels(melt1$variable) == 'Paid'] <- 'first'
#levels(melt1$variable)[levels(melt1$variable) == 'Lifetime.Post.Total.Impressions'] <- 'second'
#View(melt1)

# Sort as per Type and variable
# This is long format
#melt1 <- melt1[ order(melt1$Type,melt1$variable),]
# View(melt1)

# Long to wide
#Casting of molten data
View(melt2)
cast1 = dcast(melt2,Type + Lifetime.Post.Total.Reach ~ variable, value.var = "value")
# This is the wide format data
View(cast1)
head(cast1)
tail(cast1)