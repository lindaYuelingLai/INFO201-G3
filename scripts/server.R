library(shiny)
library(dplyr)
library(ggplot2)
library(mapdata)
library(maps)

server <- function(input, output) {
  # read in large dataset for fatal shooting in the US
  # dataset is very current (the one used for our project is taken from 12/01/2018)
  shooting_data <- read.csv("data/shootings_data.csv", stringsAsFactors = FALSE)

  # return bar graph for the specified race, grouped by state
  output$statePlot <- renderPlot({
    race_by_state <- function(the_race) {
      title <- ""
      state_data <- shooting_data
      if (the_race == "all") {
        title <- "All Races"
      } else {
        if (the_race == "W") title <- "White"
        if (the_race == "B") title <- "Black"
        if (the_race == "H") title <- "Hispanic"
        if (the_race == "A") title <- "Asian"
        if (the_race == "N") title <- "Native American"
        state_data <- filter(state_data, race == the_race)
      }
      state_data <- state_data %>% group_by(state) %>% summarise(n = n()) %>% arrange(desc(n))
      result_plot <- ggplot(state_data, aes(state_data, x = state, y = n, fill=state)) +
        geom_bar(stat="identity", width = 1) +
        labs(
          fill="State",
          title = paste0("Fatal Shootings by State, ", title),
          x = "State",
          y = "Reports"
        ) +
        theme(axis.text.x=element_text(size=rel(1), angle=90),
              plot.title=element_text(size=15,face="bold"))
      return(result_plot)
    }
    race_by_state(input$race)
  })

  # return bar graph for the specified race, grouped by arm(s) held by victim
  output$factorsPlot <- renderPlot({
    race_by_armed <- function(the_race) {
      title <- ""
      armed_data <- shooting_data
      if (the_race == "all") {
        title <- "All Races"
      } else {
        if (the_race == "W") title <- "White"
        if (the_race == "B") title <- "Black"
        if (the_race == "H") title <- "Hispanic"
        if (the_race == "A") title <- "Asian"
        if (the_race == "N") title <- "Native American"
        armed_data <- filter(armed_data, race == the_race)
      }
        armed_data[armed_data != "unarmed" & armed_data != "gun"] <- "other"
        armed_data <- armed_data %>% group_by(armed) %>% summarise(n = n()) %>% arrange(desc(n))
        result_plot <- ggplot(armed_data, aes(armed_data, x = armed, y = n,fill=armed)) +
          geom_bar(stat="identity", width = 1) +
          labs(
            fill="",
            title = paste0("Fatal Shootings by Armed / Unarmed, ", title),
            x = "Armed / Unarmed",
            y = "Reports"
          ) +
          theme(axis.text.x=element_text(size=rel(1), angle=90),
                plot.title=element_text(size=15,face="bold"))
        return(result_plot)
    }
    
    # return bar graph for the specified race, grouped by whether victim showed signs of mental illness
    race_by_mental_illness <- function(the_race) {
      title <- ""
      mi_data <- shooting_data
      if (the_race == "all") {
        title <- "All Races"
      } else {
        if (the_race == "W") title <- "White"
        if (the_race == "B") title <- "Black"
        if (the_race == "H") title <- "Hispanic"
        if (the_race == "A") title <- "Asian"
        if (the_race == "N") title <- "Native American"
        mi_data <- filter(mi_data, race == the_race)
      }
        mi_data <- mi_data%>% group_by(signs_of_mental_illness) %>% summarise(n = n()) %>% arrange(desc(n))
        result_plot <- ggplot(mi_data, aes(signs_of_mental_illness, x = signs_of_mental_illness, y = n, 
                                           fill=signs_of_mental_illness)) +
          geom_bar(stat="identity", width = 1) +
          labs(
            fill="",
            title = paste0("Fatal Shootings by Perceived Mental Illness: ", title),
            x = "Mental Illness",
            y = "Reports"
          ) +
          theme(axis.text.x=element_text(size=rel(1), angle=90),
                plot.title=element_text(size=15,face="bold"))
        return(result_plot)
      }
    
    # return bar graph for the specified race, grouped by whether the victim tried to flee or not
    race_by_flee <- function(the_race) {
      title <- ""
      flee_data <- shooting_data
      if (the_race == "all") {
        title <- "All Races"
      } else {
        if (the_race == "W") title <- "White"
        if (the_race == "B") title <- "Black"
        if (the_race == "H") title <- "Hispanic"
        if (the_race == "A") title <- "Asian"
        if (the_race == "N") title <- "Native American"
        flee_data <- filter(flee_data, race == the_race)
      }
      flee_data[flee_data != "Not fleeing"] <- "Fleeing"
      flee_data <- flee_data%>% group_by(flee) %>% summarise(n = n()) %>% arrange(desc(n))
      result_plot <- ggplot(flee_data, aes(flee, x = flee, y = n, fill=flee)) +
        geom_bar(stat="identity", width = 1) +
        labs(
          fill="",
          title = paste0("Fatal Shootings by Fleeing / Not Fleeing, ", title),
          x = "Fleeing / Not Fleeing",
          y = "Reports"
        ) +
        theme(axis.text.x=element_text(size=rel(1), angle=90),
              plot.title=element_text(size=15,face="bold"))
      return(result_plot)
    }

    # return bar graph for the specified race, grouped by threat level
    race_by_threat <- function(the_race) {
      title <- ""
      threat_data <- shooting_data
      if (the_race == "all") {
        title <- "All Races"
      } else {
        if (the_race == "W") title <- "White"
        if (the_race == "B") title <- "Black"
        if (the_race == "H") title <- "Hispanic"
        if (the_race == "A") title <- "Asian"
        if (the_race == "N") title <- "Native American"
        threat_data <- filter(threat_data, race == the_race)
      }
      threat_data <- threat_data%>% group_by(threat_level) %>% summarise(n = n()) %>% arrange(desc(n))
      result_plot <- ggplot(threat_data, aes(threat_data, x = threat_level, y = n, fill=threat_level)) +
        geom_bar(stat="identity", width = 1) +
        labs(
          fill="",
          title = paste0("Fatal Shootings by Threat Level: ", title),
          x = "Threat Level",
          y = "Reports"
        ) +
        theme(axis.text.x=element_text(size=rel(1), angle=90),
              plot.title=element_text(size=15,face="bold"))
      return(result_plot)
    }
    if (input$factors=="armed") { print(race_by_armed(input$race)) }
    if (input$factors=="mental") { print(race_by_mental_illness(input$race)) }
    if (input$factors=="threat") { print(race_by_threat(input$race)) }
    if (input$factors=="flee") { print(race_by_flee(input$race)) }
  })
  
  # plots pie chart of what percentages of fatal shootings each race called for
  output$racePlot <- renderPlot({
    race_data <- shooting_data %>% filter(race != "" & race != "O") %>% group_by(race) %>% 
                 count() %>% ungroup() %>% mutate(per=`n`/sum(`n`)) %>% arrange(desc(race))
    race_data$label <- scales::percent(race_data$per)
    pie_chart <- ggplot(data = race_data) +
      geom_bar(aes(x="", y=per, fill=race), stat="identity", width = 1) +
      coord_polar("y", start=0) +
      ggtitle("Percentage by Race") +
      theme_void()+
      theme(plot.title=element_text(size=15,face="bold")) +
      geom_text(aes(x=1, y = cumsum(per) - per/2, label=label)) +
      scale_fill_discrete("race", 
                          breaks=c("A", "B", "H", "N", "W"), 
                          labels=c("Asian", "Black", "Hispanic", "Native American", "White"))
    pie_chart
  })
  
  # dataset of cities in Washington state for plotting map
  cities <- read.csv("data/wa_cities.csv", stringsAsFactors = FALSE)
  
  # plots map of Washington state, with red dots representing where a fatal police shooting occurred 
  output$mapPlot <- renderPlot({
    wa_map_data <- map_data("state", region="washington")
    map <- ggplot(data = wa_map_data) + 
      geom_polygon(aes(x = long, y = lat, group = group), color = "white") + 
      coord_fixed(1.3) +
      geom_point(data=cities, aes(x=lon, y=lat, size=0.5), color="red") +
      ggtitle("WA State, Shootings by City") +
      theme(plot.title=element_text(size=15,face="bold")) +
      guides(fill=FALSE)
    map
  })
  
  # displays the current coordinate on the map that the user hovers their mouse over
  output$info <- renderText({
    get_coord <- function(position) {
      if(is.null(position)) return("None")
        paste0(round(position$y, 4), "ºN, ", abs(round(position$x, 4)), "ºW")
    }
    paste0("Coordinate: ", get_coord(input$plot_hover))
  })
}

shinyServer(server)