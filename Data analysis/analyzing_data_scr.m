clear
clc

f=0;    % figure number

loggers = struct('device',0,'cr1000',0,'hobo',0);
prompt = '#Analyze data for the device? y/n\n#';
user_input = input(prompt,'s');
if strcmp(user_input,'y')
    loggers.device = 1;
end

prompt = '#Analyze data for CR1000? y/n\n#';
user_input = input(prompt,'s');
if strcmp(user_input,'y')
    loggers.cr1000 = 1;
end

prompt = '#Analyze data for Hobo? y/n\n#';
user_input = input(prompt,'s');
if strcmp(user_input,'y')
    loggers.hobo = 1;
end

prompt = '#Enter meas rate\n#';
user_input = input(prompt,'s');
meas_rate = str2double(user_input);

%% get the device data
if loggers.device
    prompt = '#Enter number of channels for the device\n#';
    user_input = input(prompt,'s');
    num_channels_device = str2double(user_input);

    % e.g. 180204T1354_All_Ch_DR10_temp.txt
    prompt = '#Type the name of the data file for the device\n#';
    user_input = input(prompt,'s');
    temp_device = load(user_input);
    
    prompt = '#Type the name of the voltage file for the device\n#';
    user_input = input(prompt,'s');
    volt_device = load(user_input);

    % e.g. 180204T1354_All_Ch_DR10_ts.mat
    prompt = '#Type the name of the time stamp file for the device\n#';
    user_input = input(prompt,'s');
    ts_struct=load(user_input);
    ts_device=ts_struct.ts;

    f = plot_logger_channel(num_channels_device,temp_device,volt_device,ts_device,f,'device');     
end 

%% get CR1000 data
if loggers.cr1000
    % get temperature data
    % add option to choose data file
    prompt = '#Enter number of channels for CR1000\n#';
    user_input = input(prompt,'s');
    num_channels_cr1000 = str2double(user_input);

    % e.g. CR1000_5h_sim.dat
    prompt = '#Type the name of the data file for CR1000\n#';
    user_input = input(prompt,'s');
    temp_cr1000 = load(user_input);
    temp_cr1000 = transpose(temp_cr1000(1:end,4:end)); % data starts from column 4

    volt_cr1000 = zeros(num_channels_cr1000,length(temp_cr1000));
    
    % get time stamp for measurement
    % time_stamp_file: 'CR1000_5h_sim_mod.txt'
    prompt = '#Type the name of the time stamp file for CR1000\n#';
    user_input = input(prompt,'s');
    t_str=fileread(user_input);

    % CR1000 saves timestamp in the following format:
    % 19 chars for data and 2 chars for formatting (new line and something else)
    % This gives 21 chars total. The last string doesn't have formatting chars,
    % that's why in while loop below there's -2
    i = 1; j=1;
    while i <= 21*length(temp_cr1000)-2
        ts_cr1000(j) = datetime(t_str(i:(i+18)),'InputFormat','yyyy-MM-dd HH:mm:ss');
        i=i+21;
        j=j+1;
    end

    save('ts_cr1000.mat','ts_cr1000');
    save('temp_cr1000.mat','temp_cr1000');
    
    f = plot_logger_channel(num_channels_cr1000,temp_cr1000,volt_cr1000,ts_cr1000,f,'cr1000'); % no voltage data
end

%% get Hobo-U12 data
if loggers.hobo
    prompt = '#Enter number of channels for Hobo\n#';
    user_input = input(prompt,'s');
    num_channels_hobo = str2double(user_input);

    prompt = '#Type the name of the data file for Hobo\n#';
    user_input = input(prompt,'s');
    temp_hobo = load(user_input);
    temp_hobo = transpose(temp_hobo(1:end,4:end)); % data starts from column 4

    volt_hobo = zeros(num_channels_hobo,length(temp_hobo));
    
    prompt = '#Lost time stamp? y/n\n#';
    user_input = input(prompt,'s');
    if strcmp(user_input,'y')
        ts_hobo_start = datetime(2018,02,02,18,00,00);
        ts_hobo_stop = ts_hobo_start + (length(temp_hobo)-1)*seconds(meas_rate);
        ts_hobo = ts_hobo_start:seconds(meas_rate):ts_hobo_stop;
    else
        prompt = '#Type the name of the time stamp file for Hobo\n#';
        user_input = input(prompt,'s');
        t_str=fileread(user_input);
    end
    
    % time stamp string consist of 22 chars plus 2 formatting chars (total
    % 24 chars)
    i = 1; j=1;
    while i <= 24*length(temp_hobo)-2
        ts_hobo(j) = datetime(t_str(i:(i+21)),'InputFormat','yyyy-MM-dd hh:mm:ss a');
        i=i+24;
        j=j+1;
    end
    
    f = plot_logger_channel(num_channels_hobo,temp_hobo,volt_hobo,ts_hobo,f,'hobo'); % no voltage data
