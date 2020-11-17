#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    output$seldate = renderText ({
        paste("선택한 날짜는", format(input$date, "%Y년 %m월 %d일"), " 입니다.")
        # input$date # this will not output the date in correct format. 
        # Convert to character before using in render function as.character(input$date)
        # as.character(input$date) # to exclusively convert date to character for printing to retain the date format
        # match the date format to the format in input date widget. Use the format() to change the date format
        # paste("Selected Date is ", format(input$date, "%m/%d/%y"))
    })
    

    
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