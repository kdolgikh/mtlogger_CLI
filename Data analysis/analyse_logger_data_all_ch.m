function [metrics]=analyse_logger_data_all_ch(not_outliers,data,skip_display)
% Function analyses data from all channels of the logger
    
   metrics = struct('max_max',0,...     % max value for all ch
                     'min_min',0,...    % min value for all ch
                     'range_max',0,...  % range for all ch
                     'max_avg',0,...    % max among avg values for individual channels
                     'min_avg',0,...    % min among avg values for individual channels
                     'max_std',0,...    % max among std values for all channels
                     'min_std',0,...    % min among std values for all channels
                     'all_ch_avg',length(data));

                 
    data_avg = zeros(1,length(not_outliers));
    data_max = zeros(1,length(not_outliers));
    data_min = zeros(1,length(not_outliers));
    data_range = zeros(1,length(not_outliers));
    data_std = zeros(1,length(not_outliers));

    for i=not_outliers
        data_avg(i) = mean(data(i,1:end),'omitnan');
        data_max(i) = max(data(i,1:end),[],'omitnan');
        data_min(i) = min(data(i,1:end),[],'omitnan');
        data_range(i) = data_max(i) - data_min(i);
        data_std(i) = std(data(i,1:end),'omitnan');
    end
    
    metrics.max_max = max(data_max(not_outliers));    % max data for all ch
    metrics.min_min = min(data_min(not_outliers));    % min data for all ch
    metrics.range_max = metrics.max_max - metrics.min_min;
    metrics.max_avg = max(data_avg(not_outliers));    % max avg for all ch
    metrics.min_avg = min(data_avg(not_outliers));    % min avg for all ch
    metrics.max_std = max(data_std(not_outliers));    % max std for all ch
    metrics.min_std = min(data_std(not_outliers));    % min std for all ch
    
    % average value of all channels for each individual measurement
    for i = 1:length(data(1,1:end))
        metrics.all_ch_avg(i) = mean(data(not_outliers(1:end),i));
    end
    
    if (~skip_display)
        disp(['Max value for all channels:            ',num2str(metrics.max_max)]);
        disp(['Min value for all channels:            ',num2str(metrics.min_min)]);
        disp(['Range for all channels:                ',num2str(metrics.range_max)]);
        disp(['Max avg value for all channels:        ',num2str(metrics.max_avg)]);
        disp(['Min avg value for all channels:        ',num2str(metrics.min_avg)]);
        disp(['Max std deviation for all channels:    ',num2str(metrics.max_std)]);
        disp(['Min std deviation for all channels:    ',num2str(metrics.min_std)]);
    end
    
end