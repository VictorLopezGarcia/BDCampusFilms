/*DIFICULTAD: Muy fácil*/
/*1- Devuelve todas las películas*/

SELECT * FROM PUBLIC.MOVIES; 

/*2- Devuelve todos los géneros existentes*/

SELECT * FROM PUBLIC.GENRES;

/*3- Devuelve la lista de todos los estudios de grabación que estén activos*/

SELECT * 
FROM PUBLIC.STUDIOS
WHERE (STUDIO_ACTIVE = 1);

/*4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma*/

SELECT *
FROM PUBLIC.USERS
ORDER BY USER_JOIN_DATE DESC
LIMIT 20;

/*DIFICULTAD: Fácil
5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor*/

/*ORDENADAS POR DURACIÓN*/
SELECT MOVIE_NAME AS "Pelicula",
MOVIE_DURATION AS "Duracion"
FROM PUBLIC.MOVIES m
WHERE (m.MOVIE_ID IN (SELECT MOVIE_ID 
	FROM PUBLIC.USER_MOVIE_ACCESS 
	GROUP BY MOVIE_ID
	ORDER BY COUNT(*)
	LIMIT 20)
)
ORDER BY MOVIE_DURATION DESC;


/*ORDENADAS POR FRECUENCIA*/
SELECT MOVIE_NAME AS "Pelicula",
MOVIE_DURATION AS "Duracion"
FROM PUBLIC.MOVIES m
JOIN PUBLIC.USER_MOVIE_ACCESS u ON m.MOVIE_ID =  u.MOVIE_ID
GROUP BY m.MOVIE_ID
ORDER BY COUNT(*) DESC
LIMIT 20;


/*6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.*/

SELECT * FROM PUBLIC.MOVIES m 
WHERE (m.MOVIE_RELEASE_DATE >= '2000-01-01' AND m.MOVIE_NAME LIKE 'A%' );

/*7- Devuelve los actores nacidos un mes de Junio*/

SELECT * FROM PUBLIC.ACTORS a 
WHERE MONTH(a.ACTOR_BIRTH_DATE) = 6;

/*8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos*/

SELECT * FROM PUBLIC.ACTORS a 
WHERE (MONTH(a.ACTOR_BIRTH_DATE) != 6 AND a.ACTOR_DEAD_DATE IS NULL);

/*9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos*/

SELECT 
a.ACTOR_NAME AS "Actor",
DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE ,CURDATE()) AS "Edad"
FROM PUBLIC.ACTORS a
WHERE ( ( DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE ,CURDATE())  <= 50) AND a.ACTOR_DEAD_DATE IS NULL);


/*10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido*/


SELECT 
a.ACTOR_NAME AS "Actor",
DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE ,CURDATE()) AS "Edad"
FROM PUBLIC.ACTORS a
WHERE ( ( DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE ,CURDATE())  < 50) AND a.ACTOR_DEAD_DATE IS NOT NULL);

/*11- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos*/

SELECT 
a.ACTOR_NAME AS "Actor",
DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE ,CURDATE()) AS "Edad"
FROM PUBLIC.ACTORS a
WHERE ( ( DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE ,CURDATE())  <= 40) AND a.ACTOR_DEAD_DATE IS NULL);


/*12- Indica la edad media de los directores vivos*/

SELECT 
AVG(DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE  ,CURDATE())) AS "Edad media directores vivos"
FROM PUBLIC.DIRECTORS d 
WHERE ( d.DIRECTOR_DEAD_DATE  IS NULL);

/*13- Indica la edad media de los actores que han fallecido*/

SELECT 
AVG(DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE   ,CURDATE())) AS "Edad media actores fallecidos"
FROM PUBLIC.ACTORS a
WHERE ( a.ACTOR_DEAD_DATE IS NOT NULL);

/*DIFICULTAD: Media
14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado*/


SELECT m.MOVIE_NAME AS "Pelicula",
s.STUDIO_NAME AS "Estudio"
FROM PUBLIC.MOVIES m 
JOIN PUBLIC.STUDIOS s ON s.STUDIO_ID = m.STUDIO_ID;

/*15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015*/


