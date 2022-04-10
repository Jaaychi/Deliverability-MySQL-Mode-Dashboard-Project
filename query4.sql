WITH Master AS (SELECT
  s.id AS id,
  s.address_id AS address_id,
  a.country AS address_country,
  d.tracker_id AS tracking_id,
  t.carrier AS tracking_carrier,
  t.datetime AS tracking_datetime,
  s.datetime AS shipping_datetime,
  d.status AS details_status,
  d.datetime AS details_date_time
FROM
  shipments s
  LEFT JOIN trackers t ON s.id = t.shipment_id
  LEFT JOIN details d ON t.id = d.tracker_id
  LEFT JOIN address a ON s.address_id = a.id 
  )
  
, CTE1 AS (SELECT
  *
FROM Master
WHERE tracking_carrier = 'carrier 1'
-- AND address_country = 'US'
AND details_status =  'arrived_at_destination'
)

SELECT 
address_country,
ROUND(AVG(DATEDIFF(details_date_time, tracking_datetime)), 2) AS avg_transit_time
FROM CTE1
GROUP BY 1
ORDER BY avg_transit_time;
