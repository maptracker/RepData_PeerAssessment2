### Storm Data Aliases

## The structure below is a desperate attempt to normalize *some* of
## the major event types in the storm data file. This list was
## generated organically, by finding the top N events, looking for
## apparent duplicate event types, and collapsing them into a single
## "high level" event.

## There are other ways to organize these data; For example, I could
## have put "Cold and snow" under "Snow" instead of "Cold", or I could
## have kept Hurricanes and Tropical Storms separate, rather than
## putting both under "Hurricane / TS"

aliases <- list(
    "Flooding" = "Flood",
    "Coastal flood" = "Flood",
    "Coastal flooding" = "Flood",
    "Flash flood" = "Flood",
    "Flash flood/flood" = "Flood",
    "Flash flooding" = "Flood",
    "Flash flooding/flood" = "Flood",
    "Flood/flash flood" = "Flood",
    "River flood" = "Flood",
    "Urban flooding" = "Flood",
    "Urban/sml stream fld" = "Flood",

    "Cold" = "Cold",
    "Cold/wind chill" = "Cold",
    "Extreme cold/wind chill" = "Cold",
    "Extreme cold" = "Cold",
    "Frost/freeze" = "Cold",
    "Extreme windchill" = "Cold",
    "Cold and snow" = "Cold",

    "Winter weather" = "Winter weather",
    "Blizzard" = "Winter weather",
    "Winter storm" = "Winter weather",
    "Blizzard" = "Winter weather",
    "Winter weather/mix" = "Winter weather",
    "Winter weather mix" = "Winter weather",
    "Winter storms" = "Winter weather",
    "Wintry mix" = "Winter weather",

    "Snow" = "Snow",
    "Heavy snow" = "Snow",
    "Lake-effect snow" = "Snow",
    "Light snow" = "Snow",
    "Snow/high winds" = "Snow",
    "Excessive snow" = "Snow",

    "Ice" = "Ice",
    "Ice storm" = "Ice",
    "Ice on road" = "Ice",
    "Freeze" = "Ice",
    "Freezing rain" = "Ice",
    "Frost" = "Ice",
    "Glaze" = "Ice",
    "Hail" = "Ice",
    "Small hail" = "Ice",
    "Tstm wind/hail" = "Ice",

    "Fire" = "Fire",
    "Wild/forest fire" = "Fire",
    "Wildfire" = "Fire",
    "Forest fires" = "Fire",
    "Wildfires" = "Fire",
    "Wild fires" = "Fire",

    "Heat" = "Heat",
    "Excessive heat" = "Heat",
    "Extreme heat" = "Heat",
    "Heat wave" = "Heat",
    "Record/excessive heat" = "Heat",
    "Record heat" = "Heat",
    "Unseasonably warm" = "Heat",
    "Unseasonably warm and dry" = "Heat",


    "Hurricane" = "Hurricane / TS",
    "Tropical storm" = "Hurricane / TS",
    "Hurricane/typhoon" = "Hurricane / TS",
    "Tropical storm gordon" = "Hurricane / TS",
    "Hurricane felix" = "Hurricane / TS",

    "Wind" = "Wind",
    "Strong winds" = "Wind",
    "Thunderstorm winds" = "Wind",
    "Tstm wind" = "Wind",
    "High winds" = "Wind",
    "Strong wind" = "Wind",
    "Thunderstorm wind" = "Wind",
    "High wind" = "Wind",
    "Dry microburst" = "Wind",
    "Dust devil" = "Wind",
    "Dust storm/high winds" = "Wind",
    "High winds/cold" = "Wind",
    "Thunderstorm windss" = "Wind",

    "Fog" = "Fog",
    "Dense fog" = "Fog",
    "Freezing fog" = "Fog",

    "Ocean Current" = "Ocean Current",
    "Heavy surf/high surf" = "Ocean Current",
    "Storm surge/tide" = "Ocean Current",
    "Rip current" = "Ocean Current",
    "High surf" = "Ocean Current",
    "Rip currents" = "Ocean Current",
    "Storm surge" = "Ocean Current",
    "Astronomical high tide" = "Ocean Current",
    "Astronomical low tide" = "Ocean Current",
    "Hazardous surf" = "Ocean Current",
    "Heavy surf" = "Ocean Current",

    "Tornado" = "Tornado",
    "Tornadoes, tstm wind, hail" = "Tornado",
    "Waterspout" = "Tornado",
    "Waterspout/tornado" = "Tornado",

    "Drought" = "Drought",
    "Dust storm" = "Drought",
    
    "Rain" = "Rain",
    "Heavy rain" = "Rain"
    )


## Reverse lookup
aliasGroups <- list()
for (raw in names(aliases)) {
    norm <- aliases[[raw]]
    aliasGroups[[norm]] <- c(aliasGroups[[norm]], raw)
}
