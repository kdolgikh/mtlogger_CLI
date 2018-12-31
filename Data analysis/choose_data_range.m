function [ind_start,ind_end] = choose_data_range (time, start_time, stop_time)
% Function that allows to save only the data range of interest

    ind_start = find(time == start_time);
    ind_end = find(time == stop_time);
    
end