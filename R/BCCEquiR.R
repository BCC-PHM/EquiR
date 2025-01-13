`%>%` = dplyr::`%>%`


#' Making a heatmap with bar charts on the top and right on record level data
#'
#' @param data   user supplied data
#' @param col    user defined column
#' @param row    user defined row
#' @param coln   user customise column name
#' @param rown   user customise row name
#' @param unit   user can define unit if supplied, otherwise unit will be count as always unless Percent argument is given T, then unit wil be Percentaage automatically
#' @param outcome allow user to supply outcome variable to calculate within group percentage
#' @param colour user defined colour for the graph
# Add returning value description and tag
#' @returns A graph
# Export this function
#' @export


Ineq_record_level_heatmap = function(data,
                                     col,
                                     row,
                                     coln,
                                     rown,
                                     unit = NULL,
                                     outcome = NA,
                                     colour = "blue" ){



  ##the first layer of transforming data for heatmap
  if(!is.na(outcome)){
    heatmap_df = as.data.frame(table(data[[col]], data[[row]]))
    data[[outcome]] = factor(data[[outcome]])
    outcomedata= data %>% filter(data[[outcome]] == levels(data[[outcome]])[1])
    outcomedata= as.data.frame(table(outcomedata[[col]], outcomedata[[row]]))
    heatmap_df =left_join(heatmap_df, outcomedata, by=c("Var1", "Var2")) %>%
      mutate(Freq = as.numeric(format(round(Freq.y/Freq.x*100, 2), nsmall =2)))

  }else{
    heatmap_df = as.data.frame(table(data[[col]], data[[row]]))
  }



  #
  # ##the first layer of transforming data for heatmap
  # if(percent %in% c(T, TRUE)){
  #   heatmap_df = as.data.frame(table(data[[col]], data[[row]]))
  #   heatmap_df = heatmap_df %>%
  #     dplyr::mutate(Freq = as.numeric(format(round(Freq/sum(Freq)*100, 2), nsmall =2)))
  # } else{
  #   heatmap_df = as.data.frame(table(data[[col]], data[[row]]))
  # }


  ##define threshold for geom text label
  threshold = quantile(heatmap_df$Freq, probs = 0.99) ##to make the label white for greatest value

  ##define quantiles for the colour scale
  colour_quantiles = quantile(heatmap_df$Freq, probs = c(0, 0.25, 0.5, 0.75, 1))

  ## Define color palette based on user input
  if(tolower(colour) == "red"){
    heatmap_colour = colorRampPalette(c('#FFFFFF', '#FFB3C1', '#FF4D6D', '#A4133C', '#590D22'))(100) #https://coolors.co/palette/590d22-800f2f-a4133c-c9184a-ff4d6d-ff758f-ff8fa3-ffb3c1-ffccd5-fff0f3
    bar_colour = "#A4133C"
  } else if (tolower(colour) == "green"){
    heatmap_colour = colorRampPalette(c('#FFFFFF', '#A3B18A', '#588157', '#3A5A40', '#344E41'))(100) #https://coolors.co/palette/dad7cd-a3b18a-588157-3a5a40-344e41
    bar_colour = "#3A5A40"
  } else {
    heatmap_colour = colorRampPalette(c('#FFFFFF', '#BFD7ED', '#60A3D9', '#0074B7', '#003B73'))(100) #this is a default blue https://www.canva.com/colors/color-palettes/speckled-eggs/
    bar_colour = "#0074B7"
  }



  ##To include percentage sign for the heatmap text label and the bar and column scales into percentage
  if(!is.na(outcome)){
    heatmap_label = paste0(heatmap_df$Freq, "%")
    barscales = scales::percent_format()
  } else{
    heatmap_label = heatmap_df$Freq
    barscales = scales::label_number()}



  ##the heatmap plot
  heatmap = ggplot(heatmap_df, aes(Var1, Var2, fill=Freq))+
    geom_tile( colour="White")+
    scale_fill_gradientn(colours = heatmap_colour,
                         breaks = colour_quantiles)+
    geom_text(aes(x=Var1, y=Var2, label=heatmap_label),color = ifelse(heatmap_df$Freq>threshold, "white","black"),
              size = 3)+
    theme_minimal()+
    theme(
      legend.position="none",
      panel.spacing = unit(0, "pt"))+
    xlab({{coln}})+
    ylab({{rown}})


  ##Handle unit display
  if (!is.null(unit)) { #this check if user has supplied a unit, If they have,
    # Use the user-supplied unit
  } else {  #If not
    if (!is.na(outcome)) {  #determine the unit based on the Percent parameter.
      unit = "Percentage"
    } else {
      unit = "Count"
    }
  }


  ##the second layer of transforming data for the upper bar chart
  if(!is.na(outcome)){
    topbar_df = as.data.frame(table(data[[col]]))
    topoutcome = data %>% filter(data[[outcome]] == levels(data[[outcome]])[1])
    topoutcome = as.data.frame(table(topoutcome[[col]]))
    topbar_df = left_join(topbar_df, topoutcome, by="Var1") %>%
      mutate(Freq = as.numeric(format(round(Freq.y/Freq.x, 2), nsmall =2)))
  } else{
    topbar_df = as.data.frame(table(data[[col]]))
  }



  ##the top bar chart
  topbar  = ggplot(topbar_df, aes(x=Var1, y =Freq))+
    geom_bar(stat = "identity", fill = bar_colour)+
    theme_minimal()+
    theme(axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.position="none",
          plot.margin = margin(0, 0, 0, 0, "pt"))+
    scale_y_continuous(labels = barscales)+
    ylab(unit)

  ##the third layer of transforming data for right hand side column chart
  if(!is.na(outcome)){
    columnchart_df = as.data.frame(table(data[[row]]))
    coloutcome= data %>% filter(data[[outcome]] == levels(data[[outcome]])[1])
    coloutcome= as.data.frame(table(coloutcome[[row]]))
    columnchart_df = left_join(columnchart_df, coloutcome, by="Var1") %>%
      mutate(Freq = as.numeric(format(round(Freq.y/Freq.x, 2), nsmall =2)))

  } else{
    columnchart_df = as.data.frame(table(data[[row]]))
  }

  ##the right hand side column chart
  columnchart  = ggplot(columnchart_df, aes(x=Var1, y =Freq))+
    geom_bar(stat = "identity", fill = bar_colour)+
    theme_minimal()+
    coord_flip()+
    theme(axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.position="none",
          plot.margin = margin(0, 0, 0, 0, "pt"))+
    scale_y_continuous(labels = barscales)+
    ylab(unit)



  ##the fourth layer of making an empty plot for the top right hand corner
  empty_plot = ggplot(columnchart_df, aes(x=Var1, y =Freq))+
    geom_blank()+
    theme_minimal()+
    coord_flip()+
    theme(axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.position="none")

  ##stick all the graph together
  inequality_matrix = ggarrange(topbar, empty_plot, heatmap, columnchart,
            ncol=2, nrow =2,
            widths = c(3,1),
            heights = c(1,3))

  return(inequality_matrix)
}