end
    
%% compare performance of two or three devices
if loggers.device && loggers.cr1000 && loggers.hobo
        prompt = '#Choose interval for futher analysis? y/n\n#';
        ci = input(prompt,'s');
        if strcmp(ci,'y')
            another_interval = 1;
            while another_interval
                [f,metrics_temp_device,metrics_volt_device,ts_device_int] = analyze_logger_interval(num_channels_device,temp_device,volt_device,ts_device,f,'device');
                [f,metrics_temp_cr1000,metrics_volt_cr1000,ts_cr1000_int] = analyze_logger_interval(num_channels_cr1000,temp_cr1000,volt_cr1000,ts_cr1000,f,'cr1000');
                [f,metrics_temp_hobo,metrics_volt_hobo,ts_hobo_int] = analyze_logger_interval(num_channels_hobo,temp_hobo,volt_hobo,ts_hobo,f,'hobo');
                figure(f+1)
                fig = plot(ts_device_int,metrics_temp_device.all_ch_avg,...
                            ts_cr1000_int,metrics_temp_cr1000.all_ch_avg,...
                            ts_hobo_int,metrics_temp_hobo.all_ch_avg);
                title 'Average temperature of all channels';
                xlabel 'Time'; ylabel 'Temperature, C';
                legend('The Device','CR1000','HoboU12');
                prompt = '#Choose another interval? y/n\n#';
                ai = input(prompt,'s');
                if strcmp(ai,'n')
                    another_interval = 0;
                end
            end
        end
else
    if loggers.device && loggers.cr1000
        prompt = '#Choose interval for futher analysis? y/n\n#';
        ci = input(prompt,'s');
        if strcmp(ci,'y')
            another_interval = 1;
            while another_interval
                [f,metrics_temp_device,metrics_volt_device,ts_device_int] = analyze_logger_interval(num_channels_device,temp_device,volt_device,ts_device,f,'device');
                [f,metrics_temp_cr1000,metrics_volt_cr1000,ts_cr1000_int] = analyze_logger_interval(num_channels_cr1000,temp_cr1000,volt_cr1000,ts_cr1000,f,'cr1000');
                figure(f+1)
                fig = plot(ts_device_int,metrics_temp_device.all_ch_avg,...
                            ts_cr1000_int,metrics_temp_cr1000.all_ch_avg);
                title 'Average temperature of all channels';
                xlabel 'Time'; ylabel 'Temperature, C';
                legend('The Device','CR1000');
                prompt = '#Choose another interval? y/n\n#';
                ai = input(prompt,'s');
                if strcmp(ai,'n')
                    another_interval = 0;
                end
            end
        end
    else
        if loggers.device && ~loggers.cr1000 && ~loggers.hobo
            prompt = '#Choose interval for futher analysis? y/n\n#';
            ci = input(prompt,'s');
            if strcmp(ci,'y')
                another_interval = 1;
                while another_interval
                    [f,metrics_temp_device,metrics_volt_device,ts_device_int] = analyze_logger_interval(num_channels_device,temp_device,volt_device,ts_device,f,'device');
                    prompt = '#Choose another interval? y/n\n#';
                    ai = input(prompt,'s');
                    if strcmp(ai,'n')
                        another_interval = 0;
                    end
                end
            end
        else
            if ~loggers.device && loggers.cr1000 && ~loggers.hobo
                prompt = '#Choose interval for futher analysis? y/n\n#';
                ci = input(prompt,'s');
                if strcmp(ci,'y')
                    another_interval = 1;
                    while another_interval
                        [f,metrics_temp_cr1000,metrics_volt_cr1000,ts_cr1000_int] = analyze_logger_interval(num_channels_cr1000,temp_cr1000,volt_cr1000,ts_cr1000,f,'cr1000');
                        prompt = '#Choose another interval? y/n\n#';
                        ai = input(prompt,'s');
                        if strcmp(ai,'n')
                            another_interval = 0;
                        end
                    end
                end
            else
                if ~loggers.device && ~loggers.cr1000 && loggers.hobo
                    prompt = '#Choose interval for futher analysis? y/n\n#';
                    ci = input(prompt,'s');
                    if strcmp(ci,'y')
                        another_interval = 1;
                        while another_interval
                            [f,metrics_temp_hobo,metrics_volt_hobo,ts_hobo_int] = analyze_logger_interval(num_channels_hobo,temp_hobo,volt_hobo,ts_hobo,f,'hobo');
                            prompt = '#Choose another interval? y/n\n#';
                            ai = input(prompt,'s');
                            if strcmp(ai,'n')
                                another_interval = 0;
                            end
                        end
                    end
                end
            end
        end
    end
end
