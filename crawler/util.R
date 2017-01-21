
###
### Util
### 
get_data <- function(data,attribute){
  
  
  if ( is.null(data[attribute][[1]]) ){
    retorno = 0 
  } else {
    retorno = data[attribute][[1]]
  }
  
  retorno
}