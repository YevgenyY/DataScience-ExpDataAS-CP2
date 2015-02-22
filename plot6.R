library(ggplot2)
library(plyr)

### Task:
## Compare emissions from motor vehicle sources in Baltimore City with emissions from 
## motor vehicle sources in Los Angeles County, California (fips == "06037"). Which 
## city has seen greater changes over time in motor vehicle emissions?

## Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Get coal related SCC 
idx <- grep("Vehicle", SCC$EI.Sector, ignore.case=TRUE)
SCC_motor <- SCC[idx,]

## Get motor vehicles emissions data
MotorDataBaltimore <- NEI[NEI$SCC %in% SCC_motor$SCC & NEI$fips == "24510",]
MotorDataLA <- NEI[NEI$SCC %in% SCC_motor$SCC & NEI$fips == "06037",]


## Summarize it
motor_emissions_Ba <- ddply(MotorDataBaltimore, ~year, summarize, em_sum=sum(Emissions), county="Baltimore")
motor_emissions_LA <- ddply(MotorDataLA, ~year, summarize, em_sum=sum(Emissions), county="LA")
# join it
result <- rbind(motor_emissions_Ba, motor_emissions_LA)

## Plot the result
qplot(year,  em_sum, data=result, geom="line", color=county, xlab="Year", 
     ylab="PM25 emissions from motor vehicles (tons)", size=1) + 
  ggtitle("Total emissions in LA and Baltimore City from 
          motor vehicles sources (comparision)") +
  geom_point(aes(size=2)) 

## put plot into png
dev.copy(png, file="figure/plot6.png");
dev.off()