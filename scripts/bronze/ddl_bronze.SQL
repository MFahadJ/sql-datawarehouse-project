/*
============================================
-------------- BULK LOAD -----------------
--------- 2nd Phase after create the Tables
First Create the table if not exist if exist then then first drop the table 
This is used in the bronze layer where we add the data in the tables first truncate then add
============================================

*/

/* ============================================
   ============================================
            Bronze layer 
   ============================================
    ===========================================
*/

/*
1) Analysing:- Interview Source system Experts
2) Coding:- Data Ingestion
3) Validating:- Data Completeness and Schema check
4) Docs & Version:- Data Documenting and GIT
*/



IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
cst_id int ,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
prd_id int ,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
);


IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
sls_ord_num NVARCHAR(50) ,
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);



IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50)
);


IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50)
);







CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
            SET @batch_start_time = GETDATE();
            PRINT '==========================================';
            PRINT 'Loading Bronze Layer';
            PRINT '==========================================';

            PRINT '-------------------------------------------';
            PRINT 'LOADING CRM TABLES';
            PRINT '-------------------------------------------';

            SET @start_time = GETDATE();
            PRINT '>> Truncating Table: bronze.crm_cust_info';
            TRUNCATE TABLE bronze.crm_cust_info;

            PRINT '>> INSERTING Data into: bronze.crm_cust_info'
            BULK INSERT bronze.crm_cust_info
            FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
            WITH (
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
            PRINT '-------------';

            SET @start_time = GETDATE();
            PRINT '>> Truncating Table: bronze.crm_prd_info';
            TRUNCATE TABLE bronze.crm_prd_info 

            PRINT '>> INSERTING Data into:  bronze.crm_prd_info'
            BULK INSERT bronze.crm_prd_info
            FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
            WITH (
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
            PRINT '-------------';


            SET @start_time = GETDATE();
            PRINT '>> Truncating Table: bronze.crm_sales_details';
            TRUNCATE TABLE bronze.crm_sales_details 

            PRINT '>> INSERTING Data into:  bronze.crm_sales_details'
            BULK INSERT bronze.crm_sales_details
            FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
            WITH (
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
            PRINT '-------------';


            PRINT '-------------------------------------------';
            PRINT 'LOADING ERP TABLES';
            PRINT '-------------------------------------------';

            SET @start_time = GETDATE();
            PRINT '>> Truncating Table: bronze.erp_cust_az12 ';
            TRUNCATE TABLE bronze.erp_cust_az12 

            PRINT '>> INSERTING Data into: bronze.erp_cust_az12'
            BULK INSERT bronze.erp_cust_az12
            FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
            WITH (
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
            PRINT '-------------';

            SET @start_time = GETDATE();
            PRINT '>> Truncating Table: bronze.erp_loc_a101';
            TRUNCATE TABLE bronze.erp_loc_a101;

            PRINT '>> INSERTING Data into: bronze.erp_loc_a101'
            BULK INSERT bronze.erp_loc_a101
            FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
            WITH (
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
            );

            SET @end_time = GETDATE();
            PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
            PRINT '-------------';


            SET @start_time = GETDATE();
            PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
            TRUNCATE TABLE bronze.erp_px_cat_g1v2;

            PRINT '>> INSERTING Data into:bronze.erp_px_cat_g1v2'
            BULK INSERT bronze.erp_px_cat_g1v2
            FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
            WITH (
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
            PRINT '-------------';


             SET @batch_end_time = GETDATE();
            PRINT '==================================';
            PRINT 'Loading Bronze Layer Completed'
            PRINT'>>TOTAL LOAD DURATION: ' + CAST(DATEDIFF(second,@batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
            PRINT '===================================';

    END TRY
    
    BEGIN CATCH
        PRINT '============================================';
        PRINT 'ERROR occured during loading bronze layer';
        PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
        PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() as NVARCHAR);
        PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() as NVARCHAR);
        PRINT '============================================';
    END CATCH
END
--DROP PROCEDURE bronze.load_bronze

EXECUTE bronze.load_bronze
