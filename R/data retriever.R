# Here we will retrieve our data

#import data
us.counties.2020 <- read.csv("Data/us-counties-2020.csv")
us.counties.2021 <- read.csv("Data/us-counties-2021.csv")
us.counties.2022 <- read.csv("Data/us-counties-2022.csv")
nm.counties.pop <- read_excel("Data/counties-pop.xlsx")

#merge all data
all.data <- rbind(us.counties.2020, us.counties.2021, us.counties.2022)
count(all.data, vars="state")

#get nm data
nm.data <- all.data[(all.data$state=="New Mexico"),]
var <- strsplit(nm.data$geoid, "-")
var <- as.data.frame(var, row.names = NULL, optional = FALSE)
var <- t(var)
var <- data.frame(var)
nm.data$geoid <- as.numeric(var$X2)
names(nm.data)[names(nm.data) == 'geoid'] <- 'fsid'
nm.data$county[nm.data$county=="Doña Ana"] <- "Dona Ana"
count(nm.data, vars="county")

#clean
rm("us.counties.2020", "us.counties.2021", "us.counties.2022", "all.data", "var")