library(tidyverse)

#install.packages("hexSticker")
library(hexSticker)

imgurl <- "book.png"
sticker(imgurl, package="hexSticker", p_size=8, s_x=1, s_y=.75, s_width=.6,
        filename="imgfile.png")

#install.packages("showtext")
library(showtext)
## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Gochi Hand", "gochi")
## Automatically use showtext to render text for future devices
showtext_auto()

imgurl <- "test1.png"
sticker(imgurl, package="bibliographeR", p_size=22, p_y = 1.35, 
        s_x=1, s_y=1, s_width=1.9,
        h_color="#88398a",
        p_family = "gochi", 
        filename="test.png")
#p_family = "gochi", 


imgurl <- "graphTest.png"
sticker(imgurl, package="bibliographeR", p_size=22, p_y = 1, 
        s_x=1, s_y=1, s_width=1,
        h_color="#88398a",
        p_family = "gochi", 
        filename="test.png")

imgurl <- "graphTest2.png"
sticker(imgurl, package="bibliographeR", p_size=22, p_y = 1.35, 
        h_size = 1.8,s_x=1, s_y=1, s_width=1,
        h_color="#88398a",
        p_family = "gochi", 
        filename="test2.png",
        white_around_sticker = TRUE)


