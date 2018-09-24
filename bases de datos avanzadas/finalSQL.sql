----------------------------------------------------------------------------
------------------------------ E X T R A C C I O N -----------------------------------
DROP TABLE  H_HECHOS_CONF;
DROP TABLE H_SEASON;



--------------------------------------------------------------------------------------


DROP MATERIALIZED VIEW MV_ALL;


-- VISTA Equipos
CREATE MATERIALIZED VIEW MV_ALL
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT  'OFC' As CONFEDERATION, LEAGUE, SEASON, FECHA, HOMETEAM, AWAYTEAM,
HOMESCORE, AWAYSCORE, HOMESCORE+AWAYSCORE AS GOLESPARTIDO FROM OFC
--@DAVIDDBQRO

UNION

SELECT 'CAF' As CONFEDERATION, LEAGUE, SEASON, FECHA, HOMETEAM, AWAYTEAM,
HOMESCORE, AWAYSCORE, HOMESCORE+AWAYSCORE AS GOLESPARTIDO  FROM CAF
--@RAMONQRO

UNION

SELECT 'CONMEBOL' As CONFEDERATION, LEAGUE, SEASON, FECHA, HOMETEAM, AWAYTEAM,
HOMESCORE, AWAYSCORE, HOMESCORE+AWAYSCORE AS GOLESPARTIDO  FROM CONMEBOL
--@SALMONDB

UNION

SELECT 'CONCACAF' As CONFEDERATION, LEAGUE, SEASON, FECHA, HOMETEAM, AWAYTEAM,
HOMESCORE, AWAYSCORE, HOMESCORE+AWAYSCORE AS GOLESPARTIDO  FROM CONCACAF
--@MANEQRO

UNION

SELECT 'AFC' As CONFEDERATION, LEAGUE, SEASON, FECHA, HOMETEAM, AWAYTEAM,
HOMESCORE, AWAYSCORE, HOMESCORE+AWAYSCORE AS GOLESPARTIDO  FROM AFC
--@DAVIDSLPDB

UNION

SELECT 'UEFA' As CONFEDERATION, LEAGUE, SEASON, FECHA, HOMETEAM, AWAYTEAM,
HOMESCORE, AWAYSCORE, HOMESCORE+AWAYSCORE AS GOLESPARTIDO  FROM UEFA;
--@RAMONSLP;

SELECT COUNT(*) FROM MV_ALL;

--------------------------------------------------------------------------------------
-------------------------- T R A N S F O R M A C I O N -------------------------------
--------------------------------------------------------------------------------------



------------- D E S T R U C C I O N      &       C R E A C I O N ---------------------


DROP TABLE D_LIST_CONF ;
 CREATE TABLE D_LIST_CONF
   (    "ID_CONFEDERACION" NUMBER,
    "CONFEDERATION" VARCHAR2(8 BYTE),
     CONSTRAINT "pk_list_conf" PRIMARY KEY ("ID_CONFEDERACION")

   ) ;

SELECT COUNT(*) FROM D_LIST_CONF;

   

-----
DROP TABLE D_PARTIDOS_CONF;

CREATE TABLE D_PARTIDOS_CONF
   (
  "ID_PARTIDO" NUMBER,
  "CONFEDERATION" VARCHAR2(50 BYTE),
  "FECHA" DATE,
  "LEAGUE" VARCHAR2(50 BYTE),
  "HOMETEAM" VARCHAR2(128 BYTE),
  "AWAYTEAM" VARCHAR2(50 BYTE),

   CONSTRAINT PK_PARTIDOS_CONF PRIMARY KEY ("ID_PARTIDO")

   );

-----
SELECT COUNT(*) FROM D_PARTIDOS_CONF;


 DROP TABLE D_TIEMPO ;
 
 CREATE TABLE D_TIEMPO
   (  "DTIEMPOPK" NUMBER NOT NULL ENABLE,
  "FECHA" DATE,
  "ANIO" VARCHAR2(4 BYTE),
  "MES" VARCHAR2(30 BYTE),
  "DIA" NUMBER,
  "NOMBREDIA" VARCHAR2(20 BYTE),
  "TEMPORADA" VARCHAR2(40 BYTE),
   CONSTRAINT "PK_TIEMPO" PRIMARY KEY ("DTIEMPOPK")
   );
SELECT COUNT(*) FROM D_TIEMPO;

---




 DROP TABLE H_CONF ;


   CREATE TABLE H_CONF
   (  "ID_HECHOS" NUMBER NOT NULL ENABLE,
  "DTIEMPOPK" NUMBER NOT NULL ENABLE,
  "DCONFEPK" NUMBER NOT NULL ENABLE,
  "DPARTIDOSPK" NUMBER NOT NULL ENABLE,
  "SUMA" NUMBER NOT NULL ENABLE,
   CONSTRAINT "PK_HECHOS_C" PRIMARY KEY ("ID_HECHOS", "DCONFEPK", "DPARTIDOSPK", "DTIEMPOPK"),

   CONSTRAINT "DTIEMPOPK_C" FOREIGN KEY ("DTIEMPOPK")
    REFERENCES "D_TIEMPO" ("DTIEMPOPK") ENABLE,
   CONSTRAINT "CONFFK_C" FOREIGN KEY ("DCONFEPK")
    REFERENCES "D_LIST_CONF" ("ID_CONFEDERACION") ENABLE,
   CONSTRAINT "PFK_C" FOREIGN KEY ("DPARTIDOSPK")
    REFERENCES "D_PARTIDOS_CONF" ("ID_PARTIDO") ENABLE
   );


