-- Using ACCOUNTADMIN, create a new role for this exercise 
USE ROLE ACCOUNTADMIN;
SET USERNAME = (SELECT CURRENT_USER());
SET ALLOW_EXTERNAL_ACCESS_FOR_TRIAL_ACCOUNTS = TRUE;
CREATE OR REPLACE ROLE E2E_ML_TRAINING_ROLE;

-- Grant necessary permissions to create databases, compute pools, and service endpoints to new role
GRANT CREATE DATABASE on ACCOUNT to ROLE E2E_ML_TRAINING_ROLE; 
GRANT CREATE COMPUTE POOL on ACCOUNT to ROLE E2E_ML_TRAINING_ROLE;
GRANT CREATE WAREHOUSE ON ACCOUNT to ROLE E2E_ML_TRAINING_ROLE;
GRANT BIND SERVICE ENDPOINT on ACCOUNT to ROLE E2E_ML_TRAINING_ROLE;

-- grant new role to user and switch to that role
GRANT ROLE E2E_ML_TRAINING_ROLE to USER identifier($USERNAME);
USE ROLE E2E_ML_TRAINING_ROLE;

-- Create warehouse
CREATE OR REPLACE WAREHOUSE E2E_ML_TRAINING_WH WITH WAREHOUSE_SIZE='MEDIUM';

-- Create Database 
CREATE OR REPLACE DATABASE E2E_ML_TRAINING_DB;

-- Create Schema
CREATE OR REPLACE SCHEMA MLOPS_E2E_SCHEMA;

-- Create compute pool
CREATE COMPUTE POOL IF NOT EXISTS MLOPS_E2E_TRAINING_COMPUTE_POOL 
 MIN_NODES = 1
 MAX_NODES = 2
 INSTANCE_FAMILY = CPU_X64_M;

-- Using accountadmin, grant privilege to create network rules and integrations on newly created db
USE ROLE ACCOUNTADMIN;
GRANT CREATE INTEGRATION on ACCOUNT to ROLE E2E_ML_TRAINING_ROLE;
USE ROLE E2E_ML_TRAINING_ROLE;

-- Create an API integration with Github
CREATE OR REPLACE API INTEGRATION GITHUB_INTEGRATION_E2E_ML_TRAINING
   api_provider = git_https_api
   api_allowed_prefixes = ('https://github.com/erwinsyahh')
   enabled = true
   comment='Git integration for E2E ML Training';

-- Create the integration with the Github demo repository

CREATE OR REPLACE GIT REPOSITORY GITHUB_REPO_E2E_MLOPS
   ORIGIN = 'https://github.com/erwinsyahh/me-snowflake-scm-training.git' 
   API_INTEGRATION = 'GITHUB_INTEGRATION_E2E_ML_TRAINING' 
   COMMENT = 'Github Repository ';

-- Fetch most recent files from Github repository
ALTER GIT REPOSITORY GITHUB_REPO_E2E_MLOPS FETCH;

-- Copy notebook into snowflake configure runtime settings
CREATE OR REPLACE NOTEBOOK E2E_ML_TRAINING_DB.MLOPS_E2E_SCHEMA.TRAIN_DEPLOY_MONITOR_ML
FROM '@E2E_ML_TRAINING_DB.MLOPS_E2E_SCHEMA.GITHUB_REPO_E2E_MLOPS/branches/main/' 
MAIN_FILE = 'train_deploy_monitor_ML_in_snowflake.ipynb' QUERY_WAREHOUSE = E2E_ML_TRAINING_WH
RUNTIME_NAME = 'SYSTEM$BASIC_RUNTIME' 
COMPUTE_POOL = 'MLOPS_E2E_TRAINING_COMPUTE_POOL'
IDLE_AUTO_SHUTDOWN_TIME_SECONDS = 1800;

--DONE! Now you can access your newly created notebook with your E2E_ML_TRAINING_ROLE and run through the end-to-end workflow!

-- Finally, grant access to the created database and schema for users
GRANT USAGE ON DATABASE E2E_ML_TRAINING_DB to ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA MLOPS_E2E_SCHEMA to ROLE ACCOUNTADMIN;
