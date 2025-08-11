
# Snowflake Streaming - Sparkify DWH 

This repo is my ides to build a data warehouse in **Snowflake**.  
Main idea: move raw JSON from S3 into tables, while using Snowflake’s **streams** and **tasks** so new data keeps flowing automatically.

---

## Why I did it

* **Play with streams** – they track row-level changes so you can run incremental merges instead of full reloads 

* **Handle straight-up JSON** – store it in `VARIANT`, then parse with easy SQL (no extra ETL tool)

* **Practice external stages/integration** – query files right out of S3 and copy them in 

* Keep the structure *simple* (one `sql/` folder, clear order), because recruiters don’t want to click a maze.

---

## Folder map

```

sql/
|-- warehouse, DB, schemas
|-- file format + S3 stage
|-- raw tables + pipes
|-- parsed staging tables + streams
|-- star-schema tables + streams
|-- tasks that MERGE into prod tables
|-- scripts I got from the Udacity starter bucket

````

## What each script does

| Step | Script                                   | explanation                                                                 |
| ---- | ---------------------------------------- | --------------------------------------------------------------------------- |
| 00   | `00_setup_wh_db_schemas.sql`             | Makes the warehouse + DB + two schemas                                      |
| 01   | `01_external_file_format_and_stages.sql` | Defines a JSON file format, S3 integration, and two external stages         |
| 02   | `02_raw_tables_and_pipes.sql`            | Creates RAW tables (just a `VARIANT` column) and **pipes** that auto-ingest |
| 03   | `03_staging_tables_and_streams.sql`      | Builds parsed STAGING tables and attaches **streams**                       |
| 04   | `04_production_tables_and_streams.sql`   | Builds the final star schema + more streams                                 |
| 05   | `05_merge_into_production.sql`           | Five tasks that MERGE fresh rows from staging into prod                     |
| 06   | `06_reference_udacity_bucket.sql`        | Extra helper script to pull more data from the Udacity S3 bucket            |

---

## Data model

* **Fact** – `FACT_SONGPLAYS` (every song play event)
* **Dims** – `DIM_USERS`, `DIM_SONGS`, `DIM_ARTISTS`, `DIM_TIME`

Classic star so analysts can join in seconds.

---

### Credits

Project idea & raw data Udacity.
Any feedback? Open an issue 😄




