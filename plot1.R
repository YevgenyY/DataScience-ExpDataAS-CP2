library(plyr)

### Task: 
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from 
## all sources for each of the years 1999, 2002, 2005, and 2008.

## Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Get sum values for each year
total_emissions <- ddply(NEI, ~year, summarize, sum=sum(Emissions))

## plot values
# remove scientific notation at Y-axis
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

# plot values
plot(total_emissions$year, total_emissions$sum, 
    main="Total PM25 emissions from all sources", type="b", 
    ylab = "Emissions (tons)", xlab="Year")

dev.copy(png, file="figure/plot1.png");
dev.off()

### Alternative
plot1=tapply(X=NEI$Emissions,FUN = sum,INDEX=NEI$year)
plot(names(plot1),plot1,xlab="year",ylab="Total PM2.5 emissions (tons)",type="l",main="PM2.5 Data United States")