library(uuid)
library(httr)


confs=read.csv("confs.csv")
confs$value=as.character(confs$value)
source('crawler/crawler_funs.R')


authToken = auth_in_endomondo(confs,'login@mail.com','pass')

# list the last 85 workouts
#workouts = list_workouts(confs,85)
# list workout beween 2012 and 2017
#w = list_workouts_by_year(confs,2012,2017)

# GET WORKOUT
w_id = 861392806

workout = get_workout_data(confs,w_id)
#resting heart rate
#max heart rate , minumum_hear_rate 