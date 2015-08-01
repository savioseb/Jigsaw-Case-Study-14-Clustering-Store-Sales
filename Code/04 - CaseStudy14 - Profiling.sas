/**************************************
CASE STUDY 14 - Clustering - Stores Data
File Used: clustering_data-class14.csv
STEP 4: Cluster Level Profiling
*********************************************/


LIBNAME CS14 '/folders/myshortcuts/myfolder/SSCode/CS14/Datasets';

/** Sorting the Data by Clusters **/
PROC SORT
	DATA=CS14.SALES_CLUSTER_MERGED;
	BY CLUSTER;
RUN;

/** Finding out cluster means **/
PROC MEANS MEAN NOPRINT
	DATA=CS14.SALES_CLUSTER_MERGED;
	BY CLUSTER;
	VAR
		Fresh_Percent 
		Frozen_Percent
		Health_Percent
		Tob_Alc_Percent
		Avg_Sale_Per_Size
		;
	OUTPUT
		OUT=CS14.CLUSTER_MEAN
		MEAN(Fresh_Percent) = Fresh_Cluster_Mean
		MEAN(Frozen_Percent) = Frozen_Cluster_Mean
		MEAN(Health_Percent) = Health_Cluster_Mean
		MEAN(Tob_Alc_Percent) = Tob_Alc_Cluster_Mean
		MEAN(Avg_Sale_Per_Size) = Avg_Sale_Cluster_Mean
		;
RUN;



/** Making Field to Join the data **/
DATA CS14.CLUSTER_MEAN_W_FIELD;
	SET CS14.CLUSTER_MEAN;
	Field=1;
RUN;


/** Creating Column by which to merge the data **/
DATA CS14.POPULATION_MEANS_DATA_W_F;
	SET CS14.POPULATION_MEANS_DATA;
	Field=1;
RUN;


/** Merging the Cluster Data together and calculating Z-score for the cluster mean **/
DATA CS14.CLUSTERS_POPULATION_MERGED;
	MERGE
		CS14.CLUSTER_MEAN_W_FIELD (DROP=_TYPE_ RENAME=(_FREQ_=No_Of_Stores) )
		CS14.POPULATION_MEANS_DATA_W_F (DROP=_TYPE_ RENAME=(_FREQ_=Total_No_Of_Stores));
	BY Field;
	Fresh_Z_Score = ROUND( ( Fresh_Cluster_Mean - Fresh_Population_Mean ) / Fresh_Population_StdDev , .01 );
	Frozen_Z_Score = ROUND( ( Frozen_Cluster_Mean - Frozen_Population_Mean ) / Frozen_Population_StdDev, .01 );
	Health_Z_Score = ROUND( ( Health_Cluster_Mean - Health_Population_Mean ) / Health_Population_StdDev, .01 );
	Tob_Alc_Z_Score = ROUND( ( Tob_Alc_Cluster_Mean - Tob_Alc_Population_Mean ) / Tob_Alc_Population_StdDev, .01 );
	Avg_Sale_Z_Score = ROUND( ( Avg_Sale_Cluster_Mean - Avg_Sale_Population_Mean ) / Avg_Sale_Population_StdDev, .01 );
	Cluster_No_Of_Stores_Percent = ROUND(No_Of_Stores/Total_No_Of_Stores*100,.1);
RUN;


/** Creating Fresh Food Clustered Data **/
DATA CS14.FRESH_FOODS_CLUSTERED_DATA;
	SET CS14.CLUSTERS_POPULATION_MERGED 
		(
			KEEP =
				CLUSTER 
				Fresh_Cluster_Mean 
				Fresh_Population_Mean 
				Fresh_Population_StdDev 
				Fresh_Z_Score
				No_Of_Stores
				Cluster_No_Of_Stores_Percent
			RENAME = (
				Fresh_Cluster_Mean=Cluster_Mean
				Fresh_Population_Mean=Population_Mean
				Fresh_Population_StdDev=Population_StdDev
				Fresh_Z_Score=Z_Score
			)
		);
	Variable = "Fresh Foods Category                ";
RUN;




