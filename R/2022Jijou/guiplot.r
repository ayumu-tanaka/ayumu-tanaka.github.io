ggplot() +
geom_line(data=pwt1950,aes(x=year,y=percapitaGDP,group=countrycode,color=countrycode))+
geom_point(data=pwt1950,aes(x=year,y=percapitaGDP,group=countrycode,color=countrycode))+
theme_gray()