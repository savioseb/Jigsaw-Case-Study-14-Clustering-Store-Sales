/**************************************
CASE STUDY 14 - Clustering - Stores Data
File Used: clustering_data-class14.csv
STEP 3: Clustering the Data
*********************************************/


LIBNAME CS14 '/folders/myshortcuts/myfolder/SSCode/CS14/Datasets';

/** Clustering the data **/
PROC FASTCLUS 
	DATA=CS14.STANDARDIZED_DATA_W_WEIGHT
	OUT=CS14.CLUSTERS
	MAXCLUSTERS=4;
	VAR
		Fresh_Percent 
		Frozen_Percent
		Health_Percent
		Tob_Alc_Percent
		Avg_Sale_Per_Size_Weigted
		;
RUN;

/** Sorting Clusters Dataset by Store_Num to prepare for merge with Sales_Percent_data **/
PROC SORT
	DATA=CS14.CLUSTERS;
	BY Store_Num;
RUN;

/** Merge Cluster Data with Sales Data **/
DATA CS14.SALES_CLUSTER_MERGED;
	MERGE 
		CS14.SALES_PERCENT_DATA
		CS14.CLUSTERS (Keep=Store_Num CLUSTER);
	BY Store_Num;
RUN;
	
	
/*	
%INCLUDE "/folders/myshortcuts/myfolder/SSCode/CS14/Code/04 - CaseStudy14 - Profiling.sas" / lrecl=500;
%INCLUDE "/folders/myshortcuts/myfolder/SSCode/CS14/Code/05 - CaseStudy14 - Merging Z-Score.sas" / lrecl=500;
*/

