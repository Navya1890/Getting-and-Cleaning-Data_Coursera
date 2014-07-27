setwd("C:\\users\\navya\\desktop\\frompendrive\\Coursera\\5_Gettingandcleaningdata\\project\\getdata-projectfiles-UCI HAR Dataset")
testX = read.csv("UCI HAR Dataset/test/X_test.txt", header=F, sep="")
testY = read.csv("UCI HAR Dataset/test/Y_test.txt", header=F, sep="")
testX[,562] = testY #adding activity column
testSubj = read.csv("UCI HAR Dataset/test/subject_test.txt", header=F, sep="")
testX[,563] = testSubj #adding subject column

trainX = read.csv("UCI HAR Dataset/train/X_train.txt", header=F, sep="")
trainY = read.csv("UCI HAR Dataset/train/Y_train.txt", header=F, sep="")
trainX[,562] = trainY #adding activity column
trainSubj = read.csv("UCI HAR Dataset/train/subject_train.txt", header=F, sep="")
trainX[,563] = trainSubj #adding subject column
 
testandtrain = rbind(testX,trainX) #merging the data

features = read.csv("UCI HAR Dataset/features.txt", header=F, sep="")
meanstd <- grep(".*mean.*|.*std.*", features[,2]) #extracting measurements with only mean and standard deviations
features <- features[meanstd,] #subsetting features dataset

#replacing column name with suitable names
features[,2] <- gsub('-mean','Mean',features[,2])  
features[,2] <- gsub('-std','Std',features[,2])
features[,2] <- gsub('[-()]','',features[,2])
meanstd = c(meanstd,562,563)
testandtrain <- testandtrain[,meanstd]

colnames(testandtrain) <- c(features[,2], "Activity", "Subject")

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

#updating activity classes with activity names
activityClass = 1
for (activityClassLabel in activityLabels$V2) {
    testandtrain$Activity <- gsub(activityClass, activityClassLabel, testandtrain$Activity)
    activityClass <- activityClass + 1
}

testandtrain$Activity <- as.factor(testandtrain$Activity)
testandtrain$Subject <- as.factor(testandtrain$Subject)

#calculating the average values of each variable for each activity and each subject
activityAvg <- aggregate(testandtrain, by=list(ActivityAVG=testandtrain$Activity,SubjectAVG=testandtrain$Subject), FUN="mean")

#creating the tidy dataset
tidydataset <- activityAvg[, -which(names(activityAvg) %in% c("Activity","Subject"))]
write.table(tidydataset, "tidydata.txt", sep="\t")






