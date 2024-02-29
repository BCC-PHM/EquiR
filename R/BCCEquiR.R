`%>%` = dplyr::`%>%`


#' Making a heatmap with bar charts on the top and right on record level data
#'
#' @param data   user supplied data
#' @param col    user defined column
#' @param row    user defined row
#' @param coln   user customise column name
#' @param rown   user customise row name
#' @param unit   user defined unit
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
                                     unit,
                                     colour = "blue" ){

  ##the first layer of transforming data for heatmap
  heatmap_df = as.data.frame(table(data[[col]], data[[row]]))

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


  ##the heatmap plot
  heatmap = ggplot2::ggplot(heatmap_df, ggplot2::aes(Var1, Var2, fill=Freq))+
    ggplot2::geom_tile( colour="White")+
    ggplot2::scale_fill_gradientn(colours = heatmap_colour,
                         breaks = colour_quantiles)+
    ggplot2::geom_text(ggplot2::aes(x=Var1, y=Var2, label=Freq),color = ifelse(heatmap_df$Freq>threshold, "white","black"),
              size = 3)+
    ggplot2::theme_minimal()+
    ggplot2::theme(
      legend.position="none")+
    ggplot2::xlab({{coln}})+
    ggplot2::ylab({{rown}})

  ##the second layer of transforming data for the upper bar chart
  topbar_df = as.data.frame(table(data[[col]]))

  ##the top bar chart
  topbar  = ggplot2::ggplot(topbar_df, ggplot2::aes(x=Var1, y =Freq))+
    ggplot2::geom_bar(stat = "identity", fill = bar_colour)+
    ggplot2::theme_minimal()+
    ggplot2::theme(axis.text.x = ggplot2::element_blank(),
          axis.title.x = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
          panel.background = ggplot2::element_blank(),
          legend.position="none")+
    ggplot2::ylab({{unit}})

  ##the third layer of transforming data for right hand side column chart
  columnchart_df = as.data.frame(table(data[[row]]))

  ##the right hand side column chart
  columnchart  = ggplot2::ggplot(columnchart_df, ggplot2::aes(x=Var1, y =Freq))+
    ggplot2::geom_bar(stat = "identity", fill = bar_colour)+
    ggplot2::theme_minimal()+
    ggplot2::coord_flip()+
    ggplot2::theme(axis.text.y = ggplot2::element_blank(),
          axis.title.y = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
          panel.background = ggplot2::element_blank(),
          legend.position="none")+
    ggplot2::ylab({{unit}})



  ##the fourth layer of making an empty plot for the top right hand corner
  empty_plot = ggplot2::ggplot(columnchart_df, ggplot2::aes(x=Var1, y =Freq))+
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




