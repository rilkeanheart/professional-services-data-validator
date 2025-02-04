-- Copyright 2023 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

CREATE SCHEMA pso_data_validator;
DROP TABLE IF EXISTS pso_data_validator.dvt_core_types;
CREATE TABLE pso_data_validator.dvt_core_types
(   id              int NOT NULL PRIMARY KEY
,   col_int8        smallint
,   col_int16       smallint
,   col_int32       int
,   col_int64       bigint
,   col_dec_20      decimal(20)
,   col_dec_38      decimal(38)
,   col_dec_10_2    decimal(10,2)
,   col_float32     real
,   col_float64     double precision
,   col_varchar_30  varchar(30)
,   col_char_2      char(2)
,   col_string      text
,   col_date        date
,   col_datetime    timestamp(3)
,   col_tstz        timestamp(3) with time zone
);
COMMENT ON TABLE pso_data_validator.dvt_core_types IS 'Core data types integration test table';

INSERT INTO pso_data_validator.dvt_core_types VALUES
(1,1,1,1,1
 ,12345678901234567890,1234567890123456789012345,123.11,123456.1,12345678.1
 ,'Hello DVT','A ','Hello DVT'
 ,DATE'1970-01-01',TIMESTAMP'1970-01-01 00:00:01'
 ,TIMESTAMP WITH TIME ZONE'1970-01-01 00:00:01 -01:00'),
(2,2,2,2,2
 ,12345678901234567890,1234567890123456789012345,123.22,123456.2,12345678.2
 ,'Hello DVT','B','Hello DVT'
 ,DATE'1970-01-02',TIMESTAMP'1970-01-02 00:00:02'
 ,TIMESTAMP WITH TIME ZONE'1970-01-02 00:00:02 -02:00'),
(3,3,3,3,3
 ,12345678901234567890,1234567890123456789012345,123.3,123456.3,12345678.3
 ,'Hello DVT','C ','Hello DVT'
 ,DATE'1970-01-03',TIMESTAMP'1970-01-03 00:00:03'
 ,TIMESTAMP WITH TIME ZONE'1970-01-03 00:00:03 -03:00');

DROP TABLE IF EXISTS pso_data_validator.dvt_ora2pg_types;
CREATE TABLE pso_data_validator.dvt_ora2pg_types
(   id              int NOT NULL PRIMARY KEY
,   col_num_4       smallint
,   col_num_9       int
,   col_num_18      bigint
,   col_num_38      decimal(38)
,   col_num         decimal
,   col_num_10_2    decimal(10,2)
--,   col_num_6_m2    decimal(6,0)
--,   col_num_3_5     decimal(5,5)
,   col_num_float   decimal
,   col_float32     real
,   col_float64     double precision
,   col_varchar_30  varchar(30)
,   col_char_2      char(2)
,   col_nvarchar_30 varchar(30)
,   col_nchar_2     char(2)
,   col_date        date
,   col_ts          timestamp(6)
,   col_tstz        timestamp(6) with time zone
--,   col_tsltz       timestamp(6) with time zone
,   col_interval_ds INTERVAL DAY TO SECOND (3)
,   col_raw         bytea
,   col_long_raw    bytea
,   col_blob        bytea
,   col_clob        text
,   col_nclob       text
);
COMMENT ON TABLE pso_data_validator.dvt_ora2pg_types IS 'Oracle to PostgreSQL integration test table';

