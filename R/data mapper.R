# Map the data!
#plot cases by county for each variant

df_list <- list("i.cases", "i.deaths", "a.cases", "a.deaths", "d.cases", "d.deaths", "o.cases", "o.deaths")

for (p in df_list){
  print(p)
  var<-paste("Maps/",p,".png",setp="")
  p<-plot_usmap(
    data = a.data, values = p, include = c("NM"), color = "red"
  ) + 
    scale_fill_continuous(
      low = "white", high = "red", name = "COVID cases/day/100,000 population", label = scales::comma
    ) + 
    labs(title = paste(p)) +
    theme(legend.position = "right")
  png(var)
  print(p)
  rm(p)
}
rm(df_list, var)