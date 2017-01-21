library(uuid)
library(httr)
library(base)

source('crawler/util.R')

###
### Auth in endmondo
###
auth_in_endomondo <- function(confs,login,pass,acao='pair'){
  
  auth_paramns <- function(login,pass,acao='pair'){
    list(os = "Windows",model = "R 3.1.4" , osVersion = "Windows 10", 
         vendor = "github/thiagonobrega", appVariant = "R endomondo web crawler",
         country = "BR" , v = "2.4", appVersion = "0.1", deviceId = UUIDgenerate(),
         action='pair', email=login , password = pass
    )
  }
  
  if ( confs[confs$key == 'authToken', ]$value != '0' ){
    authToken = confs[confs$key == 'authToken', ]$value
  } else {
    URL_AUTHENTICATE = confs[confs$key == 'URL_AUTHENTICATE', ]$value
    request = GET(URL_AUTHENTICATE,query=auth_paramns())
    
    
    lines <- strsplit(content(request),"\n")[[1]]
    
    if (lines[1] != "OK"){
      print("ERROR: Could not authenticate with Endomondo, Expected 'OK', got" + lines[1])
    }
    
    
    for (line in lines){
      if ( startsWith(line,"authToken")  ){
        authToken = strsplit(line,"=")[[1]][2]
      }
    }
  }
  
  authToken
}

###
### List workouts
###
## TODO: GET BY MONTH
list_workouts <- function(confs,results=40,before=0){
  
  query_workouts <- function(r,before){
    if (before==0){
      list(authToken = authToken,language='en',maxResults = r, fields="device,simple,basic,lcp_count")
    } else {
      list(authToken = authToken,language='en',maxResults = r,
          fields="device,simple,basic,lcp_count",before=before)
    }
  }
  
  URL_WORKOUTS = confs[confs$key == 'URL_WORKOUTS', ]$value
  r = GET(URL_WORKOUTS,query=query_workouts(results,before))
  workouts=content(r)
  
  df <- data.frame(matrix(ncol = 7, nrow = 0))
  colnames(df) <- c("id","sport","start_time",
                    "hr","distance","duration","kcal")
  
  i=1
  for (workout in workouts[[1]]){
    
    if ( is.null(workout["heart_rate_avg"][[1]]) ){
      hr = 0
    } else {
      hr = workout["heart_rate_avg"]
    }
    
    if ( is.null(workout["distance"][[1]]) ){
      distance = 0
    } else {
      distance = workout["distance"]
    }
    
    
    if ( is.null(workout["speed"][[1]]) ){
      speed = 0
    } else {
      speed = workout["speed"]
    }
    
    if ( is.null(workout["calories"][[1]]) ){
      kcal = 0
    } else {
      kcal = workout["calories"]
    }
    
    if ( is.null(workout["duration"][[1]]) ){
      duration = 0
    } else {
      duration = workout["duration"]
    }
    
    if ( is.null(workout["start_time"][[1]]) ){
      start_time = 0
    } else {
      start_time = workout["start_time"]
    }
    
    if ( is.null(workout["id"][[1]]) ){
      id = 0
    } else {
      id = workout["id"]
    }
    
    if ( is.null(workout["sport"][[1]]) ){
      sport = 0
    } else {
      sport = workout["sport"]
    }
    
    tw <-  data.frame(id,sport,start_time,hr,distance,duration,kcal)
    colnames(tw) <- c("id","sport","start_time",
                      "hr","distance","duration","kcal")
    
    df <- rbind(tw, df)
    i=1+i
  }
  
  df
}

###
### list worspace by year
###   :param before: Optional datetime object or iso format date string (%Y-%m-%d %H:%M:%S UTC)
list_workouts_by_year <- function(confs,start,end){
  
  anomes<-paste(as.character(start),'02',sep='-')
  data1 <- paste(anomes,'-01 00:00:00 UTC' ,sep="")
  ws<-list_workouts(confs,results=60,before=data1)
  
  for (ano in start:end ){
    for (mes in 3:12){
      anomes<-paste(as.character(ano),sprintf("%02d", mes),sep='-')
      data1 <- paste(anomes,'-01 00:00:00 UTC' ,sep="")
      w1<-list_workouts(confs,results=60,before=data1)
      ws <- rbind(ws,w1)
    }
    
  }
    
  ws[!duplicated(ws),]
}



###
### Get workout 
###

get_workout_data <- function(confs,id){
  #id = 861392806
  
  
  query_workout <- function(workout_id){
    #f = "device,simple,basic,motivation,interval,hr_zones,weather,polyline_encoded_small,points,lcp_count,tagged_users,pictures,feed"
    f = "weather,polyline_encoded_small,points"
    list(authToken = authToken,language='en', fields=f , workoutId=workout_id)
  }
  
  URL_WORKOUT_GET = confs[confs$key == "URL_WORKOUT_GET", ]$value
  workout_data <- content(GET(URL_WORKOUT_GET,query=query_workout(id)))
  
  #consultar a API code 3 accuwather
  #workout_data['weather']

  points = workout_data['points'][[1]]
  #date <- get_data(points[[1]],"time")
  #time <- get_data(points[[1]],"inst")
  #lat <- get_data(points[[1]],"lat")
  #long <- get_data(points[[1]],"lng")
  #hr <- get_data(points[[1]],"hr")
  #dist <- get_data(points[[1]],"dist")
  #points <- points[-1]
  
  #df <- data.frame(date,time,lat,long,dist,hr)
  
  df <- data.frame(matrix(ncol = 5, nrow = 0))
  colnames(df) <- c("date","lat","long","distance","hr")
  
  
  #for (point in workout_data['points'][[1]] ){
  for (point in points ){
    date <- get_data(point,"time")
    #time <- get_data(point,"inst")
    lat <- get_data(point,"lat")
    long <- get_data(point,"lng")
    hr <- get_data(point,"hr")
    dist <- get_data(point,"dist")
    
    p <-  data.frame(date,lat,long,dist,hr)
    colnames(p) <- c("date","lat","long","distance","hr")
    df <- rbind(p, df)
  }
  
  df
  
}


