library(shiny)
library(ggplot2)
library(reshape2)
library(dplyr)
library(ggcorrplot)

fb_total <- read.csv("fb_data_total.csv" , header = T)

names(fb_total)[14:20] <- c(7,1,2,3,4,5,6)
fb_total2 <-  fb_total %>%
  gather(key = "week",
         value = "cases",
         names(fb_total)[14:20] )
fb_total2 <- fb_total2 %>% filter( cases == 1)
fb_total_week <- fb_total2[,-ncol(fb_total2)]
pub_weekday <-as.data.frame(table(fb_total_week$week))
pub_weekday$Var1<-c('Mon','Tue','Wed','Thur','Fri','Sat','Sun')
fb_total_week$week <- as.factor(fb_total_week$week)


Page_Popularity.likes<-fb_total_week$Page_likes
Page_Checkins<-fb_total_week$Page_Checkins
Page_talking_about<-fb_total_week$Page_talking_about
Page_Category<-table(fb_total_week$Page_Category)

Comments_before_Base<-fb_total_week$total_comments
Comments_24_base<-fb_total_week$no_of_comments_24_base
Comments_24_48<-fb_total_week$no_of_comments_48_24
Comments_first_24<-fb_total_week$no_of_comments_first_24
Comments_H<-fb_total_week$Target.Variable.

Post_length<-fb_total_week$Post_length
Post_Share_Count<-fb_total_week$Post.Share.Count

function(input, output){
  
  output$plot1 <- renderPlot({hist(fb_total$Page_likes)})
  
  #-------------------------model-------------  
  data <- reactive({  
    variable <- switch(input$variable,
                       likes = Page_Popularity.likes,
                       Checkins = Page_Checkins,
                       talking_about = Page_talking_about,
                       Category = Page_Category)
  })
  
  # Generate a plot of the data. Also uses the inputs to build the 
  # plot label. Note that the dependencies on both the inputs and
  # the 'data' reactive expression are both tracked, and all expressions 
  # are called in the sequence implied by the dependency graph
  output$histogram <- renderPlot({
    qplot(data(), geom="histogram", main = as.character(input$variable) )
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    summary(data())
  })
  #boxplot
  output$boxplot <- renderPlot({
    boxplot(data(), main = as.character(input$variable) )
  })
  #barplot
  output$bar<-renderPlot({
    barplot(data(), main = as.character(input$variable))
  })
  #hist
  dat <- reactive({
    fb_total_week[which(fb_total_week$week ==input$num),]
  })
  output$histgram<-renderPlot({
    ggplot(dat(), aes(x=no_of_comments_first_24)) + geom_histogram(fill = "#56B4E9")+ 
      labs(title =paste(as.character(pub_weekday$Var1[input$num]),'\nSample Size : ',pub_weekday$Freq[input$num],sep=''))
  })
  
  #cor
  dat <- reactive({
    fb_total_week[which(fb_total_week$week==input$num),c(1,2,3,5,6,7,8,10,11)]
  })
  output$corr<-renderPlot({
    ggplot(data = melt(cor((as.matrix(dat())))), aes(x=Var1, y=Var2,fill=value)) + 
      geom_tile()+
      scale_fill_gradient2(low = "#6D9EC1", high = "#E46726", mid = "white", 
                           midpoint = 0, limit = c(-1,1), space = "Lab", 
                           name="Pearson\nCorrelation") +
      theme_minimal()+ 
      theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                       size = 12, hjust = 1),
            plot.title = element_text(hjust = 0.5))+
      coord_fixed()+ labs(title =paste(as.character(pub_weekday$Var1[input$num]),'\nSample Size : ',pub_weekday$Freq[input$num],sep=''))
  })
  
  
  #----------------infrobox
  output$progressBox <- renderInfoBox({
    infoBox(
      "Attributes", 54 ,icon = icon("creative-commons-by"),
      color = "blue"
    )
  })
  output$approvalBox <- renderInfoBox({
    infoBox(
      "Missing?", "N/A", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "navy"
    )
  })
  
  #------view
  output$ex1 <- DT::renderDataTable(
    DT::datatable(fb_total_week, options = list(pageLength = 25))
  )
 
}
 
  
  
  
 
