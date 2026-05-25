
create database udacity:

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
WITH ( 
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',', USE_TYPE_DEFAULT = FALSE)
) GO



IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'MySynapseDataSource')
CREATE EXTERNAL DATA SOURCE [MySynapseDataSource]
WITH (
    LOCATION = 'https://adlsnycpayrollfiles.dfs.core.windows.net/adlsnycpayrollfiles/dirstaging'
) GO


IF EXISTS (SELECT * FROM sys.external_tables WHERE name = 'NYC_Payroll_Summary')
DROP EXTERNAL TABLE [dbo].[NYC_Payroll_Summary];
GO


CREATE EXTERNAL TABLE [dbo].[NYC_Payroll_Summary](
    [FiscalYear] [int] NULL,
    [AgencyName] [varchar](50) NULL,
    [TotalPaid] [float] NULL
)
WITH (
    LOCATION = '/',  
    DATA_SOURCE = [MySynapseDataSource], 
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
GO


SELECT TOP 10 * FROM dbo.NYC_Payroll_Summary ORDER BY TotalPaid DESC;
