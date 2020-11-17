#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Navigation through the tabs at the top of the page
# These navigation tabs may server as individual pages, may have contents or widgets or further menu based navigation

# use inverse = T , for black background of nav bar menu and light fonts
# use selected argument to specify which tab should show up when app loads
# use position="fixed-bottom" - navbar at the bottom
# use position="static-top" - for scrollable bar
# use position="fixed-top" - bar is fixed but page is scrollable
# use collapsible = T if the app is used on tab where resolution is less. It will appear as collapsible menu
# Important note that a navbarmenu cannot be the first tab/page

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
                                      label = span(HTML("<i class='glyphicon glyphicon-calendar'></i> 아래의 박스를 클릭하여 날짜를 선택하세요!"),
                                                   style="color:red"),
                                      language = "kr",
                                      value = Sys.Date(), # date value that shows up initially
                                      min = Sys.Date(),  # set the minimun date
                                      max = Sys.Date() + 30, # set the maximum date
                                      width = "300px", # set the width of widget
                                      
                                      format="yyyy-mm-dd") # set the format (default is yyyy-mm-dd)
                            
                            ),
                            h4(span(textOutput("seldate"), style = "color:blue")),
                            hr(),
                            column(5,
                                   h4("날짜 선택 후 조회 버튼을 눌러주세요")),
                            column(7, actionButton(inputId = "searchbutton", "조회"))
                   ),
                   
                   
                   tabPanel("골프장별 정보 (수리중)", 
                            tableOutput("data")),
                   
                   tabPanel("골프 명언",
                            h5("Success in this game depends less on strength of body than strength of mind and character. - 아놀드파머 "),
                            h5("You must play boldly to win. - 아놀드파머 ")),
                   
))