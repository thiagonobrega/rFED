
scale_hr_color <- function(name,zones){
  
  deah=zones[zones$name=='death',]
  
  colors = c('red','#CC0099','orangered','yellow','green','#CCCC00','lightskyblue')
  i = 1
  v = paste("(0,",paste(deah$hrl,"]",sep="") ,sep="")
  lv <- c(v = colors[i] )
  ll <- c("death")
  
  for (zn in c('max','hardcore','cardio','fatburn','recovery','rest')){
    z=zones[zones$name==zn,]
    i = i+1
    a=paste("(",z$hrh,sep="")
    b=paste(z$hrl,"]",sep="")
    v = paste(a,b,sep=",")
    lv <- c(lv,c( v = colors[i] ) )
    ll <- c(ll,c(as.character(z$name)))
  }
  
  z=scale_color_manual(name = name, values = lv, labels = ll)
  z=scale_color_manual(values=c('red','#CC0099','orangered','yellow','green','#CCCC00','lightskyblue'))
  z
}


get_zone <- function(zones,ihr){
  r <- 'rest'
  for (zn in c('max','hardcore','cardio','fatburn','recovery','rest')){
    z=zones[zones$name==zn,]
    if ( (z$hrl < ihr) && (ihr <= z$hrh) ){
      r <- zn
    }
  }
  r
}