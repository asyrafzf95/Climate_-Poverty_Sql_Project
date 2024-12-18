CREATE DATABASE Countries;
-- DROP DATABASE countries;
-- DROP TABLE climate;
-- DROP TABLE poverty;

ALTER TABLE climate
CHANGE `avg_temperature_(°c)` avg_temperature_celsius DECIMAL(10,2),
CHANGE `co2_emissions_(tons/capita)` co2_emissions_tons_per_capita DECIMAL(10,2),
CHANGE `sea_level_rise_(mm)` sea_level_rise_mm DECIMAL(5,2),
CHANGE `rainfall_(mm)` rainfall_mm DECIMAL(7,2),  -- Cambiar de DECIMAL(5,2) a DECIMAL(7,2)
CHANGE `renewable_energy_(%)` renewable_energy_percent DECIMAL(5,2),
CHANGE `forest_area_(%)` forest_area_percent DECIMAL(5,2);

SELECT *
FROM climate_sql;

SELECT *
FROM country;

SELECT *
FROM happiness;

SELECT *
FROM poverty;



-- ----- TABLA POVERTY

-- 1. Mostrar cuántas encuestas fueron hechas en 2002 en la tabla "poverty".

SELECT COUNT(reporting_level)
FROM poverty
WHERE year= 2002;

-- 2. Devolver todos los valores donde la encuesta se haya realizado en entornos rurales en 2002.

SELECT *
FROM poverty
WHERE year=2002 AND reporting_level = 'rural';

-- 3. Devolver las 10 filas con mayor déficit (shortfall) a nivel global.

SELECT avg_shortfall_international_povline as shortfall
FROM poverty
ORDER BY shortfall DESC
LIMIT 10;


-- 4. Devolver las filas con mayor ratio de desigualdad por salario (income_gap).

SELECT income_gap_ratio_international_povline AS income
FROM poverty
ORDER BY income DESC;

-- 5. Devolver cuántas filas tienen un índice de polarización mayor al 45%.

SELECT COUNT(*)
FROM poverty
WHERE polarization > 0.45;

-- -----TABLA HAPPINESS

-- 6. La región con la media de puntuación de felicidad más alta (tabla "happiness")

SELECT AVG(happiness_score) as felicidad_media
FROM happiness
ORDER BY felicidad_media DESC
LIMIT 1;

-- 7. Las 3 regiones con la media de generosidad más baja. 

SELECT region, AVG(generosity) AS average_generosity
FROM happiness
GROUP BY region
ORDER BY average_generosity
LIMIT 3;

-- 8. La región con la máxima libertad para tomar decisiones

SELECT region, MAX(freedom_to_make_life_choices) as max_libertad
FROM happiness
GROUP BY region
ORDER BY max_libertad DESC
LIMIT 1;


-- 9. La media de apoyo social de todos los registros.

SELECT AVG(social_support)
FROM happiness;

-- 10. Cuántos registros de la región subsahariana hay de 2020.

SELECT COUNT(*)
FROM happiness
WHERE  region = 'Sub-Saharan Africa';


-- ----- TABLA CLIMATE

-- 11. Recupera la temperatura media global en el año 2019.

SELECT *
FROM climate;


SELECT year, AVG(avg_temperature_celsius)
FROM climate
WHERE year= 2019
GROUP BY year;

-- 12. El año donde el promedio de la subida del nivel del mar ha sido mayor.

SELECT year, AVG(sea_level_rise_mm) as avg_rise_sea
FROM climate
GROUP BY year
ORDER BY avg_rise_sea DESC
LIMIT 1;

-- 13. Las emisiones de C02 para el registro con mayor población.

SELECT co2_emissions_tons_per_capita, MAX(population)
FROM climate
GROUP BY co2_emissions_tons_per_capita
LIMIT 1;

-- 14. El año en el que el promedio de eventos extremos ha sido mayor

SELECT year, AVG(extreme_weather_events) AS med_extremo
FROM climate
GROUP BY year
ORDER BY med_extremo DESC
LIMIT 1;

-- 15. Cuál es el registro con mayor área forestal.

SELECT MAX(forest_area_percent)
FROM climate;

-- Con Joins

-- 16. Devuélvenos los países con mayor desigualdad en los ingresos.

SELECT c.country, MAX(p.income_gap_ratio_international_povline) AS desigual
FROM poverty p
JOIN country c
USING (country_id)
GROUP BY c.country
ORDER BY desigual DESC;

-- 17. Compara la media de felicidad de medios rurales respecto a los medios urbanos.

SELECT *
FROM happiness;

SELECT *
FROM climate;

SELECT AVG(h.happiness_score), p.reporting_level
FROM country c
JOIN happiness h
USING (country_id)
JOIN poverty p
USING (country_id)
GROUP BY p.reporting_level
HAVING p.reporting_level='urban' OR p.reporting_level='rural';

-- 18. Compara las emisiones de CO2 

SELECT AVG(cl.co2_emissions_tons_per_capita), p.reporting_level
FROM country c
JOIN climate cl
USING (country_id)
JOIN poverty p
USING (country_id)
GROUP BY p.reporting_level;



-- 19. Devolver todos los países cuya felicidad está por encima de la media. SUBQUERY
       
SELECT c.country
FROM country c
WHERE (SELECT AVG(h.happiness_score)
       FROM happiness h
       WHERE h.country_id = c.country_id) < 
      (SELECT h.happiness_score
       FROM happiness h
       WHERE h.country_id = c.country_id LIMIT 1);
       
-- 20. Etiquetar todos los países según el nivel promedio de felicidad sea superior a 7.4 como 'Felices', entre 7.4 
-- y 4 como 'Promedio y menor de 4, como 'Infelices'.

SELECT 
    c.country, 
    h.happiness_score,
    CASE
        WHEN happiness_score >= 7.4 THEN 'Alto'
        WHEN happiness_score BETWEEN 4 AND 7.39 THEN 'Medio'
        ELSE 'Bajo'
    END AS happiness_category
FROM happiness h
JOIN country c
USING (country_id);


-- 21. Eventos fatales por país. 

SELECT c.country, SUM(cl.extreme_weather_events) as ev_extr
FROM country c
JOIN climate cl
USING (country_id)
GROUP BY c.country
ORDER BY ev_extr DESC;

-- 22. Categoriza las emisiones de CO2 per cápita por país. 

SELECT c.country,cl.co2_emissions_tons_per_capita,
       CASE
           WHEN cl.co2_emissions_tons_per_capita < 3 THEN 'Bajas'
           WHEN cl.co2_emissions_tons_per_capita BETWEEN 3 AND 6 THEN 'Medias'
           ELSE 'Altas'
       END AS categoría_de_emisiones_de_CO2
FROM climate cl
JOIN country c ON cl.country_id = c.country_id
ORDER BY cl.co2_emissions_tons_per_capita DESC;

-- 23. Muestra la puntuación de felicidad y el PIB allá donde el valor de déficit sea mayor:

SELECT MAX(avg_shortfall_international_povline) FROM poverty;

SELECT happiness_score, gdp_per_capita
FROM happiness
WHERE(SELECT MAX(avg_shortfall_international_povline) FROM poverty WHERE poverty.country_id=happiness.country_id);

 