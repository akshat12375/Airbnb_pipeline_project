-- Staging load script for Airbnb S3 integration and file format setup
-- Co-authored with CoCo
CREATE OR REPLACE FILE FORMAT  csv_format
  TYPE = 'CSV' 
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;



create or replace stage snow_stage
file_format=csv_format
url='';

COPY INTO bookings
FROM @snow_stage
FILES=('bookings.csv')
CREDENTIALS=(aws_key_id = '', aws_secret_key = '');

COPY INTO listings
FROM @snow_stage
FILES=('listings.csv')
CREDENTIALS=(aws_key_id = '', aws_secret_key = '');

COPY INTO hosts
FROM @snow_stage
FILES=('hosts.csv')
CREDENTIALS=(aws_key_id = '', aws_secret_key = '');