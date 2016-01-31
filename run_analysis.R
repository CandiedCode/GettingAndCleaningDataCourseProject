#referenced libraries
library(dplyr)
library(data.table)
library(tidyr)

#set working directory
setwd("/Users/CandiedCode/Documents/Code/Coursera/DataScience/GettingAndCleaningData/CourseProject")

#download the zipfile, if it doesn't exist
if (!(file.exists("Dataset.zip"))){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url=fileUrl,destfile="Dataset.zip",mode="w",method="curl")
}

#unzip the file, set junkpath = TRUE to put files in the same folder as the dataset
unzip("Dataset.zip", overwrite = TRUE)
# from the readme.txt 
#- 'features_info.txt': Shows information about the variables used on the feature vector.
#- 'features.txt': List of all features.
#- 'activity_labels.txt': Links the class labels with their activity name.
#- 'train/X_train.txt': Training set.
#- 'train/y_train.txt': Training labels.
#- 'test/X_test.txt': Test set.
#- 'test/y_test.txt': Test labels.

features <- read.table('UCI HAR Dataset/features.txt',header=FALSE, col.names = c("featureNum","featureName"))
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE, col.names = c("activityNum","activityName"))

# Read training files
subjectTrain <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = c("subject")))
xTrain <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = features[,2]))
yTrain <- tbl_df(read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = c("activityNum")))

# Read test files
subjectTest <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = c("subject")))
xTest <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = features[,2]))
yTest <- tbl_df(read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = c("activityNum")))

#Merges the training and the test sets to create one data set.
allData <- bind_cols(bind_rows(subjectTrain, subjectTest), bind_rows(yTrain, yTest), bind_rows(xTrain, xTest))

#Let's remove unneeded objects from workspace
rm(subjectTest, subjectTrain, xTest, xTrain, yTest, yTrain)

#Extracts only the measurements on the mean and standard deviation for each measurement.
featuresMeanStd <- grep("mean[^F]|std|subject|activityNum",colnames(allData))  #find columns that have std or mean but not meanFreq
subsetData <- select(allData,featuresMeanStd)

#Uses descriptive activity names to name the activities in the data set
subsetData <- merge(subsetData,activityLabels,all = TRUE)
subsetData$activityNum <- NULL  #I don't need the activityNum anymore so let's drop it

#Appropriately labels the data set with descriptive variable names.
colnames(subsetData) <- gsub("std..", "StdDev", colnames(subsetData))
colnames(subsetData) <- gsub("mean..", "Mean", colnames(subsetData))
colnames(subsetData) <- gsub("^t", "time", colnames(subsetData))
colnames(subsetData) <- gsub("^f", "freq", colnames(subsetData))
colnames(subsetData) <- gsub("BodyBody", "Body", names(subsetData))
colnames(subsetData) <- gsub("[.]", "_", names(subsetData))
colnames(subsetData) <- gsub("Acc", "Accelerometer", names(subsetData))
colnames(subsetData) <- gsub("Gyro", "Gyroscope", names(subsetData))
colnames(subsetData) <- gsub("Mag", "Magnitude", names(subsetData))
#colnames(subsetData)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
subsetSummary <- aggregate(. ~ subject - activityName, data = subsetData, mean)
subsetSummary <- tbl_df(arrange(subsetSummary,subject,activityName))