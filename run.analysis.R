library(dplyr)

setwd("C:/Users/user/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/data")

activity = read.table("activity_labels.txt" , col.names = c("n","activity"))
activity

feature = read.table("features.txt", col.names = c("n","features"))
feature

x_train = read.table("X_train.txt", col.names = feature$features)
y_train = read.table("y_train.txt" , col.names = "y")
subject_train = read.table("subject_train.txt", col.names = "subject")


x_test = read.table("X_test.txt", col.names = feature$features)
y_test = read.table("y_test.txt" , col.names = "y")
subject_test = read.table("subject_test.txt", col.names = "subject")

#1. Merges the training and the test sets to create one data set.

x = rbind(x_train, x_test)
x
y = rbind(y_train, y_test)
y
subject = rbind(subject_train, subject_test)
data = cbind(subject, x, y)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
data2  = select(.data = data, "subject","y", contains("mean"), contains("std") )

#3. Uses descriptive activity names to name the activities in the data set.
data2$y = activity[data2$y,2]

#4. Appropriately labels the data set with descriptive variable names.
names(data2)[2] = "activity"
names(data2) = gsub("Acc", "Accelerometer", names(data2))
names(data2) = gsub("Gyro", "Gyroscope", names(data2))
names(data2) = gsub("BodyBody", "Body", names(data2))
names(data2) = gsub("Mag", "Magnitude", names(data2))
names(data2) = gsub("^t", "Time", names(data2))
names(data2) = gsub("^f", "Frequency", names(data2))
names(data2) = gsub("tBody", "TimeBody", names(data2))
names(data2) = gsub("-mean()", "Mean", names(data2), ignore.case = TRUE)
names(data2) = gsub("-std()", "STD", names(data2), ignore.case = TRUE)
names(data2) = gsub("-freq()", "Frequency", names(data2), ignore.case = TRUE)
names(data2) = gsub("angle", "Angle", names(data2))
names(data2) = gsub("gravity", "Gravity", names(data2))

#5. From the data set in step 4, creates a second, independent tidy
#data set with the average of each variable for each activity and each subject.

data3 = data2 %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
data3

write.table(data3, "DATA3.txt", row.names = F)
