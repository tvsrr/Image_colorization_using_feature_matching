function IntegralImage = Integral_Image(Img)

IntegralImage = cumsum(cumsum(Img,1),2);

end