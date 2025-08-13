
# Snowflake Streaming – Sparkify DWH

This repository implements a Snowflake data warehouse that ingests raw JSON from Amazon S3 and loads it into analytic tables using **streams** (change data capture) and **tasks** (scheduled execution). External stages/external tables are used to read files in place; semi-structured data is stored and parsed via the `VARIANT` type. 

## Focus

* **Streams for incremental processing**: Streams track inserts/updates/deletes since the last offset, enabling MERGE-based loads instead of full reloads. 
* **Tasks for orchestration**: Tasks run SQL or procedures on a schedule to automate pipeline steps. 
* **Handling JSON with `VARIANT`**: Semi-structured data is stored in `VARIANT` and queried/typed with built-in functions.
* **External data access**: External **stages** reference S3 and **external tables** allow querying files as table rows (typically a single `VARIANT` column) before loading.

---

## Why I did it

* **Play with streams** – they track row-level changes so you can run incremental merges instead of full reloads 

* **Handle straight-up JSON** – store it in `VARIANT`, then parse with easy SQL (no extra ETL tool)

* **Practice external stages/integration** – query files right out of S3 and copy them in 

---

## Folder map

```

sql/
|-- 00_setup_wh_db_schemas.sql
|-- 01_external_file_format_and_stages.sql
|-- 02_raw_tables_and_pipes.sql
|-- 03_staging_tables_and_streams.sql
|-- 04_production_tables_and_streams.sql
|-- 05_merge_into_production.sql
|-- 06_reference_udacity_bucket.sql

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




