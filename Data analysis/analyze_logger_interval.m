function [f_number,metrics_temp,metrics_volt,ts] = analyze_logger_interval(num_channels, temp_data, voltage_data, time_stamp, f_number,logger_id)

    f_number=f_number+1;
    prompt = strcat({'For "'},logger_id,{'" type the start time in the format yyyy-MM-dd HH:mm:ss\n#'});
    user_input = input(char(prompt),'s');
    start=datetime(user_input,'InputFormat','yyyy-MM-dd HH:mm:ss');

    prompt = strcat({'For "'},logger_id,{'" type the stop time in the format yyyy-MM-dd HH:mm:ss\n#'});
    user_input = input(char(prompt),'s');
    stop=datetime(user_input,'InputFormat','yyyy-MM-dd HH:mm:ss');

    [ind_start,ind_stop] = choose_data_range(time_stamp,start,stop);
    
    data = zeros(num_channels,(ind_stop + 1 - ind_start));
    for i=1:num_channels
        data(i,1:end) = temp_data(i,ind_start:ind_stop);
    end
    
    voltage = zeros(num_channels,(ind_stop + 1 - ind_start));
    for i=1:num_channels
        voltage(i,1:end) = voltage_data(i,ind_start:ind_stop);
    end
    
    ts = time_stamp(ind_start:ind_stop);

    [f_number, not_outliers] = plot_logger_channel(num_channels,data,voltage,ts,f_number,logger_id);

    disp('Temperature metrics:');
    metrics_temp = analyse_logger_data_all_ch(not_outliers,data,0);
    disp('Voltage metrics:');
    metrics_volt = analyse_logger_data_all_ch(not_outliers,voltage,0);

    TimeStamp = datestr(datetime(clock),'yymmddTHHMM');
    FileNameDevice = strcat(TimeStamp,'_',logger_id);
    save(strcat(FileNameDevice,'_ts_int.mat'),'ts'); 
    save(strcat(FileNameDevice,'_temp_int.mat'),'data');
    save(strcat(FileNameDevice,'_volt_int.mat'),'voltage'); 
    save(strcat(FileNameDevice,'_metrics_temp_int.mat'),'metrics_temp');
    save(strcat(FileNameDevice,'_metrics_volt_int.mat'),'metrics_volt');       
end