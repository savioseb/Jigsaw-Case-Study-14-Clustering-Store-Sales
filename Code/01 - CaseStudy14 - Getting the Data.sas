/**************************************
CASE STUDY 14 - Clustering - Stores Data
File Used: clustering_data-class14.csv
STEP 1: Getting the Data
*********************************************/


LIBNAME CS14 '/folders/myshortcuts/myfolder/SSCode/CS14/Datasets';

/** Importing the Dataset **/
PROC IMPORT
	Datafile='/folders/myshortcuts/myfolder/Foundation Exercises/Assignments/Class14 - Clustering with SAS/clustering_data-class14.csv'
	DBMS=CSV
	REPLACE
	OUT=CS14.CLUSTERING_DATA;
RUN;


