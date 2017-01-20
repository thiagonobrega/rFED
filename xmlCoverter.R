library(XML)
setwd("C:/Users/Thiago/Dropbox/workspace/R/endomodo/")

xmldoc <- xmlParse("dados.tcx")
nodes <- getNodeSet(xmldoc, "//ns:Trackpoint", "ns")
mydf  <- plyr::ldply(nodes, as.data.frame(xmlToList))

mydf <- setNames(mydf, c('time', 'lat', 'long', 'distance', 'heartrate', 'altitude'))


mydf$time <- as.POSIXct(as.character(mydf$time),format = '%Y-%m-%dT%H:%M:%SZ' )
mydf$lat <- as.numeric(as.character(mydf$lat))
mydf$long <- as.numeric(as.character(mydf$long))
mydf$distance <- as.numeric(as.character(mydf$distance))
mydf$heartrate <- as.numeric(as.character(mydf$heartrate))
mydf$altitude <- as.numeric(as.character(mydf$altitude))

library(ggplot2)

ggplot(data=mydf) + 
  geom_point(
    mapping=aes(x=distance, y=heartrate), 
    size=1, shape=21
   ) + 
  geom_line(
    aes(x=distance, y=heartrate),size=1
   ) +
  labs(x="") + labs(y="Custo")