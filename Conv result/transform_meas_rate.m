function [Day,Hour,Min,Sec] = transform_meas_rate(meas_rate)

% Transforms measurement rate in seconds into day-hour-min-sec format
    seconds_min = 60;
    seconds_hour = 3600;
    seconds_day = 86400; 
    
    Day = fix(meas_rate/seconds_day); % number of full days
    part_day = rem(meas_rate,seconds_day);
    
    Hour = fix(part_day/seconds_hour); % value greater than 0 indicates partial day
    part_hour = rem(part_day,seconds_hour);
    
    Min = fix(part_hour/seconds_min);
    Sec = rem(part_hour,seconds_min);

end

