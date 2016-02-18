


### Boilerplate from @ronammar :

## Clear the current session, to avoid errors from persisting data structures
rm(list=ls())
## Free up memory by forcing garbage collection
invisible(gc())
## Pretty printing in knitr
## Not available in standard repos - https://github.com/yihui/printr
library(printr)
## Manually set the seed to an arbitrary number for consistency in reports
set.seed(1234)
## Do not convert character vectors to factors unless explicitly indicated
options(stringsAsFactors=FALSE)
startTime <- Sys.time()

library("ggplot2")
library("dplyr")
library("reshape2")



simpleFile <- "StormDataSimple.tsv"

if (!file.exists(simpleFile)) {
    message("Generating simplified data file...")
    ## Much of the primary file is not of interest to us. Simplify the
    ## file to just the fields we will use
    sourceFile <- "repdata_data_StormData.csv.bz2"
    if (!file.exists(sourceFile)) {
        stop("Download the source data from https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2")
    }
    full <- read.csv(sourceFile)
    ## Filter the results to just the 50 "standard" states:
    validState <- full$STATE %in% state.abb
    ## That reduces 902k observations to 883k
    state50 <- full[ validState, ]
    days <- format(strptime(state50$BGN_DATE, "%m/%d/%Y %H:%M:%S"), "%Y-%m-%d")
    simp <- data.frame(Date     = days,
                       RawEvent = state50$EVTYPE,
                       Deaths   = state50$FATALITIES,
                       Injuries = state50$INJURIES,
                       Property = state50$PROPDMG,
                       Crop     = state50$CROPDMG,
                       State    = state50$STATE)
    write.table( simp, file = simpleFile, sep = "\t", row.names = FALSE,
                quote = FALSE)
    ## Clean up memory - I think?
    full    <- NULL
    days    <- NULL
    state50 <- NULL
    simp    <- NULL
    invisible(gc())
}

colCls <- c(rep("character", 2), rep("numeric", 4), "character")
data <- read.table(simpleFile, header = TRUE, sep = "\t",
                   colClasses = colCls )
data$Date  <- strptime(data$Date, "%Y-%m-%d")
data$Year  <- as.integer(format(data$Date, "%Y"))

eventRaw   <- unique(data$RawEvent)
## Wow. Event is REALLY non-standard:
## grep("cold", eventRaw, ignore.case = T, value = T)
## If I actually cared about these data, I'd invest time in more carefully
## normalizing them. Instead, I'll half-heartedly normalize

## ARG. The top categories have duplicates. It's making messy plots
## Manual event mapping to remove some of the whacky duplication. I
## built this by selecting more top events than I wanted, and
## repeatedly collapsing duplicates until I had a relatively constant
## list.

aliases <- list("Coastal flood" = "Flooding",
                "Cold/wind chill" = "Cold",
                "Extreme cold/wind chill" = "Cold",
                "Flash flood" = "Flooding",
                "Frost/freeze" = "Cold",
                "Excessive heat" = "Heat",
                "Blizzard" = "Winter weather",
                "Heavy snow" = "Snow",
                "Hurricane/typhoon" = "Hurricane",
                "Ice storm" = "Ice",
                "Lake-effect snow" = "Snow",
                "Strong winds" = "Wind",
                "Thunderstorm winds" = "Wind",
                "Tstm wind" = "Wind",
                "Winter storm" = "Winter weather",
                "Blizzard" = "Winter weather",
                "Dense fog" = "Fog",
                "Extreme cold" = "Cold",
                "Heavy surf/high surf" = "Ocean Current",
                "High winds" = "Wind",
                "Small hail" = "Hail",
                "Storm surge/tide" = "Ocean Current",
                "Strong wind" = "Wind",
                "Wild/forest fire" = "Fire",
                "Wildfire" = "Fire",
                "Winter weather/mix" = "Winter weather",
                "Rip current" = "Ocean Current",
                "High surf" = "Ocean Current",
                "Rip currents" = "Ocean Current",
                "Storm surge" = "Ocean Current",
                "Thunderstorm wind" = "Wind",
                "Tstm wind/hail" = "Hail",
                "Dust storm" = "Drought",
                "Astronomical high tide" = "Ocean Current",
                "Astronomical low tide" = "Ocean Current",
                "Extreme windchill" = "Cold",
                "Freezing fog" = "Fog",
                "Hazardous surf" = "Ocean Current",
                "Heavy surf" = "Ocean Current",
                "High wind" = "Wind",
                "Ice on road" = "Ice",
                "Light snow" = "Snow",
                "Winter weather mix" = "Winter weather")

normalEvent <- list()
stemmedKeys <- list()
for (e in eventRaw) {
    ## Nice-case the events. Lowercase and remove non alphanumeric from end:
    norm <- gsub("[^a-z0-9]$", tolower(e), rep = "")
    ## Wow. So many spaces
    norm <- gsub("^ +", norm, rep = "")
    norm <- gsub(" +$", norm, rep = "")
    norm <- gsub(" +", norm, rep = " ")
    ## Uppercase first letter:
    substr(norm, 1, 1) <- toupper(substr(norm, 1, 1))
    ## Map over aliases
    alias <- aliases[[norm]]
    if (!is.null(alias)) norm <- alias
    ## Deal (crudely) with plurals:
    key <- gsub("i?e?s+$", norm, rep = "")
    ## "Costal flooding" -> "Costal flood"
    key <- gsub("ing$", key, rep = "")
    if (key == "") key <- "Unknown"
    ## Keep the first instance of a key as the value to use:
    if (is.null(stemmedKeys[[ key ]])) stemmedKeys[ key ] <- norm
    normalEvent[ e ] <- stemmedKeys[[ key ]]
    ## SOOO much more could be done ...
}

data$Event <- vapply(data$RawEvent, function(x) { normalEvent[[x]] }, "")
data$Event <- as.factor( data$Event)
allEvents  <- sort(levels(data$Event))
data$State <- as.factor( data$State )

melted <- melt(data, id = c("Year", "Event"), 
               measure.vars = c("Deaths", "Injuries", "Property", "Crop"))

annualEvents <- aggregate(value ~ Year + Event + variable,
                          melted, FUN = sum)

## Let's find the major events in the last decade
maxYear <- max(annualEvents$Year)
lookBack <- 40
mostRecent <- annualEvents[ annualEvents$Year > maxYear - lookBack, ]
recentSum  <- aggregate( value ~ Event + variable, mostRecent, FUN = sum,
                     na.rm = TRUE)
## Eh. Not sure this is an efficient way to go about this...
recentWide <- reshape(recentSum, idvar = "Event", direction = "wide",
                   timevar = "variable")
numEvents <- nrow(recentWide)
recentWide <- mutate(recentWide,
                   rd = numEvents - rank(recentWide$value.Deaths),
                   ri = numEvents - rank(recentWide$value.Injuries),
                   rp = numEvents - rank(recentWide$value.Property),
                   rc = numEvents - rank(recentWide$value.Crop))

topNum <- 3

topEvents <- with( recentWide, {
    recentWide[ rd < topNum | ri < topNum | rp < topNum | rc < topNum, ]
})

topNames <- topEvents$Event

majorEvents <- annualEvents[ annualEvents$Event %in% topNames, ]


ggplot(majorEvents) +
    geom_line( aes(x = Year, y = value, color = Event ) ) +
    facet_grid( variable ~ ., scales = "free_y" )

