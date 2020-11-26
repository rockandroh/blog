#'
#' previous calendar week's Monday
#' 날짜 뽑아내기
#'

library('shiny')
library('DT')
library('lubridate')

club_name = c('군위구니','군위오펠','그레이스','마스터피스',
              '세븐밸리','힐마루')

#' Calculate date function 
printf <- function(...) cat(sprintf(...))

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

#' -------------------------------------------------
#' Define server logic required to draw a histogram
#' 서버
#' -------------------------------------------------

shinyServer(function(input, output, session) {

    output$seldate = renderText ({
        paste("선택한 날짜는", format(input$date, "%Y년 %m월 %d일"), " 입니다.")
        # input$date # this will not output the date in correct format. 
        # Convert to character before using in render function as.character(input$date)
        # as.character(input$date) # to exclusively convert date to character for printing to retain the date format
        # match the date format to the format in input date widget. Use the format() to change the date format
        # paste("Selected Date is ", format(input$date, "%m/%d/%y"))
    })
    
    data <- eventReactive(input$date, {rbind(format(input$date, "%Y-%m-%d"),
                                        format(ophel(input$date), "%Y-%m-%d"),
                                        format(guni(input$date), "%Y-%m-%d"))
                                      }
                          )
    
    data2 <- eventReactive(input$date, {data.frame('골프장'= club_name,
                                                   '오픈날짜'= c(format(guni(input$date), "%m월 %d일"), 
                                                                format(ophel(input$date), "%m월 %d일"),
                                                                format(grace(input$date), "%m월 %d일"), 
                                                                format(master(input$date), "%m월 %d일"),
                                                                format(valley(input$date), "%m월 %d일"), 
                                                                format(hilmaru(input$date), "%m월 %d일")
                                                              ),
                                                   '시간' = c('10시','10시','9시','9시','9시','9시')
                                                   )
                                        }
                          )
    
    mydata = eventReactive(input$date, {cbind(c(as.character(input$date), as.character(ophel(input$date), "%Y-%m-%d")),
                                              c(as.character(guni(input$date), "%Y-%m-%d")), as.character(guni(input$date), "%Y-%m-%d"))
                                        }
                          )
  
    # output$test3 = DT::renderdatatable({data.frame('골프장'=club_name[1:3],
    #                                     'date' = data2)()})
    output$test3 = DT::renderDataTable({data2()})
    
    final_df = eventReactive(input$searchbutton, {
        datatable(mtcars[,1:4], class = 'hover') 
    })
    
    output$mytable = DT::renderDataTable({final_df()}) 


})