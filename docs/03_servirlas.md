# Servicio básico de teselas vectoriales

Un servicio de teselas *a la google* o de tipo "XYZ" consiste en una URL donde se sustituyen los valores de zoom, fila y
columna siguiendo una plantilla, como en:

https://tileserver.geomatico.es/data/building_latest/{z}/{x}/{y}.pbf

Se supone una proyección determinada, `EPSG:3857`, y un esquema de teselado determinado. Nada se sabe sobre el rango
de zooms o el ámbito geográfico de los datos (BBXOX), su atribución, o su contenido. Por ello mapbox ideó un fichero
de metadatos para publicar esta información de forma estándar: la especificación *TileJSON*.


## Especificación *TileJSON*

Este fichero de "metadatos" vendría a ser algo entre un GetCapabilities de mínimos, y un DescribeFeatureType:

```json
{
  "tilejson": "2.0.0",
  "name": "buildingparts",
  "tiles":["https://tileserver.geomatico.es/data/building_latest/{z}/{x}/{y}.pbf"],
  "minzoom": 10,
  "maxzoom": 15,
  "bounds": [-18.1604, 27.634874, 4.317627, 43.794889],
  "type": "overlay",
  "attribution": "Catastro",
  "vector_layers": [
    {
      "id": "buildingparts",
      "minzoom": 10,
      "maxzoom": 15,
      "fields": {
        "area": "Number",
        "coc": "String",
        "cu": "String",
        "floors": "Number",
        "nbu": "Number",
        "ndw": "Number",
        "parcel": "String",
        "year": "String"
      }
    }
  ]
}
```


## Caso práctico: Explorando una instancia de Tileserver GL

[TileServer GL](http://tileserver.org/) es un servidor de mapas de código abierto creado para teselas vectoriales, y
capaz de renderizar en teselas raster con MapBox GL Native engine en el lado del servidor.

Proporciona mapas para aplicaciones web y móviles. Es compatibles con Mapbox GL JS, Android SDK, iOS SDK, Leaflet,
OpenLayers, HighDPI/Retina, SIG a través de WMTS, etc.

Si se quiere servir teselas raster lo mejor es utilizar la versión de Docker ya que son necesarias algunas librerías
nativas que pueden variar dependiendo de la plataforma, estas librerías sirven para renderizar las teselas vectoriales
en teselas raster. Si únicamente se quiere servir teselas vectoriales se puede utilizar el TileServer GL Light,
que no tiene ninguna dependencia nativa ya que está desarrollado en javascript.


1. Abrir https://tileserver.geomatico.es en un navegador

2. Explorar la sección "DATA":

    * Documento `TileJSON`
    * Inspect

3. Explorar la sección "STYLES":

    * Documento `TileJSON`. No siempre. Diferencias con el anterior.
    * Viewers: Vector y Raster. Similitudes y diferencias.
    * Servicio WMTS. Sólo para imagen.
    * Estructura de un documento GL Style:
        * Sprites  
        * Glyphs (y el endpoint oculto: https://tileserver.geomatico.es/fonts.json)
        * Sources
        * Layers