SELECT * FROM PUBLIC.USERS u
WHERE (u.USER_ID IN (SELECT uma.USER_ID 
					FROM PUBLIC.USER_MOVIE_ACCESS uma 
					WHERE ('2010-01-01' <= uma.ACCESS_DATE AND uma.ACCESS_DATE <= '2015-01-01')));

/*16- Devuelve cuantas películas hay de cada país*/


SELECT n.NATIONALITY_NAME AS "Pais",
COUNT(*) AS "Peliculas" 
FROM PUBLIC.NATIONALITIES n 
JOIN PUBLIC.MOVIES m ON m.NATIONALITY_ID = n.NATIONALITY_ID
GROUP BY n.NATIONALITY_ID ;


/*17- Devuelve todas las películas que hay de género documental*/

SELECT * FROM PUBLIC.MOVIES m 
JOIN PUBLIC.GENRES g ON	g.GENRE_ID = m.GENRE_ID
WHERE (g.GENRE_NAME = 'Documentary');



/*18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos*/


SELECT * FROM PUBLIC.MOVIES m 
WHERE DIRECTOR_ID IN (SELECT d.DIRECTOR_ID 
						FROM PUBLIC.DIRECTORS d 
						WHERE (d.DIRECTOR_BIRTH_DATE >= '1980-01-01' AND d.DIRECTOR_DEAD_DATE IS NULL ))


/*19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores*/
	
SELECT d.DIRECTOR_BIRTH_PLACE AS "Lugar",
d.DIRECTOR_NAME AS "Director",
u.USER_NAME AS "Usuario"
FROM PUBLIC.DIRECTORS d 
JOIN PUBLIC.USERS u ON u.USER_TOWN = d.DIRECTOR_BIRTH_PLACE;


/*20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo*/

SELECT m.MOVIE_NAME AS "Pelicula",
YEAR(m.MOVIE_RELEASE_DATE) AS "Año"
FROM PUBLIC.MOVIES m 
WHERE (m.STUDIO_ID IN (SELECT s.STUDIO_ID 
						FROM PUBLIC.STUDIOS s 
						WHERE (STUDIO_ACTIVE = FALSE)));


/*21- Devuelve una lista de las últimas 10 películas a las que se ha accedido*/

SELECT * FROM PUBLIC.MOVIES m
WHERE m.MOVIE_ID IN (SELECT MOVIE_ID 
					FROM PUBLIC.USER_MOVIE_ACCESS uma 
					ORDER BY uma.ACCESS_DATE DESC
					LIMIT 10);


/*22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años*/

SELECT d.DIRECTOR_NAME AS "Director",
count(*) AS "Peliculas antes de cumplir 41 años"
FROM PUBLIC.DIRECTORS d 
JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE (DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE , M.MOVIE_RELEASE_DATE ) < 41)
GROUP BY D.DIRECTOR_ID;


/*23- Indica cuál es la media de duración de las películas de cada director*/


SELECT d.DIRECTOR_NAME AS "Director",
AVG(m.MOVIE_DURATION) AS "Duracion media"
FROM PUBLIC.DIRECTORS d 
JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
GROUP BY D.DIRECTOR_ID;


/*24- Indica cuál es la el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años 
 * por los miembros del plataforma (La “fecha de ejecución” de esta consulta es el 25-01-2019)*/

WITH rango_peliculas AS (
	SELECT m.MOVIE_NAME,
	m.MOVIE_DURATION
	FROM PUBLIC.MOVIES m
	JOIN PUBLIC.USER_MOVIE_ACCESS uma ON m.MOVIE_ID = uma.MOVIE_ID
	WHERE uma.ACCESS_DATE > DATE_SUB('2019-01-25', INTERVAL 2 YEAR))
SELECT rp.MOVIE_NAME AS "Pelicula",
rp.MOVIE_DURATION AS "Duracion"
FROM rango_peliculas rp
WHERE rp.MOVIE_DURATION IN (SELECT min(MOVIE_DURATION) FROM rango_peliculas)
GROUP BY rp.MOVIE_NAME, rp.MOVIE_DURATION;


/*25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título*/

