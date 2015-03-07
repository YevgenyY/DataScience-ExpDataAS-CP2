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


# Alternative #1
# Preload
motor_vehicle_logical= grep("Vehicle", SCC$SCC.Level.Two,ignore.case=TRUE)
Motor_SCC=SCC$SCC[ motor_vehicle_logical ]
Baltimore_NEI=NEI[  NEI$fips=="24510" & NEI$SCC %in% Motor_SCC, ]
LA_NEI=NEI[  NEI$fips=="06037" & NEI$SCC %in% Motor_SCC, ]

plot6=tapply(X=Baltimore_NEI$Emissions,FUN = sum,INDEX=Baltimore_NEI$year)
plot6b=tapply(X=LA_NEI$Emissions,FUN = sum,INDEX=LA_NEI$year)
diff1=plot6-plot6[1]
diff2=plot6b-plot6b[1]

plot(names(diff1),diff1,ylim=range(-300:1500),col="red",xlab="year",ylab="Change in Total PM2.5 emissions (tons)",type="l",main="Difference in Motor Vehicles PM2.5 emissions from 1999")
points(names(diff2),diff2,type='l',col="blue")
legend("topright", lwd=1, col=c("red","blue"), legend=c("Baltimore","Los Angeles"))
abline(0,0)