----- S E C U E N C I A S -----


DROP SEQUENCE   SEQ_D_PARTIDOS_CONF;
DROP SEQUENCE    SEQ_D_LIST_CONF ;
DROP SEQUENCE   SEQ_D_TIEMPO ;
DROP SEQUENCE   SEQ_H_CONF ;



CREATE SEQUENCE   SEQ_D_PARTIDOS_CONF;
CREATE SEQUENCE    SEQ_D_LIST_CONF ;
CREATE SEQUENCE   SEQ_D_TIEMPO ;
CREATE SEQUENCE   SEQ_H_CONF ;



------------------------------------------------------------------------------------------------
------------------------- A C T U A L I Z A   T A B L A S ---------------------------------------
------------------------------------------------------------------------------------------------


create or replace PROCEDURE ACTUALIZA_PARTIDOS_CONF
AS

BEGIN
  
    insert into D_PARTIDOS_CONF 
      SELECT SEQ_D_PARTIDOS_CONF.nextval,CONFEDERATION, FECHA,  LEAGUE, HOMETEAM, AWAYTEAM from MV_ALL
      where not exists (
    select LEAGUE, HOMETEAM, AWAYTEAM, FECHA, CONFEDERATION from D_PARTIDOS_CONF );
    
    COMMIT;
END ACTUALIZA_PARTIDOS_CONF;

execute ACTUALIZA_PARTIDOS_CONF;
select count(*) from D_PARTIDOS_CONF
---


create or replace PROCEDURE ACTUALIZA_LISTA_CONF
AS

  vConf VARCHAR2(8);

  cursor c_confederacion is
    select UNIQUE CONFEDERATION
      FROM MV_ALL;
  
BEGIN
    DELETE FROM D_LIST_CONF;

  open c_confederacion;
  LOOP
    fetch c_confederacion into vConf;
    exit when c_confederacion%NOTFOUND;
    
    insert into D_LIST_CONF (ID_CONFEDERACION, CONFEDERATION )
      VALUES (SEQ_D_LIST_CONF.nextval, vConf);
    COMMIT;
  END LOOP;
  close c_confederacion;
END ACTUALIZA_LISTA_CONF;



execute ACTUALIZA_LISTA_CONF;
select count(*) from D_LIST_CONF;
DELETE from D_LIST_CONF;

---
---





create or replace PROCEDURE PDIMTIEMPOFECHA (FechaInicial in date, FechaFinal in date) AS
fi date;
ff date;
resta number;
anio varchar2(4);
mes varchar2(10);
dia number;
nd varchar2(10);
nt varchar2(30);
compara number;
BEGIN
  fi := FechaInicial;
  ff := FechaFinal;
  resta := ff - fi;

  for contador in 1 .. resta
  LOOP



  anio := to_char(fi, 'YYYY');
  mes  := to_char(fi, 'MM');
  dia  := to_number(to_char(fi,'DD'));
  nd:= to_char(to_date(fi), 'DAY');
  compara  := to_number(to_char(fi, 'MM'));

IF compara>7 THEN

    nt:= to_char(CONCAT(to_char(fi, 'YY'), '-'));
    nt:= to_char(CONCAT(nt, to_char(fi+360, 'YY')));

ELSE
    nt:= to_char(CONCAT( to_char(fi-360, 'YY'), '-' ));
    nt:= to_char(CONCAT( nt, to_char(fi, 'YY')));

END IF;



  insert into D_TIEMPO values (contador, fi, anio, mes, dia,nd, nt);
  commit;
  fi := fi+1;
  END LOOP;

END PDIMTIEMPOFECHA;




























DELETE FROM D_TIEMPO;
DELETE FROM H_CONF;
DELETE FROM D_LIST_CONF;
DELETE FROM D_PARTIDOS_CONF;



execute ACTUALIZA_PARTIDOS_CONF;
execute PDIMTIEMPOFECHA('01/JAN/00', SYSDATE);
execute ACTUALIZA_LISTA_CONF;




create or replace PROCEDURE ACTUALIZA_HECHOS_CONF
AS

    vID_HECHOS number;
    vDCONFEPK number;
    vDPARTIDOSPK number;
    vDTIEMPOPK number;
    vSUMA number ;





cursor c_hechos is
select p.ID_PARTIDO ,  l.ID_CONFEDERACION, t.DTIEMPOPK,g.GOLESPARTIDO
      FROM D_PARTIDOS_CONF p, D_TIEMPO t, D_LIST_CONF l, MV_ALL g where p.FECHA=t.FECHA and p.CONFEDERATION = l.confederation
      and g.HOMETEAM=p.hometeam and g.awayteam=p.awayteam and g.FECHA = p.fecha;
     

BEGIN
    delete from H_CONF;
  open c_hechos;
  LOOP
    fetch c_hechos into  vDPARTIDOSPK, vDCONFEPK , vDTIEMPOPK, vSUMA;
    exit when c_hechos%NOTFOUND;
    insert into H_CONF (ID_HECHOS, DTIEMPOPK, DCONFEPK, DPARTIDOSPK, SUMA )
      VALUES (SEQ_H_CONF.nextval, vDTIEMPOPK, vDCONFEPK, vDPARTIDOSPK, vSUMA);
    COMMIT;
  END LOOP;
  close c_hechos;
END ACTUALIZA_HECHOS_CONF;

----


execute ACTUALIZA_HECHOS_CONF;
SELECT COUNT(*) FROM H_CONF;