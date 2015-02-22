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