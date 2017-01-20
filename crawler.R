library(uuid)
library(httr)


confs=read.csv("confs.csv")
confs$value=as.character(confs$value)
source('crawler/crawler_funs.R')


authToken = auth_in_endomondo(confs,'login@mail.com','pass')

workouts = list_workouts(confs,85)
w = list_workouts_by_year(confs,2012,2017)
# GET WORKOUT