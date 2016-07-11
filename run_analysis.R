##Getting and Clearning Data Course Project
library(plyr)

##Set WD
setwd("~/Data/UCIHARdata")

##Setting and Defining the File Path
PathToFiles <- file.path("~/Data" , "UCIHARdata")
files <-list.files(PathToFiles, recursive=TRUE)

##Insert data: Features, Subject, Activity
#1 Insert Features Data
FeatureTest   <- read.table(file.path(PathToFiles, "test", "X_test.txt"), header = F)
FeatureTrain  <- read.table(file.path(PathToFiles, "train", "X_train.txt"), header = F)
#2 Insert Subject Data
SubjectTest   <- read.table(file.path(PathToFiles, "test", "subject_test.txt"), header = F)
SubjectTrain  <- read.table(file.path(PathToFiles, "train", "subject_train.txt"), header = F)
#3 Insert Activity Data
ActivityTest  <- read.table(file.path(PathToFiles, "test", "Y_test.txt"), header = F)
ActivityTrain <- read.table(file.path(PathToFiles, "train", "Y_train.txt"), header = F)


##Merging Rows of Data
#1 Merge Features Data
FeatureData <- rbind(FeatureTrain, FeatureTest)
#2 Merge Subject Data
SubjectData <- rbind(SubjectTrain, SubjectTest)
#3 Merge Activity Data
ActivityData <- rbind(ActivityTrain, ActivityTest)
##Setting Names of Data
#1 Set Name of Features Data - Names in Column two, so subset - FeatureData$V2
NamesofFeatureData  <- read.table(file.path(PathToFiles, "features.txt"), header = F)
names(FeatureData)  <- NamesofFeatureData$V2
#2 Set Name of Subject Data
names(SubjectData)  <- c("subject")
#3 Set Name for Activity Data
names(ActivityData) <- c("activity")
##Merge all aforementioned data into one data set
CombinationofData <- cbind(SubjectData, ActivityData)
Data <- cbind(FeatureData, CombinationofData)


##Extracts only the measurements on the mean and standard deviation for each measurement.
MeanandSdfeatures <- NamesofFeatureData$V2[grep("mean\\(\\)|std\\(\\)", NamesofFeatureData$V2)]
#Subset the Columns for Feature Names
NamesWanted <- c(as.character(MeanandSdfeatures), "subject", "activity")
Data <- subset(Data, select = NamesWanted)


##Uses descriptive activity names to name the activities in the data set
LabelsforActivityData <- read.table(file.path(PathToFiles, "activity_labels.txt"), header = F)
Data$activity <- factor(Data$activity, 
                        levels = LabelsforActivityData[,1], 
                        labels = LabelsforActivityData[,2])
##Appropriately labels the data set with descriptive variable names.

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

##From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity and each subject.

DataTidy<-aggregate(. ~subject + activity, Data, mean)
DataTidy<-DataTidy[order(DataTidy$subject,DataTidy$activity),]
write.table(DataTidy, file = "TidyData.txt",row.name=FALSE)

















