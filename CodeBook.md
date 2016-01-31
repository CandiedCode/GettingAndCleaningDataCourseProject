# CodeBook For Getting and Cleaning Data Course Project

## The Data
The [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) used for this project is described in details [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

### Data Set Information
Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Files In dataset
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

### Variable Information
For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

## Transformations
### 1. Merges the training and the test sets to create one data set.
Subject_train.txt, x_train.txt, and y_train data was loaded.
Subject_test.txt, x_test.txt, and y_test data was loaded.
The test and train datasets were merged into allData dataframe.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
We scanned the column names for allData where the name included mean or std but not meanFreq, as well as activityNum and subject to get the column numbers.
select(allData, column numbers) returned the subset of data.
### 3. Uses descriptive activity names to name the activities in the data set
subsetData was merged with the Activity Labels data to map each activity number to the activity Name.
### 4. Appropriately labels the data set with descriptive variable names.
To clean up the column names we replaced the following
- std -> StdDev
- mean -> Mean
- t -> time
- f -> freq
- BodyBody -> Body
- . -> _
- Acc -> Accelerometer
- Gyro -> Gyroscope
- Mag -> Magnitude

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
subset summary was created aggregate the data based on subject and activityName, and avg each column.
