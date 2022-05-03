# Map the data!
#plot cases by county for each variant

df_list <- list("i.cases", "i.deaths", "a.cases", "a.deaths", "d.cases", "d.deaths", "o.cases", "o.deaths")
dev.off()
plot.new()
for (p in df_list){
  print(p)
  var<-paste("Maps/",p,".png",setp="")
  p<-plot_usmap(
    data = a.data, values = p, include = c("NM")) + 
    scale_fill_continuous(
      low = "white", high = "dark red", 
      name = "COVID cases/day/100,000 population", 
      label = scales::comma) + 
    theme(legend.position = "right")
  png(var, width = 1000, height = 800)
  print(p)
  rm(p)
  dev.off()
  plot.new()
}
rm(df_list, var)