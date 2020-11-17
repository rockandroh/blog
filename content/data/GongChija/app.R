# Demo dateInput()

# Load required packages
library(shiny)
library(shinythemes)

# Navigation through the tabs at the top of the page
# These navigation tabs may server as individual pages, may have contents or widgets or further menu based navigation

# use inverse = T , for black background of nav bar menu and light fonts
# use selected argument to specify which tab should show up when app loads
# use position="fixed-bottom" - navbar at the bottom
# use position="static-top" - for scrollable bar
# use position="fixed-top" - bar is fixed but page is scrollable
# use collapsible = T if the app is used on tab where resolution is less. It will appear as collapsible menu
# Important note that a navbarmenu cannot be the first tab/page

library(shiny)
shinyUI(navbarPage(title = "공치자", 
                   
                   tabPanel("예약 가능일 확인", 
                            h4("공칠 날짜를 선택하고 골프장 별로 언제 예약을 해야하는지 알아보세요!"),
                            h5("현재는 제 개인적인 사용목적으로 비회원제 위주의 대구/영남권 골프장 정보만 제공합니다."),
                            h5("추후에 수도권, 부산권, 강원권 데이터들도 추가 하겠습니다."),
                            dateInput("date",  # Input ID
                                      
                                      label="Date Input", # label
                                      # use below to show the calendar icon inline
                                      # label = HTML("<i class='glyphicon glyphicon-calendar'></i> Date Input"),
                                      
                                      value = Sys.Date(), # date value that shows up initially
                                      
                                      min = Sys.Date(),  # set the minimin date
                                      
                                      max = Sys.Date()+ 30, # set the maximum date
                                      
                                      width = "150px", # set the width of widget
                                      
                                      format="yyyy-mm-dd"), # set the format (default is yyyy-mm-dd)
                            textOutput("seldate")
                   ),
                   
                   
                   tabPanel("골프장별 정보", 
                            tableOutput("data")),
                   
                   tabPanel("골프 명언",
                            h5("Success in this game depends less on strength of body than strength of mind and character. - 아놀드파머 "),
                            h5("You must play boldly to win. - 아놀드파머 ")),
                   
                   tabPanel("Widgets & Sidebar",
                            sidebarLayout(
                                sidebarPanel(
                                    sliderInput("b", "Select no. of BINs", min = 5, max = 20,value = 10)
                                ),
                                mainPanel(
                                    plotOutput("plot")
                                )
                            )
                   ),
                   ## Use navbarmenu to get the tab with menu capabilities
                   navbarMenu("Menu Options",
                              tabPanel("Menu item A - Summary stats", verbatimTextOutput("summary")),
                              tabPanel("Menu item B - Link to code",
                                       h4(HTML(paste("Thanks for watching the video. Reference code available at the following", a(href="https://github.com/aagarw30/R-Shinyapp-Tutorial/tree/master/shinylayouts/navbarpage%20demo", "link"), "."))),
                                       h4(HTML(paste("In case you have questions", a(href="mailto:aagarw30@gmail.com", "email me"), ".")))
                                       
                              ))
))


shinyServer(function(input, output, session) {
    
    
    # for display of mtcars dataset in the "Data Page"
    output$data <- renderTable({
        mtcars
    })
    
    # for display of histogram in the "Widget & Sidepar page"
    output$plot <- renderPlot({
        hist(mtcars$mpg, col ="blue", breaks=input$b )
    })
    
    # for display of mtcars dataset summary statistics in the "Menu item A page"
    output$summary <- renderPrint({
        summary(mtcars)
    })
    
})

