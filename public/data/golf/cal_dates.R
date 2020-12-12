# 골프장별 날짜 계산 함수

library(lubridate) 
printf <- function(...) cat(sprintf(...))

# wday 결과값에 따른 숫자별 요일
#' Sun = 1, Mon = 2, Tue = 3, Wed = 4, Thu = 5, Fri = 6, Sat = 7

#' reference
#' https://stackoverflow.com/questions/32434549/how-to-find-next-particular-day
#' To set week.start option,
#' Day on which week starts following ISO conventions
#' 1 means Monday
#' 7 means Sunday (default)
#' You can set lubridate.week.start option to control this parameter globally

prev_n_weekday = function(date, wday, n=1, start = 'Sun'){
  date = as.Date(date)
  if (start == 'Sat'){
    k = 6
  }
  else if(start == 'Fri'){
    k = 5
  }
  else if(start == 'Sun'){
    k = 7
  }
  else if(start == 'Mon'){
    k = 1
  }
  diff = wday - wday(date, week_start = k)
  diff = diff - 7*n
  mydate = date + diff
  return(mydate)
}

# 청도 그레이스
grace = function(date){
  date = as.Date(date)
  mydate = prev_n_weekday(date, wday(date), 2)
  return(mydate)
}

# 군위 군위오펠
ophel = function(date){
  date = as.Date(date)
  wday = 3 # 화요일
  # start 세팅값 7=토요일 // 1=일요일
  if(wday(date) == 7){
    mydate = prev_n_weekday(date, wday, 1, start = 'Sun')
  }
  # 주중
  else {
    mydate = prev_n_weekday(date, wday, 2, start = 'Sun')
  }
  return(mydate)
}

# 군위 구니cc
guni = function(date){
  date = as.Date(date)
  wday = 3
  # start 세팅값 7=토요일 // 1=일요일
  if(wday(date) == 7){
    mydate = prev_n_weekday(date, wday, 2, start = 'Sun')
  }
  else if(wday(date) == 1){
    mydate = prev_n_weekday(date, wday, 3, start = 'Sun')
  }
  # 주중
  else {
    mydate = prev_n_weekday(date, wday, 2, start = 'Sun')
  }
  return(mydate)
}

# 창녕 동훈힐마루 (비회원기준)
hilmaru = function(date){
  date = as.Date(date)
  
  # start 세팅값 7=토요일 // 1=일요일
  if(wday(date) == 7){
    mydate = prev_n_weekday(date, wday = 6, 3, start = 'Sun')
  }
  else if(wday(date) == 1){
    mydate = prev_n_weekday(date, wday = 6, 4, start = 'Sun')
  }
  # 주중
  else {
    mydate = prev_n_weekday(date, wday = 3, 3, start = 'Sun')
  }
  
  return(mydate)
}

# 세븐밸리
valley = function(date){
  date = as.Date(date)
  wday = 3 # 화요일
  # start 세팅값 7=토요일 // 1=일요일
  if(wday(date) == 7){
    mydate = prev_n_weekday(date, wday, 1, start = 'Sun')
  }
  # 주중
  else {
    mydate = prev_n_weekday(date, wday, 2, start = 'Sun')
  }
  return(mydate)
}

# 마스터피스
master = function(date){
  date = as.Date(date)
  mydate = prev_n_weekday(date, wday(date), 3)
  return(mydate)
}