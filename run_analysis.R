# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable
# for each activity and each subject.

# 1. Merges the training and the test sets to create one data set.

test<- read.table('./UCI HAR Dataset/test/subject_test.txt')
train <- read.table('./UCI HAR Dataset/train/subject_train.txt')

# head(test)
# head(train)

x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
# head(x_train)
# dim(x_train)
# dim(y_train)
# head(y_train)

merged <- rbind(train, test)
# dim(merged)
# head(merged)
names(merged) <- "subject"
x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table('./UCI HAR Dataset/features.txt')
# dim(features)
# head(features, 7)
colnames(features) <- c("id", "name")
# head(features)
features_row <- grep('mean\\(\\)|std\\(\\)', features$name) # index of features
x_merged_selected <- x_merged[, features_row]
names(x_merged_selected) <- features[features$id %in% features_row, 2]
# names(x_merged_selected)

# x_merged_selected[1:5, 1:5]

# 3. Uses descriptive activity names to name the activities in the data set

activity_names <- read.table('./UCI HAR Dataset/activity_labels.txt')
# activity_names

# 4. Appropriately labels the data set with descriptive variable names. 

# head(y_merged)
y_merged[, 1] <- activity_names[y_merged[, 1], 2]
colnames(y_merged) <- "activity"

# 5. From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable
# for each activity and each subject.

combined_dataset <- cbind(merged, y_merged, x_merged_selected)

dummy <- combined_dataset[, 3:ncol(combined_dataset)]
tidy <- aggregate(dummy, list(combined_dataset$subject, combined_dataset$activity), mean)
# head(tidy[1:5])
# names(tidy)[1:2]
colnames(tidy)[1:2] <- c("subject", "activity")
write.csv(tidy, "tidy.csv")
