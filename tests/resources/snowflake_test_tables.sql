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

CREATE OR REPLACE TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_CORE_TYPES (
	ID INT NOT NULL,
	COL_INT8 TINYINT,
	COL_INT16 SMALLINT,
	COL_INT32 INT,
	COL_INT64 BIGINT,
	COL_DEC_20 NUMBER(20),
	COL_DEC_38 NUMBER(38),
	COL_DEC_10_2 NUMBER(10,2),
	COL_FLOAT32 FLOAT,
	COL_FLOAT64 FLOAT,
	COL_VARCHAR_30 VARCHAR(30),
	COL_CHAR_2 CHAR(2),
	COL_STRING STRING,
	COL_DATE DATE,
	COL_DATETIME DATETIME,
	COL_TSTZ TIMESTAMP_TZ
);

INSERT INTO PSO_DATA_VALIDATOR.PUBLIC.DVT_CORE_TYPES VALUES
(1,1,1,1,1
 ,12345678901234567890,1234567890123456789012345,123.11,123456.1,12345678.1
 ,'Hello DVT','A ','Hello DVT'
 ,DATE'1970-01-01',TIMESTAMP'1970-01-01 00:00:01'
 ,'1970-01-01 00:00:01 -01:00'),
(2,2,2,2,2
 ,12345678901234567890,1234567890123456789012345,123.22,123456.2,12345678.2
 ,'Hello DVT','B ','Hello DVT'
 ,DATE'1970-01-02',TIMESTAMP'1970-01-02 00:00:02'
 ,'1970-01-02 00:00:02 -02:00'),
(3,3,3,3,3
 ,12345678901234567890,1234567890123456789012345,123.3,123456.3,12345678.3
 ,'Hello DVT','C ','Hello DVT'
 ,DATE'1970-01-03',TIMESTAMP'1970-01-03 00:00:03'
 ,'1970-01-03 00:00:03 -03:00');


CREATE OR REPLACE TABLE PSO_DATA_VALIDATOR.PUBLIC.TEST_GENERATE_PARTITIONS (
        COURSE_ID VARCHAR(6),
        QUARTER_ID INTEGER,
        STUDENT_ID INTEGER,
        GRADE NUMERIC,
        PRIMARY KEY (COURSE_ID, QUARTER_ID, STUDENT_ID));

INSERT INTO PSO_DATA_VALIDATOR.PUBLIC.TEST_GENERATE_PARTITIONS (COURSE_ID, QUARTER_ID, STUDENT_ID, GRADE) VALUES
        ('ALG001', 1, 1234, 2.1),
        ('ALG001', 1, 5678, 3.5),
        ('ALG001', 1, 9012, 2.3),
        ('ALG001', 2, 1234, 3.5),
        ('ALG001', 2, 5678, 2.6),
        ('ALG001', 2, 9012, 3.5),
        ('ALG001', 3, 1234, 2.7),
        ('ALG001', 3, 5678, 3.5),
        ('ALG001', 3, 9012, 2.8),
        ('GEO001', 1, 1234, 2.1),
        ('GEO001', 1, 5678, 3.5),
        ('GEO001', 1, 9012, 2.3),
        ('GEO001', 2, 1234, 3.5),
        ('GEO001', 2, 5678, 2.6),
        ('GEO001', 2, 9012, 3.5),
        ('GEO001', 3, 1234, 2.7),
        ('GEO001', 3, 5678, 3.5),
        ('GEO001', 3, 9012, 2.8),
        ('TRI001', 1, 1234, 2.1),
        ('TRI001', 1, 5678, 3.5),
        ('TRI001', 1, 9012, 2.3),
        ('TRI001', 2, 1234, 3.5),
        ('TRI001', 2, 5678, 2.6),
        ('TRI001', 2, 9012, 3.5),
        ('TRI001', 3, 1234, 2.7),
        ('TRI001', 3, 5678, 3.5),
        ('TRI001', 3, 9012, 2.8);

DROP TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_NULL_NOT_NULL;
CREATE TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_NULL_NOT_NULL
(   col_nn             TIMESTAMP(0) NOT NULL
,   col_nullable       TIMESTAMP(0)
,   col_src_nn_trg_n   TIMESTAMP(0) NOT NULL
,   col_src_n_trg_nn   TIMESTAMP(0)
);
COMMENT ON TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_NULL_NOT_NULL IS 'Nullable integration test table, Oracle is assumed to be a DVT source (not target).';

DROP TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_BINARY;
CREATE TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_BINARY
(   BINARY_ID       BINARY(16) NOT NULL PRIMARY KEY
,   INT_ID          NUMBER(10) NOT NULL
,   OTHER_DATA      VARCHAR2(100)
);
COMMENT ON TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_BINARY IS 'Integration test table used to test both binary pk matching and binary hash/concat comparisons.';
INSERT INTO PSO_DATA_VALIDATOR.PUBLIC.DVT_BINARY VALUES
(TO_BINARY('DVT-key-1', 'UTF-8'), 1, 'Row 1'),
(TO_BINARY('DVT-key-2', 'UTF-8'), 2, 'Row 2'),
(TO_BINARY('DVT-key-3', 'UTF-8'), 3, 'Row 3'),
(TO_BINARY('DVT-key-4', 'UTF-8'), 4, 'Row 4'),
(TO_BINARY('DVT-key-5', 'UTF-8'), 5, 'Row 5');

DROP TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_CHAR_ID;
-- Snowflake deviates from common CHAR semantics, strings are not space-padded.
CREATE TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_CHAR_ID
(   id          CHAR(6) NOT NULL PRIMARY KEY
,   other_data  VARCHAR(100)
);
COMMENT ON TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_CHAR_ID IS 'Integration test table used to test CHAR pk matching.';
INSERT INTO PSO_DATA_VALIDATOR.PUBLIC.DVT_CHAR_ID VALUES
('DVT1  ', 'Row 1'),
('DVT2  ', 'Row 2'),
('DVT3  ', 'Row 3'),
('DVT4  ', 'Row 4'),
('DVT5  ', 'Row 5');

DROP TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_PANGRAMS;
CREATE TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_PANGRAMS
(   id          NUMBER(5)
,   lang        VARCHAR(100)
,   words       VARCHAR(1000)
,   words_en    VARCHAR(1000)
,   CONSTRAINT dvt_pangrams_pk PRIMARY KEY (id)
);
COMMENT ON TABLE PSO_DATA_VALIDATOR.PUBLIC.DVT_PANGRAMS IS 'Integration test table used to test unicode characters.';
-- Text taken from Wikipedia, we cannot guarantee translations :-)
INSERT INTO PSO_DATA_VALIDATOR.PUBLIC.DVT_PANGRAMS VALUES
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
