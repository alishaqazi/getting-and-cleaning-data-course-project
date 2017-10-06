**Getting and Cleaning Data Project**

This code book contains additional information about the variables and summaries calculated, along with other transformations in this project.

*The full description of this data can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones*

**1.** 
First, I read in the data found in: 
* X_train.txt 
* Y_train.txt 
* subject_train.txt 
* X_test.txt
* Y_test.txt
* subject_test.txt 
* features.txt
* activity_labels.txt

Then, I assigned the columns for these and merged the data in to one data set.

**2.**
I used grepl() to return a logical vector and | to combine expressions, and created MeanAndStd to subset based on the previous function.

**3.**
I merged the two tables to include descriptive activity names, for the purpose of naming the activities in the data set.

**4.**
I renamed the variables below to be more descriptive and understandable, and also removed unnecessary symbols, such as / - and ^.
* [Gg]ravity -> Gravity
* [Bb]ody[Bb]ody -> Body
* [Gg]yro -> Gyroscope
* AccMag -> AccelerometerMagnitude
* [Bb]odyAccJerkMag -> BodyAccelerometerJerkMagnitude
* JerkMag -> JerkMagnitude
* GyroMag -> GyroscopeMagnitude

**5.**
I created a tidy data set in .txt form by creating a new table (NoActivities) to take out activity names, creating a summary table to only include the information we wanted, and then merged it to include activity name. After this I created the new tidy data .txt file.
