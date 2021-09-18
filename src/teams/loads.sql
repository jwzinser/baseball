CREATE DATABASE exercises;
\c exercises

CREATE TABLE wsw 
(year integer, name varchar, w integer, l integer);

\copy wsw FROM '/docker-entrypoint-initdb.d/team_redux.csv' DELIMITER ',' CSV ;