-- Literals below match corresponding table in oracle_test_tables.sql
INSERT INTO pso_data_validator.dvt_ora2pg_types VALUES
(1,1111,123456789,123456789012345678,1234567890123456789012345
,0.1,123.1
--,123400,0.001
,123.123,123456.1,12345678.1
,'Hello DVT','A ','Hello DVT','A '
,DATE'1970-01-01',TIMESTAMP'1970-01-01 00:00:01.123456'
,TIMESTAMP WITH TIME ZONE'1970-01-01 00:00:01.123456 +00:00'
--,TIMESTAMP WITH TIME ZONE'1970-01-01 00:00:01.123456 +00:00'
,INTERVAL '1 2:03:44.0' DAY TO SECOND(3)
,CAST('DVT' AS BYTEA),CAST('DVT' AS BYTEA)
,CAST('DVT' AS BYTEA),'DVT A','DVT A')
,(2,2222,123456789,123456789012345678,1234567890123456789012345
,123.12,123.11
--,123400,0.002
,123.123,123456.1,12345678.1
,'Hello DVT','B ','Hello DVT','B '
,DATE'1970-01-02',TIMESTAMP'1970-01-02 00:00:01.123456'
,TIMESTAMP WITH TIME ZONE'1970-01-02 00:00:02.123456 -02:00'
--,TIMESTAMP WITH TIME ZONE'1970-01-02 00:00:02.123456 -02:00'
,INTERVAL '2 3:04:55.666' DAY TO SECOND(3)
,CAST('DVT' AS BYTEA),CAST('DVT DVT' AS BYTEA)
,CAST('DVT DVT' AS BYTEA),'DVT B','DVT B')
,(3,3333,123456789,123456789012345678,1234567890123456789012345
,123.123,123.11
--,123400,0.003
,123.123,123456.1,12345678.1
,'Hello DVT','C ','Hello DVT','C '
,DATE'1970-01-03',TIMESTAMP'1970-01-03 00:00:01.123456'
,TIMESTAMP WITH TIME ZONE'1970-01-03 00:00:03.123456 -03:00'
--,TIMESTAMP WITH TIME ZONE'1970-01-03 00:00:03.123456 -03:00'
,INTERVAL '3 4:05:06.7' DAY TO SECOND(3)
,CAST('DVT' AS BYTEA),CAST('DVT DVT DVT' AS BYTEA)
,CAST('DVT DVT DVT' AS BYTEA),'DVT C','DVT C'
);

 /* Following table used for validating generating table partitions */
drop table if exists public.test_generate_partitions ;
CREATE TABLE public.test_generate_partitions (
        course_id VARCHAR(12),
        quarter_id INTEGER,
        recd_timestamp TIMESTAMP,
        registration_date DATE,
        approved Boolean,
        grade NUMERIC,
        PRIMARY KEY (course_id, quarter_id, recd_timestamp, registration_date, approved));
COMMENT ON TABLE public.test_generate_partitions IS 'Table for testing generate table partitions, consists of 32 rows with a composite primary key';

INSERT INTO public.test_generate_partitions (course_id, quarter_id, recd_timestamp, registration_date, approved, grade) VALUES
        ('ALG001', 1234, '2023-08-26 4:00pm', '1969-07-20', True, 3.5),
        ('ALG001', 1234, '2023-08-26 4:00pm', '1969-07-20', False, 2.8),
        ('ALG001', 5678, '2023-08-26 4:00pm', '2023-08-23', True, 2.1),
        ('ALG001', 5678, '2023-08-26 4:00pm', '2023-08-23', False, 3.5),
        ('ALG003', 1234, '2023-08-27 3:00pm', '1969-07-20', True, 3.5),
        ('ALG003', 1234, '2023-08-27 3:00pm', '1969-07-20', False, 2.8),
        ('ALG003', 5678, '2023-08-27 3:00pm', '2023-08-23', True, 2.1),
        ('ALG003', 5678, '2023-08-27 3:00pm', '2023-08-23', False, 3.5),
        ('ALG002', 1234, '2023-08-26 4:00pm', '1969-07-20', True, 3.5),
        ('ALG002', 1234, '2023-08-26 4:00pm', '1969-07-20', False, 2.8),
        ('ALG002', 5678, '2023-08-26 4:00pm', '2023-08-23', True, 2.1),
        ('ALG002', 5678, '2023-08-26 4:00pm', '2023-08-23', False, 3.5),
        ('ALG004', 1234, '2023-08-27 3:00pm', '1969-07-20', True, 3.5),
        ('ALG004', 1234, '2023-08-27 3:00pm', '1969-07-20', False, 2.8),
        ('ALG004', 5678, '2023-08-27 3:00pm', '2023-08-23', True, 2.1),
        ('ALG004', 5678, '2023-08-27 3:00pm', '2023-08-23', False, 3.5),
        ('St. John''s', 1234, '2023-08-26 4:00pm', '1969-07-20', True, 3.5),
        ('St. John''s', 1234, '2023-08-26 4:00pm', '1969-07-20', False, 2.8),
        ('St. John''s', 5678, '2023-08-26 4:00pm', '2023-08-23', True, 2.1),
        ('St. John''s', 5678, '2023-08-26 4:00pm', '2023-08-23', False, 3.5),
        ('St. Jude''s', 1234, '2023-08-27 3:00pm', '1969-07-20', True, 3.5),
        ('St. Jude''s', 1234, '2023-08-27 3:00pm', '1969-07-20', False, 2.8),
        ('St. Jude''s', 5678, '2023-08-27 3:00pm', '2023-08-23', True, 2.1),
        ('St. Jude''s', 5678, '2023-08-27 3:00pm', '2023-08-23', False, 3.5),
        ('St. Edward''s', 1234, '2023-08-26 4:00pm', '1969-07-20', True, 3.5),
        ('St. Edward''s', 1234, '2023-08-26 4:00pm', '1969-07-20', False, 2.8),
        ('St. Edward''s', 5678, '2023-08-26 4:00pm', '2023-08-23', True, 2.1),
        ('St. Edward''s', 5678, '2023-08-26 4:00pm', '2023-08-23', False, 3.5),
        ('St. Paul''s', 1234, '2023-08-27 3:00pm', '1969-07-20', True, 3.5),
        ('St. Paul''s', 1234, '2023-08-27 3:00pm', '1969-07-20', False, 2.8),
        ('St. Paul''s', 5678, '2023-08-27 3:00pm', '2023-08-23', True, 2.1),
        ('St. Paul''s', 5678, '2023-08-27 3:00pm', '2023-08-23', False, 3.5);

