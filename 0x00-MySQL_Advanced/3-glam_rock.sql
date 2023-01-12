-- Lists all bands with Glam rock ranked by their longevity
SELECT m.band_name, IF(m.split != 'NULL', m.split - m.formed, 2020 - m.formed) AS lifespan
FROM metal_bands m
WHERE m.style LIKE '%Glam rock%'
ORDER BY lifespan DESC;
