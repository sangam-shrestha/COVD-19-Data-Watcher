# Map the data!
#plot cases by county for each variant
jpeg(file="Maps/i-cases.jpeg")
plot_usmap( #initial cases
  data = a.data, values = "i.cases", include = c("NM"), color = "red"
) + 
  scale_fill_continuous(
    low = "white", high = "red", name = "COVID cases/day/100,000 population", label = scales::comma
  ) + 
  labs(title = "Initial COVID-19 Cases") +
  theme(legend.position = "right")
dev.off()