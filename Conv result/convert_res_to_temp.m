function [temp]=convert_res_to_temp (rt, rt_data)
    
    y = rt_data(1:end,2); % resistance
    x = rt_data(1:end,1); % temperature
    temp=interp1(y,x,rt,'pchip'); % interpolated temperature values

end