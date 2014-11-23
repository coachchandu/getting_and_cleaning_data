## get the files into the right directory
## clean the environment
rm(list=ls())
setwd("./UCI HAR Dataset")
cwd <- getwd()


## read the measurement data
Xtest <- read.table("./test/X_test.txt")
Xtrain <- read.table("./train/X_train.txt")
Xdata <- rbind(Xtest, Xtrain)
rm(list = c("Xtest", "Xtrain"))

## read the activity data
Ytest <- read.table("./test/Y_test.txt")
Ytrain <- read.table("./train/Y_train.txt")
Ydata <- rbind(Ytest, Ytrain)
rm(list = c("Ytest", "Ytrain"))

## read the subject data
Stest <- read.table("./test/subject_test.txt")
Strain <- read.table("./train/subject_train.txt")
Sdata <- rbind(Stest, Strain)
rm(list = c("Stest", "Strain"))

##----------------------------------------------------
## Merges the training and the test sets to create one data set.
##----------------------------------------------------
all_data <- cbind(Xdata, Sdata, Ydata)
## clean up
rm(list = c("Sdata", "Ydata", "Xdata"))

##----------------------------------------------------
## Extracts only the measurements on the mean and standard deviation for each measurement.
##----------------------------------------------------
temp = read.table("features.txt", sep = "")
features = temp$V2
rm("temp")

std_mean <- all_data[,
                     grep(pattern="std|mean", 
                          x=features, 
                          ignore.case=TRUE)]

##----------------------------------------------------
## Uses descriptive activity names to name the activities in the data set
## assumed original dataset, not std_mean
##----------------------------------------------------
## clean up Activity column . 
## get the activity labels
temp = read.table("activity_labels.txt", sep = "")
activity_labels = as.character(temp$V2)
rm("temp")
## convert to factor
all_data[,563] <- as.factor(all_data[,563])
## replace factors with labels
levels(all_data[,563]) <- activity_labels
rm("activity_labels")

##----------------------------------------------------
## Appropriately labels the data set with descriptive variable names. 
## assumed original dataset, not std_mean
##----------------------------------------------------

features <- make.names(features, unique = TRUE) ## some labels seems dupes
features[562] = "Subject"
features[563] = "Activity"
colnames(all_data) <- features
rm(features)

##----------------------------------------------------
## creates a second, independent tidy data set with the average of each variable 
## for each activity and each subject.
## assumed original dataset, not std_mean
##----------------------------------------------------

require (dplyr)
tidy_data <- all_data %>% 
  group_by(Subject, Activity) %>% 
  summarise_each(funs(mean))
 
write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE )


