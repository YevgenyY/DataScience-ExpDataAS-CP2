library(plyr)

### Task:
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

## Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Get coal related SCC 
idx <- grep("Vehicle", SCC$EI.Sector, ignore.case=TRUE)
SCC_motor <- SCC[idx,]

## Get motor vehicles emissions data
MotorData <- NEI[NEI$SCC %in% SCC_motor$SCC & NEI$fips == "24510",]


## Summarize it
motor_emissions <- ddply(MotorData, ~year, summarize, sum=sum(Emissions))

## plot the result
plot(motor_emissions$year, motor_emissions$sum, 
     main="Total PM25 emissions in US from 
     motor vehicles sources", type="b", 
     ylab = "Emissions (tons)", xlab="Year")
polygon(coal_emissions, col = "grey", border = "black")

## put plot into png
dev.copy(png, file="figure/plot5.png");
dev.off()