library(plyr)

### Task:
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?


## Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Get coal related SCC 
idx <- grep("coal", SCC$EI.Sector, ignore.case=TRUE)
SCC_coal <- SCC[idx,]

## Get coal emissions data
CoalData <- NEI[NEI$SCC %in% SCC_coal$SCC,]

## Summarize it
coal_emissions <- ddply(CoalData, ~year, summarize, sum=sum(Emissions))

## plot the result
plot(coal_emissions$year, coal_emissions$sum, 
     main="Total PM25 emissions in US from coal 
     combustion-related sources", type="b", 
     ylab = "Emissions (tons)", xlab="Year")
polygon(coal_emissions, col = "grey", border = "black")

## put plot into png
dev.copy(png, file="figure/plot4.png");
dev.off()

# Alternative
# Exploration
# Find all coal combustion related rows.
### intersect( grep("Coal", SCC$SCC.Level.Four,ignore.case=TRUE), grep("Combustion", SCC$SCC.Level.Four,ignore.case=TRUE) )
# Did we miss anything on other levels?
### intersect ( grep("Coal", SCC$Short.Name,ignore.case=TRUE), grep("Combustion", SCC$Short.Name,ignore.case=TRUE) )

# Get all coal combustion rows
coal_combust_logical=intersect( grep("Coal", SCC$EI.Sector,ignore.case=TRUE), grep("Comb", SCC$EI.Sector,ignore.case=TRUE) )
Coal_SCC=SCC$SCC[ coal_combust_logical ]

sub_NEI_Coal=NEI[ NEI$SCC %in% Coal_SCC, ]
plot4=tapply(X=sub_NEI_Coal$Emissions,FUN = sum,INDEX=sub_NEI_Coal$year)
plot(names(plot4),plot4,xlab="year",ylab="Total PM2.5 emissions (tons)",type="l",main="PM2.5 from Coal Combustion in United States")