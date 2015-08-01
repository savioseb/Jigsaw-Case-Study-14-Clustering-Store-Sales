/**************************************
CASE STUDY 14 - Clustering - Stores Data
File Used: clustering_data-class14.csv
STEP 2: Data Exploration
*********************************************/


LIBNAME CS14 '/folders/myshortcuts/myfolder/SSCode/CS14/Datasets';

/** Calculating Sales Percent Per Category **/
DATA CS14.SALES_PERCENT_DATA;
	SET CS14.CLUSTERING_DATA;
	Fresh_Percent = Cat1 / Sale * 100;
	Frozen_Percent = Cat2 / Sale * 100;
	Health_Percent = Cat3 / Sale * 100;
	Tob_Alc_Percent = Cat4 / Sale * 100;	
	Avg_Sale_Per_Size = Sale*1000/Size;
RUN;


/** Calculating the Proc Means of the Population for profiling clusters **/
PROC MEANS N MEAN STDDEV MIN MAX
	DATA=CS14.SALES_PERCENT_DATA;
	OUTPUT
		OUT=CS14.POPULATION_MEANS_DATA
		MEAN(Fresh_Percent)=Fresh_Population_Mean 
		MEAN(Frozen_Percent)=Frozen_Population_Mean 
		MEAN(Health_Percent)=Health_Population_Mean 
		MEAN(Tob_Alc_Percent)=Tob_Alc_Population_Mean 
		MEAN(Avg_Sale_Per_Size)=Avg_Sale_Population_Mean
		
		STDDEV(Fresh_Percent)=Fresh_Population_StdDev 
		STDDEV(Frozen_Percent)=Frozen_Population_StdDev 
		STDDEV(Health_Percent)=Health_Population_StdDev 
		STDDEV(Tob_Alc_Percent)=Tob_Alc_Population_StdDev 
		STDDEV(Avg_Sale_Per_Size)=Avg_Sale_Population_StdDev;
	VAR 
		Fresh_Percent 
		Frozen_Percent
		Health_Percent
		Tob_Alc_Percent
		Avg_Sale_Per_Size
		;
	TITLE1 "Calculating the Proc Means of the Population for profiling clusters";
RUN;
	
/** STandardizing the data **/
PROC STANDARD
	DATA=CS14.SALES_PERCENT_DATA
	MEAN=0
	STD=1
	OUT=CS14.STANDARDIZED_DATA;
	VAR
		Fresh_Percent 
		Frozen_Percent
		Health_Percent
		Tob_Alc_Percent
		Avg_Sale_Per_Size
		;
RUN;

/** Assigning a weight of 3 to Average Sale PEr Size */
DATA CS14.STANDARDIZED_DATA_W_WEIGHT;
	SET CS14.STANDARDIZED_DATA;
	Avg_Sale_Per_Size_Weigted = Avg_Sale_Per_Size * 3;
RUN;