SELECT d.DIRECTOR_NAME AS "Director",
count(*) AS "Numero de peliculas"
FROM PUBLIC.DIRECTORS d 
JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE m.MOVIE_ID IN (SELECT m.MOVIE_ID
						FROM PUBLIC.MOVIES m
						WHERE ((m.MOVIE_RELEASE_DATE BETWEEN '1959-12-31' AND '1990-01-01') AND
								m.MOVIE_NAME LIKE '%The%' OR m.MOVIE_NAME LIKE '%the%'))
GROUP BY d.DIRECTOR_ID;

/*DIFICULTAD: Difícil
26- Lista nombre, nacionalidad y director de todas las películas*/

SELECT m.MOVIE_NAME AS "Pelicula",
n.NATIONALITY_NAME AS "Nacionalidad",
d.DIRECTOR_NAME AS "Director"
FROM PUBLIC.MOVIES m
JOIN PUBLIC.DIRECTORS d ON d.DIRECTOR_ID = m.DIRECTOR_ID 
JOIN PUBLIC.NATIONALITIES n ON n.NATIONALITY_ID = m.NATIONALITY_ID;

/*27- Muestra las películas con los actores que han participado en cada una de ellas*/

SELECT 
m.MOVIE_NAME AS "Pelicula",
GROUP_CONCAT(a.ACTOR_NAME SEPARATOR ', ') AS "Actores"
FROM PUBLIC.MOVIES m 
JOIN PUBLIC.MOVIES_ACTORS ma ON ma.MOVIE_ID = m.MOVIE_ID
JOIN PUBLIC.ACTORS a ON a.ACTOR_ID = ma.ACTOR_ID
GROUP BY m.MOVIE_NAME;


/*28- Indica cual es el nombre del director del que más películas se ha accedido*/

WITH top_peliculas AS (
	SELECT count(*) AS SUMA,
	uma.MOVIE_ID
	FROM PUBLIC.USER_MOVIE_ACCESS uma  
	GROUP BY uma.MOVIE_ID
)
SELECT d.DIRECTOR_NAME AS "Director"
FROM PUBLIC.DIRECTORS d
JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
JOIN top_peliculas rp ON rp.MOVIE_ID = m.MOVIE_ID
WHERE rp.SUMA IN (SELECT MAX(SUMA) FROM top_peliculas);


/*29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado*/


SELECT s.STUDIO_NAME AS "Estudio",
SUM(a.AWARD_WIN ) AS "Numero de premios"
FROM PUBLIC.STUDIOS s 
JOIN PUBLIC.MOVIES m ON m.STUDIO_ID = s.STUDIO_ID
JOIN PUBLIC.AWARDS a ON a.MOVIE_ID = m.MOVIE_ID
GROUP BY s.STUDIO_NAME;  


/*30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)*/

SELECT 
a.ACTOR_NAME AS "Actor",
SUM(aw.AWARD_ALMOST_WIN) AS "Premios nominados"
FROM PUBLIC.ACTORS a 
JOIN PUBLIC.MOVIES_ACTORS ma ON ma.ACTOR_ID = a.ACTOR_ID
JOIN PUBLIC.AWARDS aw ON aw.MOVIE_ID = ma.MOVIE_ID
GROUP BY a.ACTOR_NAME;


/*31- Indica cuantos actores y directores hicieron películas para los estudios no activos*/

SELECT s.STUDIO_NAME AS "Estudio",
COUNT(m.DIRECTOR_ID)+COUNT(ma.ACTOR_ID)
FROM PUBLIC.STUDIOS s 
JOIN PUBLIC.MOVIES m ON m.STUDIO_ID = s.STUDIO_ID
JOIN PUBLIC.MOVIES_ACTORS ma ON ma.MOVIE_ID = m.MOVIE_ID
WHERE (s.STUDIO_ACTIVE = FALSE)
GROUP BY s.STUDIO_NAME;

/*32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido películas
 *  que hayan sido nominadas a más de 150 premios y ganaran menos de 50*/

SELECT u.USER_NAME AS "Miembro",
u.USER_TOWN AS "Ciudad",
u.USER_PHONE AS "Telefono"
FROM PUBLIC.USERS u 
JOIN PUBLIC.USER_MOVIE_ACCESS uma ON uma.USER_ID = u.USER_ID
JOIN PUBLIC.AWARDS a ON a.MOVIE_ID = uma.MOVIE_ID
WHERE a.AWARD_WIN < 50 AND a.AWARD_NOMINATION > 150;


