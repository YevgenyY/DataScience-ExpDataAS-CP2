library(sqldf)
library(plyr)

### Task: 
## Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system 
## to make a plot answering this question.

## Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Get sum values for fips 24510 (Baltimore City, Maryland)  each 
fips24510 <- sqldf("SELECT year, Emissions from NEI where fips == '24510'")

## Get sum values for each year
te <- ddply(fips24510, ~year, summarize, sum=sum(Emissions))

##plot values
plot(te$year, te$sum, 
     main="Total PM25 emissions from all sources 
     in Baltimore City", type="b", 
     ylab = "Emissions (tons)", xlab="Year")

dev.copy(png, file="figure/plot2.png");
dev.off()

# Alternative
sub_NEI=NEI[ NEI$fips=="24510", ]
plot2=tapply(X=sub_NEI$Emissions,FUN = sum,INDEX=sub_NEI$year)
plot(names(plot2),plot2,xlab="year",ylab="Total PM2.5 emissions (tons)",type="l",main="PM2.5 Baltimore state, Maryland")