######////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#' Making a heatmap with bar charts on the top and right on aggregated level data
#'
#' @param data   user supplied data
#' @param col    user defined column
#' @param row    user defined row
#' @param value  user defined value
#' @param coln   user customise column name
#' @param rown   user customise row name
#' @param unit   user can define unit if supplied, otherwise unit will be count as always unless Percent argument is given T, then unit wil be Percentaage automatically
#' @param percent To allow the graph to display as percentage of total, the default dispaly is number
#' @param colour user defined colour for the graph
# Add returning value description and tag
#' @returns A graph
# Export this function
#' @export


Ineq_aggregated_level_heatmap = function(data, #user supplied data
                                         col,  #user defined column
                                         row, #user defined row
                                         value, #user defined column as the value
                                         coln, #user customise column name
                                         rown, #user customise row name
                                         unit=NULL, #user defined unit
                                         percent =F,
                                         colour = "blue" ){ #user defined colour for the graph

  ##the first layer of  heatmap
  if(percent %in% c(T, TRUE)){
    data[[value]] = round((data[[value]] / sum(data[[value]])) * 100, 2)
  }else {
    data[[value]]
  }



  ##define threshold for geom text label
  threshold = stats::quantile(data[[value]], probs = 0.99) ##to make the label white for greatest value


  ##define quantiles for the colour scale
  colour_quantiles = stats::quantile(data[[value]], probs = c(0, 0.25, 0.5, 0.75, 1))

  ## Define color palette based on user input
  if(tolower(colour) == "red"){
    heatmap_colour = grDevices::colorRampPalette(c('#FFFFFF', '#FFB3C1', '#FF4D6D', '#A4133C', '#590D22'))(100) #https://coolors.co/palette/590d22-800f2f-a4133c-c9184a-ff4d6d-ff758f-ff8fa3-ffb3c1-ffccd5-fff0f3
    bar_colour = "#A4133C"
  } else if (tolower(colour) == "green"){
    heatmap_colour = grDevices::colorRampPalette(c('#FFFFFF', '#A3B18A', '#588157', '#3A5A40', '#344E41'))(100) #https://coolors.co/palette/dad7cd-a3b18a-588157-3a5a40-344e41
    bar_colour = "#3A5A40"
  } else {
    heatmap_colour = grDevices::colorRampPalette(c('#FFFFFF', '#BFD7ED', '#60A3D9', '#0074B7', '#003B73'))(100) #this is a default blue https://www.canva.com/colors/color-palettes/speckled-eggs/
    bar_colour = "#0074B7"
  }

  ##To include percentage sign for the heatmap text label and the bar and column scales into percentage
  if(percent %in% c(T, TRUE)){
    heatmap_label = paste0(data[[value]], "%")
    barscales = scales::percent_format()
  } else{
    heatmap_label = data[[value]]
    barscales = scales::label_number()}


  ##the heatmap plot
  heatmap = ggplot2::ggplot(data, ggplot2::aes(data[[col]], data[[row]], fill=data[[value]]))+
    ggplot2::geom_tile( colour="White")+
    ggplot2::scale_fill_gradientn(colours = heatmap_colour,
                                  breaks = colour_quantiles)+
    ggplot2::geom_text(ggplot2::aes(x=data[[col]], y=data[[row]], label=heatmap_label),color = ifelse(data[[value]]>threshold, "white","black"),
                       size = 3)+
    ggplot2::theme_minimal()+
    ggplot2::theme(
      legend.position="none")+
    ggplot2::xlab({{coln}})+
    ggplot2::ylab({{rown}})


  ##Handle unit display
  if (!is.null(unit)) { #this check if user has supplied a unit, If they have,
    # Use the user-supplied unit
  } else {  #If not
    if (percent %in% c(T, TRUE)) {  #determine the unit based on the Percent parameter.
      unit = "Percentage"
    } else {
      unit = "Count"
    }
  }


  ##the second layer of transforming data for the upper bar chart
  if(percent %in% c(T, TRUE)){
    topbar_df = data %>%
      dplyr::select({{ col }}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{ col }})) %>% ##use !!sym to ensure {{ }} is properly evaluated as a column name
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))  ##use !!sym to ensure {{ }} is properly evaluated as a column name
    topbar_df$Freq = round((topbar_df$Freq / sum(topbar_df$Freq)), 2)
  }else{
    topbar_df = data %>%
      dplyr::select({{ col }}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{ col }})) %>% ##use !!sym to ensure {{ }} is properly evaluated as a column name
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))  ##use !!sym to ensure {{ }} is properly evaluated as a column name
  }


  ##the top bar chart
  topbar  = ggplot2::ggplot(topbar_df, ggplot2::aes(!!dplyr::sym({{ col }}), y =Freq))+
    ggplot2::geom_bar(stat = "identity", fill = bar_colour)+
    ggplot2::theme_minimal()+
    ggplot2::theme(axis.text.x = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   legend.position="none")+
    ggplot2::scale_y_continuous(labels = barscales)+
    ggplot2::ylab({{unit}})

  ##the third layer of transforming data for right hand side column chart
  if(percent %in% c(T, TRUE)){
    columnchart_df = data %>% dplyr::select({{ row }}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{ row }})) %>%
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))
    columnchart_df$Freq = round((columnchart_df$Freq / sum(columnchart_df$Freq)), 2)
  }else{
    columnchart_df = data %>% dplyr::select({{ row }}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{ row }})) %>%
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))
  }

  ##the right hand side column chart
  columnchart  = ggplot2::ggplot(columnchart_df, ggplot2::aes(!!dplyr::sym({{ row }}), y =Freq))+
    ggplot2::geom_bar(stat = "identity", fill = bar_colour)+
    ggplot2::scale_y_continuous(labels = scales::number_format())+   #turns off scientific notation
    ggplot2::theme_minimal()+
    ggplot2::coord_flip()+
    ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   legend.position="none")+
    ggplot2::scale_y_continuous(labels = barscales)+
    ggplot2::ylab({{unit}})



  ##the fourth layer of making an empty plot for the top right hand corner
  empty_plot = ggplot2::ggplot(columnchart_df, ggplot2::aes(!!dplyr::sym({{ row }}), y =Freq))+
    ggplot2::geom_blank()+
    ggplot2::theme_minimal()+
    ggplot2::coord_flip()+
    ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   legend.position="none")

  ##stick all the graph together
  inequality_matrix = egg::ggarrange(topbar, empty_plot, heatmap, columnchart,
                                     ncol=2, nrow =2,
                                     widths = c(3,1),
                                     heights = c(1,3))


  return(inequality_matrix)

}


