## run_analysis.R function explanation
The code assumes that the UCI HAR Dataset , containing the data files are present within the current working directory.
The following data files are specified
1. data files containing the subject data.
2. data files containing the measurements recorded.
3. data files relating to the activity measured.

The createMergedData function, merges the 3 data files , to create one datset. We then proceed to extricate only the columns from the measurement data
containing then mean and std. deviation measures. The columns have been programatically extracted using regular expressions. The columns are then 
appropriately named.

The analysis function , merges the output of the inner createMergedData, which is called for both the test and training data set.
This merged data set is then grouped by subject and activity to create the final requested tidy data set.