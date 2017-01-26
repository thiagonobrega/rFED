library(ggplot2)
library(scales)
source('analytics/util.R')
source('common/util.R')


get_sport_name <- function(id){
  sports=read.csv("sports.csv")
  sports$key=as.integer(sports$key)
  sports$value=as.character(sports$value)
  r <- sports$value[sports$key == id]
  r
}


## get color schema
get_colors <- function(){
  colors = c("death"="red","max"="#CC0099","hardcore"="orangered",
             "cardio"="yellow","fatburn"="green","recovery"="#CCCC00",
             "rest"="lightskyblue")
  colors
}

###
### Plot Heart Rate in Workout
###
plot_hr_in_workout<-function(rest_hr,max_hr,workout_data){
  start = workout_data[,1][1]
  
  ggplot(data=workout_data) + 
    geom_line( aes(x=( (start - date)/60 ), y=hr),size=1 ) +
    labs(x="Time (minutes)") + labs(y="heart rate (bpm)")
  
}

###
### plot heart zones during workout
###
#TODO: INVERTED X AXIS?
plot_hr_zones_in_workout<-function(rest_hr,max_hr,workout_info,workout_data){
  start = workout_info$start_time
  delta = as.integer(workout_data[,1][1] - workout_data[,1][nrow(workout_data)])+5
  ye = max(workout_data$hr)+10
  zones = get_hr_zones(rest_hr,max_hr)
  
  colors <- get_colors()
  
  tit <- paste( paste("Sport: ", get_sport_name(workout_info$sport),sep = ""),
                workout_info$start_time,sep = "\n")
                
  ggplot() + 
    geom_line(data=workout_data,aes(x=( (date-start)/60 ), y=hr),size=1) +
    geom_rect(data=zones, aes(xmin=0,xmax=delta,ymin=hrl,ymax=hrh,fill=name), alpha=0.35) +
    scale_color_manual(values=colors,name= "Heart Zone", guide = guide_legend(reverse = TRUE) ) +
    labs(x="Time (minutes)") + labs(y="heart rate (bpm)") +
    ggtitle(tit)
}


###
### Plot how much time the attlete pass in wich zone
###
plot_histogram_workout_zones<-function(rest_hr,max_hr,workout_info,workout_data){
  zones = get_hr_zones(rest_hr,max_hr)
  
  colors <- get_colors()
  tit <- paste( paste("Sport: ", get_sport_name(workout_info$sport),sep = ""),
                workout_info$start_time,sep = "\n")
    
  ggplot(workout_data, aes(as.factor(hrb),fill=hrb)) + 
    geom_bar(aes(y = (..count..)/sum(..count..))) +
    geom_text(aes(y = ((..count..)/sum(..count..)), 
                  label = scales::percent((..count..)/sum(..count..))), stat = "count", 
                  vjust = -0.25) +
    scale_y_continuous(labels=percent_format()) +
    scale_fill_manual(values=colors,name= "Heart Zone", guide = guide_legend(reverse = TRUE) ) +
    labs(x="") + labs(y="percentage") + 
    ggtitle(tit)
}