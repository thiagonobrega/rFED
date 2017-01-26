### 
### this method get heart rate zones
###
#### rest:     hr < 50% 
#### recovery: 50% < hr < 60%
#### fatburn:  60% < hr < 70%
#### cardio:   70% < hr < 80%
#### hardcore: 80% < hr < 90%
#### max:      hr > 90%
###
### output: dataframe with (zonename,hfun,lower_heart_rate,higher_heart_rate)

get_hr_zones <- function(rest_hr,max_hr){
  z0 = data.frame( name="death",hfun="anaerobic", hrl=as.integer(max_hr) , hrh=as.integer(max_hr+10))
  z1 = data.frame( name="max",hfun="anaerobic", hrl=as.integer(max_hr * 0.9) , hrh=as.integer(max_hr))
  #fatburn
  zones <- rbind(z0,z1)
  z1 = data.frame( name="hardcore",hfun="anaerobic", hrl=as.integer(max_hr * 0.8) , hrh=as.integer(max_hr * 0.9))
  zones <- rbind(zones,z1)
  z1 = data.frame( name="cardio",hfun="aerobic", hrl=as.integer(max_hr * 0.7) , hrh=as.integer(max_hr * 0.8))
  zones <- rbind(zones,z1)
  z1 = data.frame( name="fatburn",hfun="aerobic", hrl=as.integer(max_hr * 0.6) , hrh=as.integer(max_hr * 0.7))
  zones <- rbind(zones,z1)
  z1 = data.frame( name="recovery",hfun="aerobic", hrl=as.integer(max_hr * 0.5) , hrh=as.integer(max_hr * 0.6))
  zones <- rbind(zones,z1)
  z1 = data.frame( name="rest",hfun="aerobic", hrl=as.integer(rest_hr) , hrh=as.integer(max_hr * 0.5))
  zones <- rbind(zones,z1)
  
  zones
}