# Here we will clean our data

#separate out by variant data
#start to 1/2021 initial
#1/2021 to 6/2021 alpha
#6/2021 to 12/21 delta
#12/21 to current omicron

#setup date variable first
nm.data$date <- as.Date(nm.data$date)

#split
initial.data <- nm.data[(nm.data$date < as.Date('2021-1-1')),]
alpha.data <- nm.data[(nm.data$date >= as.Date('2021-1-1') & nm.data$date < as.Date('2021-6-1')),]
delta.data <- nm.data[(nm.data$date >= as.Date('2021-6-1') & nm.data$date < as.Date('2021-12-1')),]
omicron.data <- nm.data[(nm.data$date >= as.Date('2021-12-1')),]

####preanalysis####
#get total time
i.days <- as.numeric(max(initial.data$date)-min(initial.data$date))
a.days <- as.numeric(max(alpha.data$date)-min(alpha.data$date))
d.days <- as.numeric(max(delta.data$date)-min(delta.data$date))
o.days <- as.numeric(max(omicron.data$date)-min(omicron.data$date))

#get total and average cases for initial
case.initial <- setNames(aggregate(cbind(initial.data$cases, initial.data$deaths)~initial.data$county, data=initial.data, FUN=mean, na.rm=TRUE),
                         c("County", "i.Cases", "i.Deaths")) #rename and get totals of cases and deaths
case.initial <- merge(case.initial, nm.counties.pop, by.x="County", by.y="Group.1") #merge population
case.initial$i.Cases <- round(((case.initial$i.Cases/case.initial$Population)*100000)/i.days,4) #average cases per day/100k pop
case.initial$i.Deaths <- round(((case.initial$i.Deaths/case.initial$Population)*100000)/i.days,4) #average cases per day/100k pop
case.initial$Population <- NULL

#get total and average cases for alpha
case.alpha <- setNames(aggregate(cbind(alpha.data$cases, alpha.data$deaths)~alpha.data$county, data=alpha.data, FUN=mean, na.rm=TRUE),
                       c("County", "a.Cases", "a.Deaths")) #rename and get totals of cases and deaths
case.alpha <- merge(case.alpha, nm.counties.pop, by.x="County", by.y="Group.1") #merge population
case.alpha$a.Cases <- round(((case.alpha$a.Cases/case.alpha$Population)*100000)/a.days,4) #average cases per day/100k pop
case.alpha$a.Deaths <- round(((case.alpha$a.Deaths/case.alpha$Population)*100000)/a.days,4) #average cases per day/100k pop
case.alpha$Population <- NULL

#get total and average cases for delta
case.delta <- setNames(aggregate(cbind(delta.data$cases, delta.data$deaths)~delta.data$county, data=delta.data, FUN=mean, na.rm=TRUE),
                       c("County", "d.Cases", "d.Deaths")) #rename and get totals of cases and deaths
case.delta <- merge(case.delta, nm.counties.pop, by.x="County", by.y="Group.1") #merge population
case.delta$d.Cases <- round(((case.delta$d.Cases/case.delta$Population)*100000)/d.days,4) #average cases per day/100k pop
case.delta$d.Deaths <- round(((case.delta$d.Deaths/case.delta$Population)*100000)/d.days,4) #average cases per day/100k pop
case.delta$Population <- NULL

#get total and average cases for omicron
case.omicron <- setNames(aggregate(cbind(omicron.data$cases, omicron.data$deaths)~omicron.data$county, data=omicron.data, FUN=mean, na.rm=TRUE),
                         c("County", "o.Cases", "o.Deaths")) #rename and get totals of cases and deaths
case.omicron <- merge(case.omicron, nm.counties.pop, by.x="County", by.y="Group.1") #merge population
case.omicron$o.Cases <- round(((case.omicron$o.Cases/case.omicron$Population)*100000)/o.days,4) #average cases per day/100k pop
case.omicron$o.Deaths <- round(((case.omicron$o.Deaths/case.omicron$Population)*100000)/o.days,4) #average cases per day/100k pop
case.omicron$Population <- NULL

a.data <- aggregate(nm.data$fsid, list(nm.data$county), FUN=mean)
names(a.data)[names(a.data) == 'x'] <- 'fips'
names(a.data)[names(a.data) == 'Group.1'] <- 'County'
df_list <- list(a.data, case.initial, case.alpha, case.delta, case.omicron)
a.data <- Reduce(function(x,y) merge (x,y, by.x="County", by.y="County", all=TRUE), df_list)
a.data <- setNames(a.data, c("County", "fips",
                             "i-cases", "i-deaths",
                             "a-cases", "a-deaths",
                             "d-cases", "d-deaths",
                             "o-cases", "o-deaths"))
a.data <- data.frame(a.data)
a.data <- na.omit(a.data)

#clean up
rm("alpha.data", "case.alpha", "case.delta", "case.initial", "case.omicron", "delta.data", "initial.data", "nm.counties.pop", "omicron.data", "df_list")

#setup fips in a.data to match with the NM shapefile 
a.data$fip <- a.data$fips
a.data$fip <- as.character(sprintf("%03d",a.data$fip-35000))

#merge the shapefile with data frame
c.data <- merge(nm, a.data, by.x="COUNTYFP", by.y="fip")
rm("nm")