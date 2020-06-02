# Roll no. 33235
# Batch: L10
# P.S.: Application of Linear regression on Breast Cancer 
# Set working directory


# install.packages(c("caret", "e1071"))

# Read the CSV file and analyse
breast_cancer <- read.csv(file.choose(),header=TRUE,sep=",")
names(breast_cancer) 
str(breast_cancer)
dim(breast_cancer)
# Set the labels 
names(breast_cancer)[1] = "ID" 
names(breast_cancer)[2] = "CT" # Clump thickness 
names(breast_cancer)[3] = "CellSize" 
names(breast_cancer)[4] = "CellShape" 
names(breast_cancer)[5] = "MA" # Marginal adhesion 
names(breast_cancer)[6] = "ECellSize" # Epithelial cell size 
names(breast_cancer)[7] = "BN" # Bare nuclei 
names(breast_cancer)[8] = "BC" # Bland chromatin 
names(breast_cancer)[9] = "NN" # Normal nuclei 
names(breast_cancer)[10] = "Mit" # Mitoses 
names(breast_cancer)[11] = "Class" # class 


names(breast_cancer)
breast_cancer$Class 
# Set 1 for malignant, 0 for benign (Clean the data) 
breast_cancer$Class <- replace(breast_cancer$Class, breast_cancer$Class == 4,1) 
breast_cancer$Class <- replace(breast_cancer$Class, breast_cancer$Class == 2,0) 
breast_cancer$Class 

# Check for missing value 
'?' %in% breast_cancer$CT 
'?' %in% breast_cancer$CellSize
'?' %in% breast_cancer$CellShape 
'?' %in% breast_cancer$MA 
'?' %in% breast_cancer$ECellSize 
'?' %in% breast_cancer$BN # Returned true (16 values are '?') 

# replace the NA values 
breast_cancer$BN <- replace(breast_cancer$BN, breast_cancer$BN == '?',NA)                     
# replace ? with NA 
levels(breast_cancer)[levels(breast_cancer)] 
summary(breast_cancer$CT) 
breast_cancer$BN[is.na(breast_cancer$BN)] <- 4.0 # Median value (replace NA) 
# Mosiac plots of some of the factors vs the class of cancer
mosaicplot(breast_cancer$CellSize ~ breast_cancer$Class, main = "Cancer class by Cellsize",color = TRUE, shade = FALSE, xlab = "Cell size ID", ylab = "Class  of cancer") 
mosaicplot(breast_cancer$CellShape ~ breast_cancer$Class, main = "Cancer class by  Cell shape", color = TRUE, shade = FALSE, xlab = "Cell shape ID", ylab = "Class of cancer")  
mosaicplot(breast_cancer$BN ~ breast_cancer$Class, main = "Cancer class as per Bare Nuclei", color = TRUE, shade = FALSE, xlab = "Bare Nuclei ID", ylab = "Class of cancer") 

library(caTools) # import library caTools
set.seed(121)

# Dividing dataset into training and testing
split = sample.split(brcdata$Class, SplitRatio = 2/3)
train_brcdata = subset(brcdata,split == TRUE)
test_brcdata = subset(brcdata,split == FALSE)
train_brcdata

regressor=lm(formula = Class~CellShape, data=train_brcdata)

View(regressor)
regressor
brc_shape_predict = predict(regressor, newdata=test_brcdata)
brc_shape_predict

round_shape=brc_shape_predict
r=round(round_shape)
View(r)
r
table(r,test_brcdata$Class)

library(e1071)
library(caret)
typeof(r)

levels(r)
levels(test_brcdata$Class)

str(r)
r2 = as.data.frame(r)
r2
df2=confusionMatrix(as.factor(r2$r),as.factor(test_brcdata$Class))
df2



# Create the dataframes for training and testing
brcdata<-breast_cancer
brcdata$ID=factor(brcdata$ID)
brcdata$CT=factor(brcdata$CT)
brcdata$TCellSize=factor(brcdata$CellSize)
brcdata$CellShape=factor(brcdata$CellShape)
brcdata$MA=factor(brcdata$MA)
brcdata$ECellSize=factor(brcdata$ECellSize)
brcdata$BN=factor(brcdata$BN)
brcdata$BC=factor(brcdata$BC)
brcdata$NN=factor(brcdata$NN)
brcdata$Mit=factor(brcdata$Mit)
brcdata$Class=factor(brcdata$Class)

# Dividing dataset into training and testing
split = sample.split(brcdata$Class, SplitRatio = 2/3)
train_brcdata = subset(brcdata,split == TRUE)
test_brcdata = subset(brcdata,split == FALSE)
train_brcdata

# Applying Naive Bayes claasifier on dataset
library(e1071)
classifier <- naiveBayes(Class ~ CT+CellSize+CellShape+MA+ECellSize+BN+BC+NN+Mit,train_brcdata)
classifier
prediction <- predict(classifier, test_brcdata ,type="class") #predict using trained model

table(prediction,  test_brcdata[,11])   # put it in table

# Displaying the accuracy using confusion Matrix
library(e1071)
library(caret)
df1=confusionMatrix(test_brcdata[,11],prediction) #create the confusion matrix
df1