DROP TABLE IF EXISTS pso_data_validator.dvt_null_not_null;
CREATE TABLE pso_data_validator.dvt_null_not_null
(   col_nn             TIMESTAMP(0) NOT NULL
,   col_nullable       TIMESTAMP(0)
,   col_src_nn_trg_n   TIMESTAMP(0) NOT NULL
,   col_src_n_trg_nn   TIMESTAMP(0)
);
COMMENT ON TABLE pso_data_validator.dvt_null_not_null IS 'Nullable integration test table, PostgreSQL is assumed to be a DVT source (not target).';

DROP TABLE IF EXISTS pso_data_validator.dvt_pg_types;
CREATE TABLE pso_data_validator.dvt_pg_types
(   id              serial NOT NULL PRIMARY KEY
,   col_int2        smallint
,   col_int4        int
,   col_int8        bigint
,   col_dec         decimal
,   col_dec_10_2    decimal(10,2)
--,   col_money       money
,   col_float32     real
,   col_float64     double precision
,   col_varchar_30  varchar(30)
,   col_char_2      char(2)
,   col_text        text
,   col_date        date
,   col_ts          timestamp(6) without time zone
,   col_tstz        timestamp(6) with time zone
,   col_time        time(6) without time zone
,   col_timetz      time(6) with time zone
,   col_binary      bytea
,   col_bool        boolean
--,   col_bit         bit(3)
--,   col_bitv        bit varying(3)
,   col_uuid        uuid
,   col_oid         oid
);
COMMENT ON TABLE pso_data_validator.dvt_pg_types IS 'PostgreSQL data types integration test table';

CREATE EXTENSION pgcrypto;
INSERT INTO pso_data_validator.dvt_pg_types
(col_int2,col_int4,col_int8,col_dec,col_dec_10_2
--,col_money
,col_float32,col_float64
,col_varchar_30,col_char_2,col_text
,col_date,col_ts,col_tstz,col_time,col_timetz
,col_binary,col_bool
--,col_bit,col_bitv
,col_uuid,col_oid)
VALUES
(1111,123456789,123456789012345678,12345678901234567890.12345,123.12
--,123.12
,123456.1,12345678.1
,'Hello DVT','A ','Hello DVT'
,DATE'1970-01-01',TIMESTAMP'1970-01-01 00:00:01.123456'
,TIMESTAMP WITH TIME ZONE'1970-01-01 00:00:01.123456 +00:00'
,TIME'00:00:01.123456',TIME WITH TIME ZONE'00:00:01.123456 +00:00'
,CAST('DVT' AS BYTEA),CAST(0 AS BOOLEAN)
--,B'101', B'101'
,gen_random_uuid(),1)
,(2222,223456789,223456789012345678,22345678901234567890.12345,223.12
--,223.12
,223456.1,22345678.1
,'Hello DVT','B ','Hello DVT'
,DATE'1970-01-02',TIMESTAMP'1970-01-02 00:00:02.123456'
,TIMESTAMP WITH TIME ZONE'1970-01-02 00:00:02.123456 +00:00'
,TIME'00:00:02.123456',TIME WITH TIME ZONE'00:00:02.123456 +00:00'
,CAST('DVT' AS BYTEA),CAST(0 AS BOOLEAN)
--,B'011', B'110'
,gen_random_uuid(),2);

