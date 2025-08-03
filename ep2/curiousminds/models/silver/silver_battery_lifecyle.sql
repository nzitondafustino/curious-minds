SELECT 
    *
FROM {{ source("battery", "battery_lifecyle") }}