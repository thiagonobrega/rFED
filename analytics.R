library(uuid)
library(httr)

source('analytics/workout_basic.R')
source('crawler/crawler_funs.R')
source('common/util.R')
source('common/plot_util.R')

#confs
confs=read.csv("confs.csv")
confs$value=as.character(confs$value)

#get authtoken
authToken = auth_in_endomondo(confs,'login@mail.com','pass')

#get last 5 workouts
workouts = list_workouts(confs,5)

#get heart zones
zones = get_hr_zones(85,197)

#get last workout data
w1 <- get_workout_data(confs,zones,workouts$id[[5]])
#plot workou w1 data
plot_hr_zones_in_workout(90,197,workouts[5,],w1)
plot_histogram_workout_zones(90,197,workouts[5,],w1)

# get previous workout
a1 <- plot_histogram_workout_zones(90,197,workouts[5,],w1)

w2 <- get_workout_data(confs,zones,workouts$id[[4]])
a2 <- plot_histogram_workout_zones(90,197,workouts[4,],w2)

multiplot(a1,a2,cols=1)