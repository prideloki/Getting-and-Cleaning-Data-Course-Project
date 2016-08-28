library(data.table)
library(dplyr)

# Download and unzip
dest <- "./UCI HAR Dataset.zip"
fileUrl <-
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(dest)) {
    download.file(url = fileUrl, destfile = dest, method = "curl")
}
if (!file.exists("UCI HAR Dataset")) {
    unzip(dest)
}

# get all features
features <-
    read.table(
        "./UCI HAR Dataset/features.txt",
        col.names = c("id", "name"),
        colClasses = c("integer", "character")
    )
featureNames <- features$name
numFeatures <- length(featureNames) # number of features
# Extracts only the measurements on the mean and standard deviation for each measurement.
selectedColumns <- grep(".*mean\\(\\)|std\\(\\).*", featureNames)
cleanedFeatureNames <- featureNames[selectedColumns] 
cleanedFeatureNames <-gsub("-mean","Mean", cleanedFeatureNames)
cleanedFeatureNames <-gsub("-std","Std",cleanedFeatureNames)
cleanedFeatureNames <-gsub("[-()]","",cleanedFeatureNames)

# get id, activity name data
activityLabels <-
    read.table(
        "./UCI HAR Dataset/activity_labels.txt",
        col.names = c("id", "name"),
        colClasses = c("integer", "character")
    )

# get train set
xTrain <-
    read.table(
        "./UCI HAR Dataset/train/X_train.txt",
        colClasses = rep(c("double"), each = numFeatures) # all variables are in doulbe
    )[selectedColumns]
yTrain <-
    read.table(
        "./UCI HAR Dataset/train/y_train.txt",
        colClasses = "integer"
    )
subjectTrain <-
    read.table(
        "./UCI HAR Dataset/train/subject_train.txt",
        colClasses = "integer"
    )
trainset <- cbind(subjectTrain, yTrain, xTrain)

# get test set
xTest <-
    read.table(
        "./UCI HAR Dataset/test/X_test.txt",
        colClasses = rep(c("double"), each = numFeatures) # all variables are in doulbe
    )[selectedColumns]
yTest <-
    read.table(
        "./UCI HAR Dataset/test/y_test.txt",
        colClasses = "integer"
    )
subjectTest <-
    read.table(
        "./UCI HAR Dataset/test/subject_test.txt",
        colClasses = "integer"
    )
testset <- cbind(subjectTest, yTest, xTest)

# Merges the training and the test sets to create one data set.
dataset <- rbind(trainset, testset)
colnames(dataset) <- c("subject", "activity", cleanedFeatureNames)


# map activity id with activity name
dataset$activity <-
    mapply(function(id)
        activityLabels$name[[id]], dataset$activity)

# creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
tidyData <-
    aggregate(dataset[, -c(1, 2)], # selected each variable except subject and activity columns
              list(subject = dataset$subject, activity = dataset$activity), # group by subject and activity
              mean) # apply mean to find the average of each var
tidyData <- arrange(tidyData, subject, activity)


write.table(tidyData, "tidy.txt", row.names = FALSE, quote = FALSE)