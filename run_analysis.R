run_analysis <-function(){
  
  #load the required libraries if not loaded
  library(dplyr)
  
  #read in the features.txt
  features<- read.csv(file = ".\\UCI HAR Dataset\\features.txt",header=FALSE,sep="")
  #create column Names for the features dataframe
  colnames(features) <- c("featureId","featureName")
  #create a vector used to subset the merged test and training data sets
  selectedColumns <- features[(grep(".*-(mean|std)().*",features$featureName)),]
  
  #read in the activity Labels
  activityLabels <- read.csv(".\\UCI HAR Dataset\\activity_Labels.txt",header=FALSE,sep="")
  #set appropriate column Names
  colnames(activityLabels) <- c("ActivityId","ActivityName")

  #function definition which will merge the .txt files founr within the file path into a single dataframe
  #subsetting out only needed columns , and providing meaningful coulmn names
  createMergedData <- function(filepath,activityDesc,columnDescription) {
      #read in the training files
      FileList <- list.files(path = filepath,pattern = ".txt",full.names = TRUE)
      
      #find index of the file, from which we need to select only specific columns (ie columns containing just the mean and std)
      # in this example it would be the X_train.txt and the X_test.txt
      index <- match(1,lapply(FileList,FUN = function(x){grep("X_.*.txt",x)}))
      
      #read in the data and store as a list of data frames
      rawFiles <- lapply(FileList,read.csv,header=FALSE,sep="")
      #only keep the columns that we are interested in (ie columns containing just the mean and std)
      rawFiles[[index]] <- rawFiles[[index]][,selectedColumns$featureId]
      
      #provide meaningful names for the columns, first file is the subject, then the measurements and the  last file
      #is the activity 
      colnames(rawFiles[[1]]) <-c("SubjectId")
      colnames(rawFiles[[2]]) <- columnDescription$featureName
      colnames(rawFiles[[3]]) <-c("ActivityId")
      
      mergedFiles<- do.call(cbind,rawFiles)
      merge(activityDesc,mergedFiles,by.x = "ActivityId",by.y = "ActivityId")  
  }
  
  #function call for the train and test data sets
  trainData <- createMergedData(".\\UCI HAR Dataset\\train\\",activityLabels,selectedColumns)
  testData <- createMergedData(".\\UCI HAR Dataset\\test\\",activityLabels,selectedColumns)
  completeData <- rbind(trainData,testData)
  
  #group the data by subject and activity and calculate the average for each column
  tidy_data <- completeData[,-1] %>% group_by(SubjectId,ActivityName) %>% summarise_each(funs(mean))
  
  #arrange the dataset by subject and activity Name 
  tidy_data <- arrange(tidy_data,SubjectId,ActivityName)
  
  #write out the dataset to file
  write.table(tidy_data,file = "tidy_data.txt",row.names = FALSE)

}