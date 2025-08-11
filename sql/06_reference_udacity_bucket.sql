-- For more data from the original udacity bucket you can access here
---------------------------------------------------------------------
CREATE OR REPLACE STAGE UDACITY.STAGING.aws_stage_log_data_copy url = 's3:--udacity-dend/log_data';
LIST @UDACITY.STAGING.aws_stage_log_data_copy;

CREATE OR REPLACE STAGE UDACITY.STAGING.aws_stage_song_data_copy url = 's3:--udacity-dend/song_data';
LIST @UDACITY.STAGING.aws_stage_song_data_copy;

COPY INTO UDACITY.STAGING.RAW_LOG_DATA
FROM @UDACITY.STAGING.aws_stage_log_data_copy FILE_FORMAT = (FORMAT_NAME = UDACITY.STAGING.JSON_FILE_FORMAT) PATTERN = '.*log_data.*';

COPY INTO UDACITY.STAGING.RAW_SONG_DATA
FROM @UDACITY.STAGING.aws_stage_song_data_copy FILE_FORMAT = (FORMAT_NAME = UDACITY.STAGING.JSON_FILE_FORMAT) PATTERN = '.*song_data.*';