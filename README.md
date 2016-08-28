# Getting and Cleaning Data - Course Project

this is part of the course project from Getting and Cleaning Data course on Coursera https://www.coursera.org/learn/data-cleaning

the script `run_analysis.R` does the following steps:

1. Download a data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip the file
2. Load all features and extract only mean and std variables from the data set
3. Load a train data set and test data set, then merge them into one data set
4. Label variables in the merged data set
5. Create a tidy data set with the average of each variable for each activity and each subject
6. Write the tidy data set to `tidy.txt` file
