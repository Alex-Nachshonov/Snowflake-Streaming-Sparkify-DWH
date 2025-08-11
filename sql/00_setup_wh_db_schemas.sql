-- Create a virtual warehouse (compute resource)
CREATE OR REPLACE WAREHOUSE UDACITY_WH;

-- Create a dedicated database for the project
CREATE OR REPLACE DATABASE UDACITY;

-- Create separate schemas for staging and production layers
CREATE OR REPLACE SCHEMA UDACITY.STAGING;
CREATE OR REPLACE SCHEMA UDACITY.PRODUCTION;

-- Use the warehouse for the current session
USE WAREHOUSE UDACITY_WH;