/** Creating Frozen Food Clustered Data **/
DATA CS14.FROZEN_FOODS_CLUSTERED_DATA;
	SET CS14.CLUSTERS_POPULATION_MERGED 
		(
			KEEP =
				CLUSTER 
				Frozen_Cluster_Mean 
				Frozen_Population_Mean 
				Frozen_Population_StdDev 
				Frozen_Z_Score
				No_Of_Stores
				Cluster_No_Of_Stores_Percent
			RENAME = (
				Frozen_Cluster_Mean=Cluster_Mean
				Frozen_Population_Mean=Population_Mean
				Frozen_Population_StdDev=Population_StdDev
				Frozen_Z_Score=Z_Score
			)
		);
	Variable = "Frozen Foods Category";
RUN;




/** Creating Health and Beauty Clustered Data **/
DATA CS14.HEALTH_CLUSTERED_DATA;
	SET CS14.CLUSTERS_POPULATION_MERGED 
		(
			KEEP =
				CLUSTER 
				Health_Cluster_Mean 
				Health_Population_Mean 
				Health_Population_StdDev 
				Health_Z_Score
				No_Of_Stores
				Cluster_No_Of_Stores_Percent
			RENAME = (
				Health_Cluster_Mean=Cluster_Mean
				Health_Population_Mean=Population_Mean
				Health_Population_StdDev=Population_StdDev
				Health_Z_Score=Z_Score
			)
		);
	Variable = "Health and Beauty Category";
RUN;



/** Creating Tobacco and Alcohol Clustered Data **/
DATA CS14.TOB_ALC_CLUSTERED_DATA;
	SET CS14.CLUSTERS_POPULATION_MERGED 
		(
			KEEP =
				CLUSTER 
				Tob_Alc_Cluster_Mean 
				Tob_Alc_Population_Mean 
				Tob_Alc_Population_StdDev 
				Tob_Alc_Z_Score
				No_Of_Stores
				Cluster_No_Of_Stores_Percent
			RENAME = (
				Tob_Alc_Cluster_Mean=Cluster_Mean
				Tob_Alc_Population_Mean=Population_Mean
				Tob_Alc_Population_StdDev=Population_StdDev
				Tob_Alc_Z_Score=Z_Score
			)
		);
	Variable = "Tobacco and Alcohol Category";
RUN;



/** Creating Average Sale per Square Feet Clustered Data **/
DATA CS14.AVG_SALE_CLUSTERED_DATA;
	SET CS14.CLUSTERS_POPULATION_MERGED 
		(
			KEEP =
				CLUSTER 
				Avg_Sale_Cluster_Mean 
				Avg_Sale_Population_Mean 
				Avg_Sale_Population_StdDev 
				Avg_Sale_Z_Score
				No_Of_Stores
				Cluster_No_Of_Stores_Percent
			RENAME = (
				Avg_Sale_Cluster_Mean=Cluster_Mean
				Avg_Sale_Population_Mean=Population_Mean
				Avg_Sale_Population_StdDev=Population_StdDev
				Avg_Sale_Z_Score=Z_Score
			)
		);
	Variable = "Average Sale per Square Feet";
RUN;



DATA CS14.MERGING_THE_CLASSIFIED_DATA;
	RETAIN 
		CLUSTER 
		Variable
		No_Of_Stores
		Cluster_No_Of_Stores_Percent 
		Cluster_Mean 
		Population_Mean 
		Population_StdDev 
		Z_Score
		;
	SET
		CS14.FRESH_FOODS_CLUSTERED_DATA
		CS14.FROZEN_FOODS_CLUSTERED_DATA
		CS14.HEALTH_CLUSTERED_DATA
		CS14.TOB_ALC_CLUSTERED_DATA
		CS14.AVG_SALE_CLUSTERED_DATA;
	Abs_Z_Score = ABS(Z_Score);
RUN;

PROC SORT
	DATA=CS14.MERGING_THE_CLASSIFIED_DATA;
	BY CLUSTER DESCENDING Abs_Z_Score;
RUN;


PROC PRINT
	DATA=CS14.MERGING_THE_CLASSIFIED_DATA;
	BY CLUSTER;
RUN;



	