/*33- Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película en el 88)*/

SELECT d.DIRECTOR_NAME AS "Director",
m.MOVIE_NAME AS "Pelicula"
FROM PUBLIC.DIRECTORS d 
JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE (m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE); 

/*34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)*/



UPDATE PUBLIC.DIRECTORS d
SET DIRECTOR_DEAD_DATE = (
    SELECT MAX(m.MOVIE_RELEASE_DATE) + INTERVAL 1 YEAR 
    FROM PUBLIC.MOVIES m
    WHERE m.DIRECTOR_ID = d.DIRECTOR_ID
)
WHERE d.DIRECTOR_DEAD_DATE < (
    SELECT MAX(m.MOVIE_RELEASE_DATE)
    FROM PUBLIC.MOVIES m
    WHERE m.DIRECTOR_ID = d.DIRECTOR_ID
);

/*DIFICULTAD: Berserk mode (enunciados simples, mucha diversión…)
35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película*/

WITH count_genero as(
	SELECT d.DIRECTOR_ID AS director,
	g.GENRE_NAME AS genero,
	count(g.GENRE_ID) AS suma
	FROM PUBLIC.DIRECTORS d 
	JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
	JOIN PUBLIC.GENRES g ON g.GENRE_ID = m.GENRE_ID
	GROUP BY d.DIRECTOR_ID, G.GENRE_ID
)
SELECT d.DIRECTOR_NAME AS "Director",
GROUP_CONCAT(cg.GENERO SEPARATOR ', ')  AS "Genero"
FROM PUBLIC.DIRECTORS d 
JOIN count_genero cg ON cg.DIRECTOR = d.DIRECTOR_ID
WHERE cg.SUMA = (SELECT MAX(SUMA) FROM count_genero WHERE d.DIRECTOR_ID = DIRECTOR) 
GROUP BY d.DIRECTOR_NAME;


/*36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas*/


WITH countNacionalidad AS (
	SELECT 
	s.STUDIO_ID AS studio,
	n.NATIONALITY_NAME AS nacionalidad,
	count(m.NATIONALITY_ID ) AS suma
	FROM PUBLIC.STUDIOS s 
	JOIN PUBLIC.MOVIES m ON m.STUDIO_ID = s.STUDIO_ID
	JOIN PUBLIC.NATIONALITIES n ON n.NATIONALITY_ID = m.NATIONALITY_ID
	GROUP BY s.STUDIO_ID, n.NATIONALITY_ID
)
SELECT
s.STUDIO_NAME AS "Estudio",
GROUP_CONCAT(cn.NACIONALIDAD SEPARATOR ', ') AS "Nacionalidad favorita"
FROM PUBLIC.STUDIOS s 
JOIN countNacionalidad cn ON cn.STUDIO = s.STUDIO_ID 
WHERE cn.SUMA = (SELECT MAX(SUMA) FROM countNacionalidad WHERE STUDIO = s.STUDIO_ID)
GROUP BY s.STUDIO_ID;


/*37- Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos 
 * tengan como último dígito el ID de alguna nacionalidad*/

WITH userNation AS (
	SELECT u.USER_ID AS USER
	FROM PUBLIC.USERS u 
	WHERE  CAST(RIGHT(u.USER_PHONE, 1) AS INTEGER) IN (SELECT n.NATIONALITY_ID FROM PUBLIC.NATIONALITIES n )
), WITH userMovie AS (
	SELECT uma.USER_ID AS USER,
	uma.MOVIE_ID AS MOVIE
	FROM PUBLIC.USER_MOVIE_ACCESS uma 
	WHERE uma.ACCESS_DATE = (SELECT MIN(ACCES_DATE) FROM PUBLIC.USER_MOVIE_ACCESS WHERE uma.USER_ID = USER_ID )
)
SELECT 
FROM PUBLIC.USERS u 
JOIN userNation un ON un.USER = u.USER_ID
JOIN userMovie um OM um.USER = un.USER;


