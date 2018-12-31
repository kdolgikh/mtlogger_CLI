function [temp]=convert_temp_to_res (temp, rt_data)
    
    y = rt_data(1:end,2); % resistance
    x = rt_data(1:end,1); % temperature
    temp=interp1(x,y,temp,'pchip'); % interpolated temperature values

end