# Description
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Please upload the tidy data set created in step 5 of the instructions. Please upload your data set as a txt file created with write.table() using row.name=FALSE (do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission).


# Data
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

filename <- "dataset.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Download and unzip the dataset
if (!file.exists(filename)){
  download.file(fileURL, filename)
  unzip(filename)
}

# Read data into R
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merge the testing and training datasets
x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
subject <- rbind(subtrain, subtest)
data <- cbind(subject, y, x)

# 4. Appropriately label the data set. This is out of order from the instructions,
# but is more straightforward
featureNames <- as.character(features[,2])
colNames <- c("subject", "activity", featureNames)
colnames(data) <- colNames

# 2. Get only the mean and std columns of the features
# It is unclear if we should include the meanFreq feature or not, but I am leaving them in
featuresWanted <- grep(".*mean.*|.*std.*", colnames(data))
dataMeanStd <- data[,c(1,2,featuresWanted)]

# 3. Use descriptive activity names
dataMeanStd$activity <- factor(dataMeanStd$activity, levels = activities[,1], labels = activities[,2])

# 5. Create a second, independent tidy data set with average of each variable for 
# each activity and each subject
library(reshape2)
dataMeanStd.melted <- melt(dataMeanStd, id = c("subject", "activity"))
dataMeanStd.mean <- dcast(dataMeanStd.melted, subject + activity ~ variable, mean)

write.table(dataMeanStd.mean, "tidy.txt", row.names = FALSE, quote = FALSE)



