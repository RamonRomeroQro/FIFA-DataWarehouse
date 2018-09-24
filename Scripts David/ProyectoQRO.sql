CREATE TABLE LigasOceania
AS (SELECT DISTINCT League FROM OFC);

CREATE TABLE EquiposOceania
AS (SELECT DISTINCT LEague, HomeTeam FROM OFC UNION SELECT DISTINCT LEague, AwayTEAM FROM OFC );

CREATE TABLE Partidos
AS (SELECT  SEASON, FECHA, HOMETEAM , AWAYTEAM, HOMESCORE, AWAYSCORE, RESULT FROM OFC );

---------------------------------------------------------------------------------------------------------------------
CREATE TABLE CONFEDERACIONES (
    CONFEDERACION VARCHAR2(20) NOT NULL
);

INSERT INTO CONFEDERACIONES(CONFEDERACION) VALUES(
    'UEFA'
);

INSERT INTO CONFEDERACIONES(CONFEDERACION) VALUES(
    'CONCACAF'
);

INSERT INTO CONFEDERACIONES(CONFEDERACION) VALUES(
    'CONMEBOL'
);

INSERT INTO CONFEDERACIONES(CONFEDERACION) VALUES(
    'CAF'
);

INSERT INTO CONFEDERACIONES(CONFEDERACION) VALUES(
    'OFC'
);

INSERT INTO CONFEDERACIONES VALUES(
    'AFC'
);

---------------------------------------------------------------------------------------------------------------------

ALTER TABLE Confederaciones ADD CONSTRAINT PK_Confederaciones PRIMARY KEY (Confederacion);


ALTER TABLE LigasOceania
ADD CONSTRAINT FK_Ligas FOREIGN KEY (Confederacion) REFERENCES COnfederaciones(Confederacion);


ALTER TABLE LigasOceania
ADD CONSTRAINT PK_LigasOceania  PRIMARY KEY (league,Confederacion);

---------------------------------------------------------------------------------------------------------------------

SELECT * FROM lIGASAFRICA@RAMONQRO, LIGASUEFA@RAMONSLP

SELECT * FROM EQUIPOSAFRICA@RAMONQRO, EQUIPOSUEFA@RAMONSLP

---------------------------------------------------------------------------------------------------------------------

INSERT INTO PartidosAfrica@RAMONQRO (SEASON, FECHA, HOMETEAM, AWAYTEAM, HOMESCORE, AWAYSCORE, RESULT) VALUES ('16-17', TO_DATE('2017-03-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Tasman United', 'Waitakere United', '10', '8', 'W');

INSERT INTO PartidosAfrica@RAMONQRO (SEASON, FECHA, HOMETEAM, AWAYTEAM, HOMESCORE, AWAYSCORE, RESULT) VALUES ('16-17', TO_DATE('2017-03-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Tasman United', 'Waitakere United', '10', '8', 'W');

---------------------------------------------------------------------------------------------------------------------

SELECT sum(HOMESCORE) FROM OFC WHERE HOMETEAM='Canterbury United';

SELECT HOMESCORE from OFC where (sum(homescore) <100);

SELECT COUNT(1) AS PARTIDOS_GANADOS FROM PARTIDOSCONMEBOL@SALMONDB WHERE RESULT = 'D'  AND HOMETEAM = 'River Plate';



SELECT * FROM PARTIDOSCONMEBOL@SALMONDB UNION SELECT* FROM PARTIDOSAFRICA@RAMONQRO UNION SELECT * FROM PARTIDOSUEFA@RAMONSLP UNION
SELECT * FROM PARTIDOS@MANADB UNION SELECT * FROM PARTIDOS;