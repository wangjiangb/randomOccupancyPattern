function integral = integral_from_image(image)
    sub_depth = image;
    integral = zeros(size(sub_depth));    
    c3 = integral;
    for y= 1:size(sub_depth,1)        
        for x = 1:size(sub_depth, 2)
            if (x>1)
                c1(y, x)  = c1(y,x-1) +  image(y,x);
            else
                c1(y, x)  =  image(y,x);
            end                  
            if (y>1)
                integral(y, x) = integral(y-1 , x)+c1(y,x);
            else
                integral(y, x) = c1(y,x);                        
            end
        end       
    end
end