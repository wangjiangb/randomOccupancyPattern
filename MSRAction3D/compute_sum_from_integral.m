function blocks_sum = compute_sum_from_integral(integral, higher_y, lower_y, higher_x, lower_x)
 blocks_sum =  integral_zero(integral, higher_y,higher_x)...
                      -integral_zero(integral,lower_y,higher_x)...
                      -integral_zero(integral,higher_y,lower_x)...
                      +integral_zero(integral, lower_y,lower_x);
end

function out = integral_zero(integral, y,x)
  if (y==0 || x==0 )
      out = 0;
  else
      out = integral(y,x);
  end
end