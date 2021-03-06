# Creación y almacenaje de teselas vectoriales

Generar las teselas vectoriales al vuelo es lento, y se recomienda, en la medida de lo posible, tenerlas cacheadas.

Almacenar una pirámide de teselas en una estructura de directorios, cuando se tiene una cantidad importante de datos, es
también ineficiente, por lo que Mapbox creó el formato mbtiles.

## Especificación *`.mbtiles`*

Mbtiles contiene toda una pirámide de teselas en un solo fichero, que es una BDD sqlite.

Pirámide de teselas guardada en una BDD SQLite, con un esquema determinado. Tablas principales:

### Vista `tiles`

| zoom_level | tile_column | tile_row | tile_data |
|---|---|---|---|
| {z} | {x} | {y} | {BLOB} |

### Tabla `metadata`

| name | value |
|---|---|
| `format` | "*pbf*" |
| `attribution` | "(c) OpenStreetMap..." |
| `minZoom` | 0 |
| `maxZoom` | 14 |
| `BBOX` | -180,-85.06,180,85.06 |
| `json` | (capas contenidas en cada tesela, y su "feature type") |

!!! tip 
    Un fichero mbtiles puede contener teselas de cualquier tipo, también de formato imagen. Esto no se deduce de la extensión del fichero.

!!! warning
    Mbtiles no es equivalente a geopackage. Aunque ambos son esencialmente una BDD SQLite, guardan los datos en una estructura distinta y tienen diferente propósito.

## Tippecanoe

[Tippecanoe](https://github.com/mapbox/tippecanoe) es la herramienta que permite crear teselas vectoriales de
grandes colecciones de elementos en formato GeoJSON.

El objetivo de Tippecanoe es permitir una visión de sus datos independiente de la escala, de modo que en cualquier
nivel, desde el mundo entero hasta un solo edificio, se pueda apreciar la densidad y la textura de los datos, en
lugar de una simplificación geométrica, que puede eliminar vértices importantes que cambien la apariencia de los datos
en su versión simplificada.

Algunos ejemplos:

* Teniendo todo el callejero de OpenStreetMap, la vista general devolverá algo que se parece a
"Todas las calles" en lugar de algo que parece un atlas de carreteras interestatal.
* Teniendo todas las plantas de edificios de una ciudad, en la vista general donde los edificios individuales ya no
sean perceptibles, aún deberías poder ver la extensión y variedad del desarrollo en cada vecindario,
no solo para los edificios más voluminosos.

Esto hace que la calidad de los resultados de Tippecanoe sea muy superior a otras alternativas, que utilizan algoritmos
de simplificación más convencionales, motivo por el cual lo recomendamos en este taller.

Además, es sorprendentemente rápido procesando los datos.


## Caso práctico: generación de una pirámide de teselas vectoriales

1. Instalar [mapbox/tippecanoe](https://github.com/mapbox/tippecanoe). Esto es muy sencillo en un Mac con brew, algo
    menos sencillo en Ubuntu (hay que asegurarse de tener todas las dependencias y compilar), y no está definido cómo
    compilarlo en Windows.
    
    !!! tip
        También se puede usar alguna de las [imágenes docker](https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=tippecanoe&starCount=0) disponibles.

2. A partir del fichero `buildings.geojson` en:

    https://github.com/geomatico/taller-vt-jiide/tree/master/ejercicios/02
 
    Ejecutar el comando de tippecanoe:
    
        tippecanoe -L buildingpart:buildingpart.geojson -Z 12 -z 16 -n "Catastro Building Parts" -o buildingpart.mbtiles -A "Catastro"
        
    Esto generará el fichero `buildings.mbtiles`.

3. Abrir el fichero resultante con un administrador de bases de datos SQLite, y se podrá observar la estructura de datos mencionada.

4. QGIS tiene un plugin llamado "Vector Tiles Reader" para poder visualizar los datos. No es muy rápido ni estable, pero
puede servir para inspeccionar los datos.
