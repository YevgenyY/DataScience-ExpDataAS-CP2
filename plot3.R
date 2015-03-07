library(sqldf)
library(plyr)
library(ggplot2)

### Task: 
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
## variable, which of these four sources have seen decreases in emissions from 1999–2008 
## for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the 
## ggplot2 plotting system to make a plot answer this question.

## Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Get sum values for fips 24510 (Baltimore City, Maryland)  each 
fips24510 <- sqldf("SELECT year, Emissions, type from NEI where fips == '24510'")

## Get values for each type 
sum_24510_type <- ddply(fips24510, .(year, type), summarize, sum_em=sum(Emissions))

# plot 1
qplot(year, sum_em, data = sum_24510_type, facets = .~type,
      main = "Baltimore City Total PM2.5 Emissions by Type")
#qplot(year, sum_em, data=sum_24510_type, color=type, geom=c("point", "smooth"), method="lm")

#plot 2
g_plot <- ggplot(sum_24510_type, aes(year, sum_em)) + xlab("Year") + ylab("Emissions")
g_plot + geom_point(aes(color=type, size=2)) + geom_smooth(aes(color=type, size=2), method="lm") +
  ggtitle("Four PM25 emissions sources in Baltimore city (1999-2008)")

dev.copy(png, file="figure/plot3.png");
dev.off()