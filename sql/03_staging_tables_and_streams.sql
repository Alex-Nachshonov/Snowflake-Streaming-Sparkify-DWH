--Create staging tables to hold the pasred data
CREATE OR REPLACE TABLE UDACITY.STAGING.LOG_DATA(
        artist STRING,
        auth STRING,
        first_Name STRING,
        gender STRING,
        item_In_Session INT,
        last_Name STRING,
        length NUMERIC,
        level STRING,
        location STRING,
        method STRING,
        page STRING,
        registration INT,
        session_Id INT,
        song STRING,
        status INT,
        ts INT,
        user_Agent STRING,
        user_Id INT
    );
CREATE OR REPLACE TABLE UDACITY.STAGING.SONG_DATA (
        artist_id STRING,
        artist_latitude NUMERIC,
        artist_location STRING,
        artist_longitude NUMERIC,
        artist_name STRING,
        duration NUMERIC,
        num_songs INT,
        song_id STRING,
        year INT,
        title STRING
    );


--Create streams 
CREATE OR REPLACE STREAM UDACITY.STAGING.RAW_LOG_DATA_STREAM ON TABLE UDACITY.STAGING.RAW_LOG_DATA;
CREATE OR REPLACE STREAM UDACITY.STAGING.RAW_SONG_DATA_STREAM ON TABLE UDACITY.STAGING.RAW_SONG_DATA;
select SYSTEM $STREAM_HAS_DATA('RAW_LOG_DATA_STREAM');
select SYSTEM $STREAM_HAS_DATA('RAW_SONG_DATA_STREAM');

SELECT count(*)
FROM UDACITY.STAGING.LOG_DATA;

SELECT count(*)
FROM UDACITY.STAGING.SONG_DATA;


--Automate streams with Merge statements
--Log data
CREATE OR REPLACE TASK UDACITY.STAGING.RAW_LOG_DATA_TASK WAREHOUSE = UDACITY_WH SCHEDULE = '1 MINUTE'
    WHEN SYSTEM $STREAM_HAS_DATA('RAW_LOG_DATA_STREAM') AS MERGE INTO UDACITY.STAGING.LOG_DATA T USING (
        SELECT LD.artist,
            LD.auth,
            LD.first_name,
            LD.gender,
            LD.item_in_session,
            LD.last_name,
            LD.length,
            LD.level,
            LD.location,
            LD.method,
            LD.page,
            LD.registration,
            LD.session_id,
            LD.song,
            LD.status,
            LD.ts / 1000 as ts,
            LD.user_agent,
            LD.user_id,
            LD.METADATA $ACTION,
            LD.METADATA $ISUPDATE
        FROM (
                select t.raw :artist::STRING as artist,
                    t.raw :auth::STRING as auth,
                    t.raw :firstName::STRING as first_name,
                    t.raw :gender::STRING as gender,
                    t.raw :itemInSession::INT as item_in_session,
                    t.raw :lastName::STRING as last_name,
                    t.raw :length::FLOAT as length,
                    t.raw :level::STRING as level,
                    t.raw :location::STRING as location,
                    t.raw :method::STRING as method,
                    t.raw :page::STRING as page,
                    t.raw :registration::INT as registration,
                    t.raw :sessionId::INT as session_id,
                    t.raw :song::STRING as song,
                    t.raw :status::INT as status,
                    t.raw :ts::INT as ts,
                    t.raw :userAgent::STRING as user_agent,
                    try_cast(t.raw :userId::STRING as INT) as user_id,
                    t.METADATA $ACTION,
                    t.METADATA $ISUPDATE
                from UDACITY.STAGING.RAW_LOG_DATA_STREAM t
            ) LD
        WHERE LD.artist IS NOT NULL
            AND LD.auth IS NOT NULL
            AND LD.first_name IS NOT NULL
            AND LD.gender IS NOT NULL
            AND LD.item_in_session IS NOT NULL
            AND LD.last_name IS NOT NULL
            AND LD.length IS NOT NULL
            AND LD.level IS NOT NULL
            AND LD.location IS NOT NULL
            AND LD.method IS NOT NULL
            AND LD.page IS NOT NULL
            AND LD.registration IS NOT NULL
            AND LD.session_id IS NOT NULL
            AND LD.song IS NOT NULL
            AND LD.status IS NOT NULL
            AND LD.ts IS NOT NULL
            AND LD.user_agent IS NOT NULL
            AND LD.user_id IS NOT NULL
    ) S ON T.USER_ID = S.USER_ID
    AND T.session_id = S.session_id 
    WHEN MATCHED
    AND S.METADATA $ACTION = 'DELETE'
    AND S.METADATA $ISUPDATE = 'FALSE' THEN DELETE 
    WHEN MATCHED
    AND S.METADATA $ACTION = 'INSERT'
    AND S.METADATA $ISUPDATE = 'TRUE' THEN