######////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#' Making a heatmap with bar charts on the top and right on mulitdimensional data
#'
#' @param data   user supplied data
#' @param col    user defined column
#' @param row    user defined row
#' @param value  user defined value
#' @param coln   user customise column name
#' @param rown   user customise row name
#' @param unit   user defined unit
#'@param percent To allow the graph to display as percentage of total, the default dispaly is number
#' @param colour user defined colour for the graph
# Add returning value description and tag
#' @returns A graph
# Export this function
#' @export


Ineq_multidi_level_heatmap = function(data, #user supplied data
                                      col,  #user defined column
                                      row,  #user defined row
                                      value, #user defined column as the value
                                      coln, #user customise column name
                                      rown, #user customise row name
                                      unit=NULL, #user defined unit
                                      percent=F,
                                      colour = "blue" ){ #user defined colour for the graph

  ##the first layer of transforming data for heatmap
  if(percent %in% c(T, TRUE)){
  heatmap_df = data %>% dplyr::select({{ col }}, {{row}}, {{ value }}) %>%
    dplyr::group_by(!!dplyr::sym({{col}}), !!dplyr::sym({{row}})) %>%
    dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))
  heatmap_df$Freq = round((heatmap_df$Freq/sum(heatmap_df$Freq)*100), 2)
  }else{
    heatmap_df = data %>% dplyr::select({{ col }}, {{row}}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{col}}), !!dplyr::sym({{row}})) %>%
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))
  }

  ##define threshold for geom text label
  threshold = stats::quantile(heatmap_df$Freq, probs = 0.99) ##to make the label white for greatest value


  ##define quantiles for the colour scale
  colour_quantiles = stats::quantile(heatmap_df$Freq, probs = c(0, 0.25, 0.5, 0.75, 1))

  ## Define color palette based on user input
  if(tolower(colour) == "red"){
    heatmap_colour = grDevices::colorRampPalette(c('#FFFFFF', '#FFB3C1', '#FF4D6D', '#A4133C', '#590D22'))(100) #https://coolors.co/palette/590d22-800f2f-a4133c-c9184a-ff4d6d-ff758f-ff8fa3-ffb3c1-ffccd5-fff0f3
    bar_colour = "#A4133C"
  } else if (tolower(colour) == "green"){
    heatmap_colour = grDevices::colorRampPalette(c('#FFFFFF', '#A3B18A', '#588157', '#3A5A40', '#344E41'))(100) #https://coolors.co/palette/dad7cd-a3b18a-588157-3a5a40-344e41
    bar_colour = "#3A5A40"
  } else {
    heatmap_colour = grDevices::colorRampPalette(c('#FFFFFF', '#BFD7ED', '#60A3D9', '#0074B7', '#003B73'))(100) #this is a default blue https://www.canva.com/colors/color-palettes/speckled-eggs/
    bar_colour = "#0074B7"
  }


  ##To include percentage sign for the heatmap text label and the bar and column scales into percentage
  if(percent %in% c(T, TRUE)){
    heatmap_label = paste0(heatmap_df$Freq, "%")
    barscales = scales::percent_format()
  } else{
    heatmap_label = heatmap_df$Freq
    barscales = scales::label_number()}



  ##the heatmap plot
  heatmap = ggplot2::ggplot(heatmap_df, ggplot2::aes(heatmap_df[[col]], heatmap_df[[row]], fill=Freq))+
    ggplot2::geom_tile( colour="White")+
    ggplot2::scale_fill_gradientn(colours = heatmap_colour,
                                  breaks = colour_quantiles)+
    ggplot2::geom_text(ggplot2::aes(x=heatmap_df[[col]], y=heatmap_df[[row]], label=heatmap_label),color = ifelse(heatmap_df$Freq>threshold, "white","black"),
                       size = 3)+
    ggplot2::theme_minimal()+
    ggplot2::theme(
      legend.position="none")+
    ggplot2::xlab({{coln}})+
    ggplot2::ylab({{rown}})


  ##Handle unit display
  if (!is.null(unit)) { #this check if user has supplied a unit, If they have,
    # Use the user-supplied unit
  } else {  #If not
    if (percent %in% c(T, TRUE)) {  #determine the unit based on the Percent parameter.
      unit = "Percentage"
    } else {
      unit = "Count"
    }
  }


  ##the second layer of transforming data for the upper bar chart
  if(percent %in% c(T, TRUE)){
  topbar_df = data %>%
    dplyr::select({{ col }}, {{ value }}) %>%
    dplyr::group_by(!!dplyr::sym({{ col }})) %>% ##use !!sym to ensure {{ }} is properly evaluated as a column name
    dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))  ##use !!sym to ensure {{ }} is properly evaluated as a column name
  topbar_df$Freq = round((topbar_df$Freq/sum(topbar_df$Freq)), 2)
  }else{
    topbar_df = data %>%
      dplyr::select({{ col }}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{ col }})) %>% ##use !!sym to ensure {{ }} is properly evaluated as a column name
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))  ##use !!sym to ensure {{ }} is properly evaluated as a column name
  }


  ##the top bar chart
  topbar  = ggplot2::ggplot(topbar_df, ggplot2::aes(topbar_df[[col]], y =topbar_df$Freq))+
    ggplot2::geom_bar(stat = "identity", fill = bar_colour)+
    ggplot2::theme_minimal()+
    ggplot2::theme(axis.text.x = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   legend.position="none")+
    ggplot2::scale_y_continuous(labels = barscales)+
    ggplot2::ylab({{unit}})

  ##the third layer of transforming data for right hand side column chart
  if(percent %in% c(T, TRUE)){
    columnchart_df = data %>% dplyr::select({{ row }}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{ row }})) %>%
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))
    columnchart_df$Freq = round((columnchart_df$Freq/sum(columnchart_df$Freq)), 2)
  }else{
    columnchart_df = data %>% dplyr::select({{ row }}, {{ value }}) %>%
      dplyr::group_by(!!dplyr::sym({{ row }})) %>%
      dplyr::summarise(Freq = sum(!!dplyr::sym({{value}}), na.rm = TRUE))
  }

  ##the right hand side column chart
  columnchart  = ggplot2::ggplot(columnchart_df, ggplot2::aes(columnchart_df[[row]], y = columnchart_df$Freq))+
    ggplot2::geom_bar(stat = "identity", fill = bar_colour)+
    ggplot2::scale_y_continuous(labels = scales::number_format())+   #turns off scientific notation
    ggplot2::theme_minimal()+
    ggplot2::coord_flip()+
    ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   legend.position="none")+
    ggplot2::scale_y_continuous(labels = barscales)+
    ggplot2::ylab({{unit}})

  ##the fourth layer of making an empty plot for the top right hand corner
  empty_plot = ggplot2::ggplot(columnchart_df, ggplot2::aes(columnchart_df[[row]], y = columnchart_df$Freq))+
    ggplot2::geom_blank()+
    ggplot2::theme_minimal()+
    ggplot2::coord_flip()+
    ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   legend.position="none")

  ##stick all the graph together
  inequality_matrix = egg::ggarrange(topbar, empty_plot, heatmap, columnchart,
                                     ncol=2, nrow =2,
                                     widths = c(3,1),
                                     heights = c(1,3))


  return(inequality_matrix)

}

