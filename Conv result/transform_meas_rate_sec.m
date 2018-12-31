function [meas_rate] = transform_meas_rate_sec(Day,Hour,Min,Sec)
% Transforms measurement rate in month-day-hour-min-sec
% provided by user into seconds.
% 1 year is assumed to be of 365 days.
% 1 month is assumed to be 30 days.

    seconds_min = 60;
    seconds_hour = 3600;
    seconds_day = 86400;
    
    meas_rate = Day * seconds_day + ...
                Hour * seconds_hour + ...
                Min * seconds_min + ...
                Sec;
end

