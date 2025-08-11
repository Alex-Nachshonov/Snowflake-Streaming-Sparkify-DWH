-- Create a json file format
CREATE OR REPLACE FILE FORMAT UDACITY.STAGING.JSON_FILE_FORMAT TYPE = JSON;
SHOW FILE FORMATS;

-- Create S3 storage integration
CREATE OR REPLACE STORAGE INTEGRATION S3 TYPE = EXTERNAL_STAGE STORAGE_PROVIDER = S3 ENABLED = TRUE STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::#####:role/snowflake-udacity-access-role' STORAGE_ALLOWED_LOCATIONS = (
        's3:--udacity-dnde-project/song_data/',
        's3:--udacity-dnde-project/log_data/'
    ) COMMENT = "Storage integration for udacity's song and log data";


DESC INTEGRATION S3;
SHOW STORAGE INTEGRATIONS;

-- Create a stage for log data
CREATE OR REPLACE STAGE UDACITY.STAGING.AWS_STAGE_LOG_DATA url = 's3:--udacity-dnde-project/log_data/' STORAGE_INTEGRATION = S3 FILE_FORMAT = UDACITY.STAGING.JSON_FILE_FORMAT;

-- List all log data files
LIST @UDACITY.STAGING.aws_stage_log_data;

-- Query the data from aws_stage_log_data
SELECT *
FROM @UDACITY.STAGING.aws_stage_log_data (file_format => UDACITY.STAGING.JSON_FILE_FORMAT);

-- Create a stage for the song data
CREATE OR REPLACE STAGE UDACITY.STAGING.AWS_STAGE_SONG_DATA url = 's3:--udacity-dnde-project/song_data/' STORAGE_INTEGRATION = S3 FILE_FORMAT = UDACITY.STAGING.JSON_FILE_FORMAT;
LIST @UDACITY.STAGING.aws_stage_song_data;

-- 'song_data'
SELECT *
FROM @UDACITY.STAGING.aws_stage_song_data (file_format => UDACITY.STAGING.JSON_FILE_FORMAT);

-- Show all existing stages
SHOW STAGES;