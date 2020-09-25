features <- read.table("./UCI HAR Dataset/features.txt")                             #reading features 
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")                    #reading activity data

train <- read.table("./UCI HAR Dataset/train/X_train.txt")                           #reading train data, features data
colnames(train) <- features$V2                                                       #(STEP 4)descriptive column names for data 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")                         #activity labels
train$activity <- y_train$V1
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")             #subjects
train$subject <- factor(subject_train$V1)

test <- read.table("./UCI HAR Dataset/test/X_test.txt")                              #reading test data from starting here
colnames(test) <- features$V2
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
test$activity <- y_test$V1
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test$subject <- factor(subject_test$V1)                                              #keeping the received data
dataset <- rbind(test, train)                                                        #(STEP 1)merging train and test sets
column.names <- colnames(dataset)                                                    #(STEP 2)filter column names 

#get only columns for standard deviation and mean values, also saves activity and subject values 
column.names.filtered <- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
dataset.filtered <- dataset[, column.names.filtered] 

dataset.filtered$activitylabel <- factor(dataset.filtered$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")) #(STEP 3)

features.colnames = grep("std\\(\\)|mean\\(\\)", column.names, value=TRUE)           #creating a tidy dataset with mean values for each subject and activity
dataset.melt <-melt(dataset.filtered, id = c('activitylabel', 'subject'), measure.vars = features.colnames)
dataset.tidy <- dcast(dataset.melt, activitylabel + subject ~ variable, mean)

write.table(dataset.tidy, file = "tidydataset.txt" row.names = FALSE)                #creating a tidy dataset file
