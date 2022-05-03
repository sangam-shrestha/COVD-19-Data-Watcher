# here we will analyze the data
class(c.data)

covid_nb<-poly2nb(c.data, queen=TRUE)
covid_w<-nb2listw(covid_nb)
covid_b<-nb2listw(covid_nb, style = "B")
attr(c.data,"data")

covid_case_ols <- glm(fips ~ i.cases + a.cases + d.cases + o.cases, data=c.data)
summary(covid_case_ols)
wald.test(Sigma = vcov(covid_case_ols), b = coef(covid_case_ols), Terms = 2:5)

covid_death_ols <- glm(fips ~ i.deaths + a.deaths + d.deaths + o.deaths, data=c.data)
summary(covid_death_ols)
wald.test(Sigma = vcov(covid_death_ols), b = coef(covid_death_ols), Terms = 2:5)