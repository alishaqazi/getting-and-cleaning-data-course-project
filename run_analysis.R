

> if(!file.exists("data")) {dir.create("data")}
> fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
100 59.6M  100 59.6M    0     0  3236k      0  0:00:18  0:00:18 --:--:-- 2440k   0     0      0      0 --:--:-- --:--:-- --:--:--     0
> list.files("./data")
[1] "Dataset.zip"

> unzip(zipfile="./data/Dataset.zip", exdir="data")
> 
> ## Merge the training and the test sets to create one data set

> ucihar <- 
+ "UCI HAR Dataset"
> xtrain <- read.table(file.path(ucihar, "train", "X_train.txt"))
> ytrain <- read.table(file.path(ucihar, "train", "Y_train.txt"))
> subjecttrain <- read.table(file.path(ucihar, "train", "subject_train.txt"))
> 
> xtest <- read.table(file.path(ucihar, "test", "X_test.txt"))
> ytest <- read.table(file.path(ucihar, "test", "Y_test.txt"))
> subjecttest <- read.table(file.path(ucihar, "test", "subject_test.txt"))
> 
> features <- read.table(file.path(ucihar, "features.txt"))
> 
> activities <- read.table(file.path(ucihar, "activity_labels.txt"))
> 
> colnames(activities) <- c("activityId", "activityType")
> colnames(subjecttrain) <- "subjectId"
> colnames(xtrain) <- features[,2]
> colnames(ytrain) <- "activityId"
> colnames(xtest) <- features[,2]
> colnames(ytest) <- "activityId"
> colnames(subjecttest) <- "subjectId"
> 
> alltogether <- rbind(cbind(xtrain,ytrain,subjecttrain), cbind(xtest,ytest,subjecttest))
> 
> ## Extract only the measurements on the mean and standard deviation for each measurement 
> 
> colNames <- colnames(alltogether)
> onlyMeanAndStd <- (grepl("activityId", colNames)|grepl("subjectId", colNames)|grepl("mean..", colNames)|grepl("std..", colNames))
> MeanAndStd <- alltogether[,onlyMeanAndStd==TRUE]
> 
> ## Use descriptive activity names to name the activities in the data set

> ActivityNames <- merge(MeanAndStd, activities, by="activityId", all.x=TRUE)
> 
> ## Appropriately labels the data set with descriptive variable names

> colNames = colnames(ActivityNames)
> for(i in 1:length(colNames)) {
+ colNames[i] = gsub("\\()","",colNames[i])
+ colNames[i] = gsub("-std$","StdDev",colNames[i])
+ colNames[i] = gsub("-mean","Mean",colNames[i])
+ colNames[i] = gsub("^(t)","time",colNames[i])
+ colNames[i] = gsub("^(f)","frequency", colNames[i])
+ colNames[i] = gsub("([Gg]ravity)","Gravity", colNames[i])
+ colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
+ colNames[i] = gsub("[Gg]yro","Gyroscope",colNames[i])
+ colNames[i] = gsub("AccMag","AccelerometerMagnitude",colNames[i])
+ colNames[i] = gsub("([Bb]odyAccJerkMag)","BodyAccelerometerJerkMagnitude",colNames[i])
+ colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
+ colNames[i] = gsub("GyroMag","GyroscopeMagnitude",colNames[i])
+ }
> colnames(ActivityNames) = colNames
> 
> ## Create a second, independent tidy data set with the average of each variable for each activity and each subject 

> NoActivities = ActivityNames[,names(ActivityNames) !="activities"]
> tidyDataSet = aggregate(NoActivities[,names(NoActivities) !=c("activityId","subjectId")],by=list(activityId=NoActivities$activityId,subjectId=NoActivities$subjectId),mean)
> tidyDataSet = merge(tidyDataSet,activities,by="activityId",all.x=TRUE)
> write.table(tidyDataSet, "./tidyDataSet.txt",row.names=TRUE,sep="/t")
> 
