library(uuid)
library(httr)


confs=read.csv("confs.csv")
confs$value=as.character(confs$value)
source('crawler/crawler_funs.R')
source('common/util.R')

authToken = auth_in_endomondo(confs,'login@mail.com','pass')

# list the last 85 workouts
workouts = list_workouts(confs,5)

# list workout beween 2012 and 2017
#w = list_workouts_by_year(confs,2012,2017)

zones = get_hr_zones(85,197)

# GET WORKOUT
w_id = 861392806
w1 = get_workout_data(confs,zones,w_id)

w_id = 862851943
w2 = get_workout_data(confs,zones,w_id)
#resting heart rate
#max heart rate , minumum_hear_rate