UPDATE
SET T.artist = S.artist,
    T.auth = S.auth,
    T.first_name = S.first_name,
    T.gender = S.gender,
    T.item_in_session = S.item_in_session,
    T.last_name = S.last_name,
    T.length = S.length,
    T.level = S.level,
    T.location = S.location,
    T.method = S.method,
    T.page = S.page,
    T.registration = S.registration,
    T.session_id = S.session_id,
    T.song = S.song,
    T.status = S.status,
    T.ts = S.ts,
    T.user_agent = S.user_agent,
    T.user_id = S.user_id 
    WHEN NOT MATCHED
    AND S.METADATA $ACTION = 'INSERT' THEN
INSERT (
        artist,
        auth,
        first_name,
        gender,
        item_in_session,
        last_name,
        length,
        level,
        location,
        method,
        page,
        registration,
        session_id,
        song,
        status,
        ts,
        user_agent,
        user_id
    )
VALUES (
        S.artist,
        S.auth,
        S.first_name,
        S.gender,
        S.item_in_session,
        S.last_name,
        S.length,
        S.level,
        S.location,
        S.method,
        S.page,
        S.registration,
        S.session_id,
        S.song,
        S.status,
        S.ts,
        S.user_agent,
        S.user_id
    );

ALTER TASK UDACITY.STAGING.RAW_LOG_DATA_TASK RESUME;


--Song data
CREATE OR REPLACE TASK UDACITY.STAGING.RAW_SONG_DATA_TASK WAREHOUSE = UDACITY_WH SCHEDULE = '1 MINUTE'
    WHEN SYSTEM $STREAM_HAS_DATA('RAW_SONG_DATA_STREAM') AS MERGE INTO UDACITY.STAGING.SONG_DATA T USING (
        SELECT SD.artist_id,
            SD.artist_latitude,
            SD.artist_location,
            SD.artist_longitude,
            SD.artist_name,
            SD.duration,
            SD.num_songs,
            SD.song_id,
            SD.year,
            SD.title,
            SD.METADATA $ACTION,
            SD.METADATA $ISUPDATE
        FROM (
                select t.raw :artist_id::STRING as artist_id,
                    t.raw :artist_latitude::NUMERIC as artist_latitude,
                    t.raw :artist_location::STRING as artist_location,
                    t.raw :artist_longitude::NUMERIC as artist_longitude,
                    t.raw :artist_name::STRING as artist_name,
                    t.raw :duration::NUMERIC as duration,
                    t.raw :num_songs::INT as num_songs,
                    t.raw :song_id::STRING as song_id,
                    t.raw :year::INT as year,
                    t.raw :title::STRING as title,
                    t.METADATA $ACTION,
                    t.METADATA $ISUPDATE
                from UDACITY.STAGING.RAW_SONG_DATA_STREAM t
            ) SD
        WHERE SD.artist_id IS NOT NULL
            AND SD.artist_latitude IS NOT NULL
            AND SD.artist_location IS NOT NULL
            AND SD.artist_longitude IS NOT NULL
            AND SD.artist_name IS NOT NULL
            AND SD.duration IS NOT NULL
            AND SD.num_songs IS NOT NULL
            AND SD.song_id IS NOT NULL
            AND SD.title IS NOT NULL
    ) S ON T.artist_id = S.artist_id
    AND T.song_id = S.song_id 
    WHEN MATCHED
    AND S.METADATA $ACTION = 'DELETE'
    AND S.METADATA $ISUPDATE = 'FALSE' THEN DELETE 
    WHEN MATCHED
    AND S.METADATA $ACTION = 'INSERT'
    AND S.METADATA $ISUPDATE = 'TRUE' THEN
UPDATE
SET T.artist_id = S.artist_id,
    T.artist_latitude = S.artist_latitude,
    T.artist_location = S.artist_location,
    T.artist_longitude = S.artist_longitude,
    T.artist_name = S.artist_name,
    T.duration = S.duration,
    T.num_songs = S.num_songs,
    T.song_id = S.song_id,
    T.title = S.title 
    WHEN NOT MATCHED
    AND S.METADATA $ACTION = 'INSERT' THEN
INSERT (
        T.artist_id,
        T.artist_latitude,
        T.artist_location,
        T.artist_longitude,
        T.artist_name,
        T.duration,
        T.num_songs,
        T.song_id,
        T.title
    )
VALUES (
        S.artist_id,
        S.artist_latitude,
        S.artist_location,
        S.artist_longitude,
        S.artist_name,
        S.duration,
        S.num_songs,
        S.song_id,
        S.title
    );

ALTER TASK UDACITY.STAGING.RAW_SONG_DATA_TASK RESUME;

-- See all defined tasks
SHOW TASKS;