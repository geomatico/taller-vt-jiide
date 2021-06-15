SELECT ST_AsMVT(q, 'mvt_barrios')
FROM (
  SELECT gid, n_barri,
    ST_AsMVTGeom(
      geom,
      ST_TileEnvelope(13, 4145, 3059)
    ) AS geom
  FROM barrios
  WHERE geom && ST_TileEnvelope(13, 4145, 3059)
) AS q;
