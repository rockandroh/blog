#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library('shiny')
library('DT')
library('shinyWidgets')
library('lubridate')

linebreaks <- function(n){HTML(strrep(br(), n))}

shinyUI(navbarPage(title = "공치자",
  tabPanel("날짜확인",
           h4(p("공칠 날짜를 선택하고", strong("골프장 별로 언제 예약"), "해야하는지 알아보세요!")),
           h5("현재는 비회원제 위주의 대구/영남권 골프장 정보만 제공합니다."),
           h5("추후에 수도권, 부산권, 강원권 데이터들도 추가 하겠습니다."),
      sidebarPanel(
        # Add an action button to update the date
        h4(paste("Today: ", format(Sys.Date(), "%Y년 %m월 %d일"))),
        dateInput(
          inputId = "date",
          label = h4(span(HTML("<i class='glyphicon glyphicon-calendar'>
                               </i> 아래 날짜 박스를 클릭후 날짜 선택!"),
                          style="color:red")),
          value = Sys.Date() + 1,
          min  = Sys.Date(),
          max  = Sys.Date() + 90,
          #label = "Select multiple dates:",
          #multiple = FALSE,
          width = "100%",
          language = 'kr',
          #update_on = 'change',
          autoclose = TRUE,
          #position = 'top right',
          #inline = TRUE
          )
        ),
     mainPanel(DT::dataTableOutput("test3"),
               h4(span(textOutput("seldate"), style = "color:blue")),
               h4(span("오픈 날짜를 클릭하여 빠른 날짜순으로 정렬하세요"
                       , style = "color:blue")),
               linebreaks(1),
               h4(p("만든이 : ", strong("Roh"))),
               h4(p("이메일 : ", strong("metrics@kakao.com")))
              )
  )
          

 # tabPanel("골프장별 정보",
 #          h4("아래의 주소를 클릭하시면 정리된 골프장 정보를 확인할 수 있습니다."),
 #          hr(),
 #          h1(a("클릭", href = "https://www.rockandroh.com/data/golf-club-summary/"))
 #          ),
 #          
 # tabPanel("골프 명언",
 #          h3("- Success in this game depends less on strength of body than strength of mind and character. [Arnold Palmer] "),
 #          h3("- You must play boldly to win. [Arnold Palmer] ")
 #          )
                   
 
 
))