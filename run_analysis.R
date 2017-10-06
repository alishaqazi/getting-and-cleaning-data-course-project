
R version 3.4.1 (2017-06-30) -- "Single Candle"
Copyright (C) 2017 The R Foundation for Statistical Computing
Platform: x86_64-apple-darwin15.6.0 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

[R.app GUI 1.70 (7375) x86_64-apple-darwin15.6.0]

[Workspace restored from /Users/alishaqazi/.RData]
[History restored from /Users/alishaqazi/.Rapp.history]

> getwd()
[1] "/Users/alishaqazi/Downloads"
> if(!file.exists("data")) {dir.create("data")}
> fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
100 59.6M  100 59.6M    0     0  3236k      0  0:00:18  0:00:18 --:--:-- 2440k   0     0      0      0 --:--:-- --:--:-- --:--:--     0
> list.files("./data")
[1] "Dataset.zip"
> unzip
function (zipfile, files = NULL, list = FALSE, overwrite = TRUE, 
    junkpaths = FALSE, exdir = ".", unzip = "internal", setTimes = FALSE) 
{
    if (identical(unzip, "internal")) {
        if (!list && !missing(exdir)) 
            dir.create(exdir, showWarnings = FALSE, recursive = TRUE)
        res <- .External(C_unzip, zipfile, files, exdir, list, 
            overwrite, junkpaths, setTimes)
        if (list) {
            dates <- as.POSIXct(res[[3]], "%Y-%m-%d %H:%M", tz = "UTC")
            data.frame(Name = res[[1]], Length = res[[2]], Date = dates, 
                stringsAsFactors = FALSE)
        }
        else invisible(attr(res, "extracted"))
    }
    else {
        WINDOWS <- .Platform$OS.type == "windows"
        if (!is.character(unzip) || length(unzip) != 1L || !nzchar(unzip)) 
            stop("'unzip' must be a single character string")
        zipfile <- path.expand(zipfile)
        if (list) {
            res <- if (WINDOWS) 
                system2(unzip, c("-l", shQuote(zipfile)), stdout = TRUE)
            else system2(unzip, c("-l", shQuote(zipfile)), stdout = TRUE, 
                env = c("TZ=UTC"))
            l <- length(res)
            res2 <- res[-c(1, 3, l - 1, l)]
            con <- textConnection(res2)
            on.exit(close(con))
            z <- read.table(con, header = TRUE, as.is = TRUE)
            dt <- paste(z$Date, z$Time)
            formats <- if (max(nchar(z$Date) > 8)) 
                c("%Y-%m-%d", "%d-%m-%Y", "%m-%d-%Y")
            else c("%m-%d-%y", "%d-%m-%y", "%y-%m-%d")
            slash <- any(grepl("/", z$Date))
            if (slash) 
                formats <- gsub("-", "/", formats)
            formats <- paste(formats, "%H:%M")
            for (f in formats) {
                zz <- as.POSIXct(dt, tz = "UTC", format = f)
                if (all(!is.na(zz))) 
                  break
            }
            z[, "Date"] <- zz
            z[c("Name", "Length", "Date")]
        }
        else {
            args <- c("-oq", shQuote(zipfile))
            if (length(files)) 
                args <- c(args, shQuote(files))
            if (exdir != ".") 
                args <- c(args, "-d", shQuote(exdir))
            system2(unzip, args, stdout = NULL, stderr = NULL, 
                invisible = TRUE)
            invisible(NULL)
        }
    }
}
<bytecode: 0x7fcf132e9238>
<environment: namespace:utils>
> unzip(zipfile="./data/Dataset.zip", exdir="data")
> 
> ## Merge the training and the test sets to create one data set
> ucihar <- 
+ "UCI HAR Dataset"
> xtrain <- read.table("data/ucihar/train/X_train.txt")
Error in file(file, "rt") : cannot open the connection
In addition: Warning message:
In file(file, "rt") :
  cannot open file 'data/ucihar/train/X_train.txt': No such file or directory
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
+ colnames[i] = gsub("[Gg]yro","Gyroscope",colNames[i])
+ colNames[i] = gsub("[Gg]yro","Gyroscope",colNames[i])
+ colNames[i] = gsub("AccMag","AccelerometerMagnitude",colNames[i])
+ colNames[i] = gsub("([Bb]odyAccJerkMag)","BodyAccelerometerJerkMagnitude",colNames[i])
+ colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
+ colNames[i] = gsub("GyroMag","GyroscopeMagnitude",colNames[i])
+ }
Error in colnames[i] <- gsub("[Gg]yro", "Gyroscope", colNames[i]) : 
  object of type 'closure' is not subsettable
> colNames[i] <- gsub("[Gg]yro","Gyroscope",colNames[i])
> colnames(ActivityNames) = colNames
> 
> ## Create a second, independent tidy data set with the average of each variable for each activity and each subject 
> ActivityAverage <- MeanAndStd %>% group_by("subjectId", "activityId") %>% summarize_each(funs(mean))
Error in MeanAndStd %>% group_by("subjectId", "activityId") %>% summarize_each(funs(mean)) : 
  could not find function "%>%"
> NoActivities = ActivityNames[,names(ActivityNames) !="activities"]
> tidyDataSet = aggregate(NoActivities[,names(NoActivities) !=c("activityId","subjectId")],by=list(activityId=NoActivities$activityId,subjectId=NoActivities$subjectId),mean)
There were 50 or more warnings (use warnings() to see the first 50)
> tidyDataSet = merge(tidyDataSet,activities,by="activityId",all.x=TRUE)
Warning message:
In merge.data.frame(tidyDataSet, activities, by = "activityId",  :
  column name ‘subjectId’ is duplicated in the result
> write.table(tidyDataSet, "./tidyDataSet.txt",row.names=TRUE,sep="/t")
> 