DROP TABLE IF EXISTS pso_data_validator.dvt_large_decimals;
CREATE TABLE pso_data_validator.dvt_large_decimals
(   id              DECIMAL(38) NOT NULL PRIMARY KEY
,   col_data        VARCHAR(10)
,   col_dec_18      DECIMAL(18)
,   col_dec_38      DECIMAL(38)
,   col_dec_38_9    DECIMAL(38,9)
,   col_dec_38_30   DECIMAL(38,30)
);
COMMENT ON TABLE pso_data_validator.dvt_large_decimals IS 'Large decimals integration test table';

INSERT INTO pso_data_validator.dvt_large_decimals VALUES
(123456789012345678901234567890
,'Row 1'
,123456789012345678
,12345678901234567890123456789012345678
,12345678901234567890123456789.123456789
,12345678.123456789012345678901234567890)
,(223456789012345678901234567890
,'Row 2'
,223456789012345678
,22345678901234567890123456789012345678
,22345678901234567890123456789.123456789
,22345678.123456789012345678901234567890)
,(323456789012345678901234567890
,'Row 3'
,323456789012345678
,32345678901234567890123456789012345678
,32345678901234567890123456789.123456789
,32345678.123456789012345678901234567890);

DROP TABLE IF EXISTS pso_data_validator.dvt_binary;
CREATE TABLE pso_data_validator.dvt_binary
(   binary_id       bytea NOT NULL PRIMARY KEY
,   int_id          int NOT NULL
,   other_data      varchar(100)
);
CREATE UNIQUE INDEX dvt_binary_int_id_uk ON pso_data_validator.dvt_binary (int_id);
COMMENT ON TABLE pso_data_validator.dvt_binary IS 'Integration test table used to test both binary pk matching and binary hash/concat comparisons.';
INSERT INTO pso_data_validator.dvt_binary VALUES
(CAST('DVT-key-1' AS bytea), 1, 'Row 1'),
(CAST('DVT-key-2' AS bytea), 2, 'Row 2'),
(CAST('DVT-key-3' AS bytea), 3, 'Row 3'),
(CAST('DVT-key-4' AS bytea), 4, 'Row 4'),
(CAST('DVT-key-5' AS bytea), 5, 'Row 5');

DROP TABLE pso_data_validator.dvt_char_id;
CREATE TABLE pso_data_validator.dvt_char_id
(   id          char(6) NOT NULL PRIMARY KEY
,   other_data  varchar(100)
);
COMMENT ON TABLE pso_data_validator.dvt_char_id IS 'Integration test table used to test CHAR pk matching.';
INSERT INTO pso_data_validator.dvt_char_id VALUES
('DVT1', 'Row 1'),
('DVT2', 'Row 2'),
('DVT3', 'Row 3'),
('DVT4', 'Row 4'),
('DVT5', 'Row 5');

DROP TABLE pso_data_validator.dvt_pangrams;
CREATE TABLE pso_data_validator.dvt_pangrams
(   id          int
,   lang        varchar(100)
,   words       varchar(1000)
,   words_en    varchar(1000)
,   CONSTRAINT dvt_pangrams_pk PRIMARY KEY (id)
);
COMMENT ON TABLE pso_data_validator.dvt_pangrams IS 'Integration test table used to test unicode characters.';
-- Text taken from Wikipedia, we cannot guarantee translations :-)
INSERT INTO pso_data_validator.dvt_pangrams VALUES
(1,'Hebrew', 'שפן אכל קצת גזר בטעם חסה, ודי',
 'A bunny ate some lettuce-flavored carrots, and he had enough'),
(2,'Polish', 'Pchnąć w tę łódź jeża lub ośm skrzyń fig',
 'Push a hedgehog or eight crates of figs in this boat'),
(3,'Russian', 'Съешь ещё этих мягких французских булок, да выпей же чаю',
 'Eat more of these soft French loaves and drink a tea'),
(4,'Swedish', 'Schweiz för lyxfjäder på qvist bakom ugn',
 'Switzerland brings luxury feather on branch behind oven'),
(5,'Turkish', 'Pijamalı hasta yağız şoföre çabucak güvendi',
 'The sick person in pyjamas quickly trusted the swarthy driver');
