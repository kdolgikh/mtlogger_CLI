function analyse_logger_data(data,skip_disp)

    data_avg = mean(data,'omitnan');
    data_max = max(data,[],'omitnan');
    data_min = min(data,[],'omitnan');
    data_range = data_max - data_min;
    data_std = std(data,'omitnan');
    % data_var = var(data,'omitnan');

    if (~skip_disp)
        disp(['Average data:       ',num2str(data_avg)]);
        disp(['Max data:           ',num2str(data_max)]);
        disp(['Min data:           ',num2str(data_min)]);
        disp(['Data range:         ',num2str(data_range)]);
        disp(['Data std deviation: ',num2str(data_std)]);
    %     disp(['data variance:      ',num2str(data_var)]);
    end

end