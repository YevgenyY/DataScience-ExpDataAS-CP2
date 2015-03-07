library(data.table)

## Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#Get an Index of Vehicle Combustion methods
mobile <- grep("^Mobile", SCC$EI.Sector)

#Subset that data
mobile <- SCC[mobile, "SCC"]

#Pull the data from the SCC table (mobile combustion data) then subset that data and match up the SCC
# values (the ID's match, but may not be unique), then pull the data for Baltimore and LA
data <- subset(NEI, (NEI$SCC %in% mobile) & (NEI$fips == 24510 | NEI$fips == '06037'))
#Convert the fips column to a Factor - important for graphing later
data$fips <- as.factor(data$fips)

#Associate the Fips ID with Appropriate Label
levels(data$fips)[levels(data$fips)=="24510"] <- "Baltimore City, Maryland"
levels(data$fips)[levels(data$fips)=="06037"] <- "Los Angeles County, California"

#Convert to a Data Table
dt <- data.table(data)

#Group data by year, then take the SUM of each year
data <- dt[,list(total = sum(Emissions)), by="fips,year"]

#Reorder the data so we can plot it in the right order
data <-setorder(data, -fips, year)

#Round up the numbers
data$total <- round(data$total, 0)

#Get a ist of years, this eliminates interpolation of the years and just shows us what we want
years <- c(unique(data$year))

message("Generating Plot")

p <- ggplot(data, aes(year, total), geom = "line")
p + geom_point() + theme_bw() + geom_smooth(method = "lm", alpha = 1/3) + facet_wrap( ~ fips, ncol = 2, scales="free_y") + scale_x_continuous(breaks = years) + labs(title="PM2.5 Emissions (Motor Vehicle Sources)", y = "Emissions (tons)", x="")

print(p)

message("Plot Generated")


