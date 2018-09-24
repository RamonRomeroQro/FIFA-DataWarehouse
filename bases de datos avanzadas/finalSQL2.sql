--------------------------------------------------------------------------------------
------------------------------ E X T R A C C I O N -----------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
------------------------------ E X T R A C C I O N -----------------------------------
DROP TABLE H_SEASON;
DROP TABLE D_LIST_SEASON;


---
DROP TABLE D_LIST_SEASON ;
 CREATE TABLE D_LIST_SEASON
   (    "ID_SEASON" NUMBER,
    "SEASON" VARCHAR2(20 BYTE),
     CONSTRAINT "pk_list_SEASON" PRIMARY KEY ("ID_SEASON")

   ) ;

-----


 DROP TABLE H_SEASON ;


   CREATE TABLE H_SEASON
   (
  "ID_HECHOS" NUMBER NOT NULL ENABLE,
  "DTIEMPOPK" NUMBER NOT NULL ENABLE,
  "DSEASONPK" NUMBER NOT NULL ENABLE,
  "DPARTIDOSPK" NUMBER NOT NULL ENABLE,
  "SUMA" NUMBER NOT NULL ENABLE,
   CONSTRAINT "PK_HECHOS_S" PRIMARY KEY ("ID_HECHOS", "DSEASONPK", "DPARTIDOSPK", "DTIEMPOPK"),
   
   CONSTRAINT "DTIEMPOPK_S" FOREIGN KEY ("DTIEMPOPK")
    REFERENCES "D_TIEMPO" ("DTIEMPOPK") ENABLE,
   CONSTRAINT "SeasonFK_S" FOREIGN KEY ("DSEASONPK")
    REFERENCES "D_LIST_SEASON" ("ID_SEASON") ENABLE,
   CONSTRAINT "PFK_S" FOREIGN KEY ("DPARTIDOSPK")
    REFERENCES "D_PARTIDOS_CONF" ("ID_PARTIDO") ENABLE

   
   );


----- S E C U E N C I A S -----


DROP SEQUENCE    SEQ_D_LIST_SEASON ;
DROP SEQUENCE   SEQ_H_CONF ;



CREATE SEQUENCE    SEQ_D_LIST_SEASON ;
CREATE SEQUENCE   SEQ_H_SEASON ;



------------------------------------------------------------------------------------------------
------------------------- A C T U A L I Z A   T A B L A S ---------------------------------------
------------------------------------------------------------------------------------------------


create or replace PROCEDURE ACTUALIZA_LISTA_SEASON
AS

  vSeason varchar2(20 BYTE);
  vfecha date;
  compara number;


  cursor c_season is
    select UNIQUE TEMPORADA
      FROM D_TIEMPO;


BEGIN
delete from D_LIST_SEASON;
  open c_season;
  LOOP
    fetch c_season into vSeason;
    exit when c_season%NOTFOUND;
    insert into D_LIST_SEASON (ID_SEASON, SEASON )
      VALUES (SEQ_D_LIST_SEASON.nextval, vSeason);
    COMMIT;
  END LOOP;
  close c_season;
END ACTUALIZA_LISTA_SEASON;



execute ACTUALIZA_LISTA_SEASON;
select count(*) from D_LIST_SEASON;





create or replace PROCEDURE ACTUALIZA_HECHOS_SEASON
AS

    vID_HECHOS number;
    vDSEASONPK number;
    vDPARTIDOSPK number;
    vDTIEMPOPK number;
    vSUMA number ;




cursor c_hechos is

select p.ID_PARTIDO , s.ID_SEASON, t.DTIEMPOPK, g.GOLESPARTIDO
      FROM D_PARTIDOS_CONF p, D_TIEMPO t, D_LIST_SEASON s, MV_ALL g
      where p.FECHA=t.FECHA and t.TEMPORADA=s.SEASON and g.Fecha=p.FECHA and g.Awayteam=p.awayteam 
      and g.hometeam=p.hometeam;

BEGIN
delete FROM H_SEASON;
  open c_hechos;
  LOOP
    fetch c_hechos into  vDPARTIDOSPK, vDSEASONPK , vDTIEMPOPK, vSUMA;
    exit when c_hechos%NOTFOUND;
    insert into H_SEASON (ID_HECHOS, DTIEMPOPK, DSEASONPK, DPARTIDOSPK, SUMA )
      VALUES (SEQ_H_SEASON.nextval, vDTIEMPOPK, vDSEASONPK, vDPARTIDOSPK, vSUMA);
    COMMIT;
  END LOOP;
  close c_hechos;
END ACTUALIZA_HECHOS_SEASON;

----
---
execute ACTUALIZA_HECHOS_SEASON;
