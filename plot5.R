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


# Alternative
# Find conditions for motor vehicle rows by exploring factors in SCC
motor_vehicle_logical= intersect( grep("Mobile Sources", SCC$SCC.Level.One,ignore.case=TRUE), grep("Vehicle", SCC$SCC.Level.Two,ignore.case=TRUE))
Motor_SCC=SCC$SCC[ motor_vehicle_logical ]
sub_NEI=NEI[  NEI$fips=="24510" & NEI$SCC %in% Motor_SCC, ]

plot5=tapply(X=sub_NEI$Emissions,FUN = sum,INDEX=sub_NEI$year)
plot(names(plot5),plot5,xlab="year",ylab="Total PM2.5 emissions (tons)",type="l",main="PM2.5 from Motor Vehicles in Baltimore")
