
--La temporada en la que más goles ha habido en total


SELECT * FROM (SELECT Season, SUM(SUMA) as GOLES_TOTALES  
FROM H_SEASON, D_LIST_SEASON where ID_SEASON=DSEASONPK 
GROUP BY Season  ORDER BY GOLES_TOTALES DESC) WHERE rownum=1;
--La temporada con menos goles que ha habido en total

SELECT * FROM (SELECT Season, SUM(SUMA) as GOLES_TOTALES  
FROM H_SEASON, D_LIST_SEASON where ID_SEASON=DSEASONPK 
GROUP BY Season  ORDER BY GOLES_TOTALES ASC) WHERE rownum=1;

--La temporada con menos partidos en total

SELECT * FROM (SELECT Season, Count(dpartidospk) as PARTIDOS_TOTALES  
FROM H_SEASON, D_LIST_SEASON where ID_SEASON=DSEASONPK 
GROUP BY Season  ORDER BY PARTIDOS_TOTALES ASC) WHERE rownum=1;

--La temporada con más partidos en total

SELECT * FROM (SELECT Season, Count(dpartidospk) as PARTIDOS_TOTALES  
FROM H_SEASON, D_LIST_SEASON where ID_SEASON=DSEASONPK 
GROUP BY Season  ORDER BY PARTIDOS_TOTALES DESC) WHERE rownum=1;

--La temporada con más empates (DIFERENCIA=0)


SELECT * FROM (SELECT Season, COUNT(DPARTIDOSPK) as empates
FROM H_SEASON, D_LIST_SEASON where ID_SEASON=DSEASONPK and DIFERENCIA=0
GROUP BY Season  ORDER BY empates DESC) WHERE rownum=1;

-----------
