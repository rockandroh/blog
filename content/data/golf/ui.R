#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

linebreaks <- function(n){HTML(strrep(br(), n))}

shinyUI(navbarPage(title = "공치자", 
                   
                   tabPanel("예약 가능일 확인", 
                            h4(p("공칠 날짜를 선택하고", strong("골프장 별로 언제 예약"), "해야하는지 알아보세요!")),
                            h5("현재는 비회원제 위주의 대구/영남권 골프장 정보만 제공합니다."),
                            h5("추후에 수도권, 부산권, 강원권 데이터들도 추가 하겠습니다."),
                            # Add an action button to update the date
                            hr(),
                            h4(paste("오늘은", format(Sys.Date(), "%Y년 %m월 %d일"), " 입니다.")),
                            textOutput("today"),
                            column(12,
                               dateInput("date",  # Input ID
                              #label="Date Input", # label
                              # use below to show the calendar icon inline
                              label = h4(span(HTML("<i class='glyphicon glyphicon-calendar'></i> 아래의 날짜박스를 클릭하여 날짜를 선택하세요!"),
                                           style="color:red")),
                              language = "kr",
                              value = Sys.Date()+1, # date value that shows up initially
                              min = Sys.Date(),  # set the minimun date
                              max = Sys.Date() + 30, # set the maximum date
                              width = "450px", # set the width of widget
                              autoclose = FALSE,
                              format="yyyy-mm-dd") # set the format (default is yyyy-mm-dd)
                            ),
                            br(),
                            h4(span(textOutput("seldate"), style = "color:blue")),
                            hr(),
                            #column(8, h4("날짜 선택 후 초록색 조회 버튼을 눌러주세요!")),
                            #column(4, actionButton(inputId = "searchbutton", "조회", icon = icon("mouse-pointer"), class = "btn-success")),
                            #hr(),
                            #linebreaks(1),
                            textOutput('test'),
                            textOutput('test2'),
                            DT::dataTableOutput("test3"),
                            linebreaks(2),
                            DT::dataTableOutput("mytable")
                            ),
                   
                   tabPanel("골프장별 정보",
                            h4("아래의 주소를 클릭하시면 정리된 골프장 정보를 확인할 수 있습니다."),
                            h1(a("클릭", href = "https://www.rockandroh.com/data/golf-club-summary/"))
                            ),
                            
                   tabPanel("골프 명언",
                            h3("- Success in this game depends less on strength of body than strength of mind and character. [Arnold Palmer] "),
                            h3("- You must play boldly to win. [Arnold Palmer] ")
                            )
                   
))