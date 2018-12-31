function [temperature,voltage,Rth] = PresentConvResult(num_meas,num_channels,meas_result,ts,op_mode)

    global is_nice;
    global fig_number;
    fig_number = 1;
    
    ch_num_array = 1:num_channels;
    
    prompt = '#Type the name of the thermistor calibration file\n#';
    user_input = input(prompt,'s');
    therm_rt_data = load(user_input);
    
    % "Nice" board will have additional calibration factor(mux Ron)
    accepted_value = 1;
    while(accepted_value)
        prompt = '#Is "Nice"? y/n\n#';
        nice = input(prompt,'s');
        if strcmp(nice,'y')
            is_nice = 1;
            accepted_value = 0;
        else
            if strcmp(nice,'n')
                is_nice = 0;
                accepted_value = 0;
            else
            disp('#Error. Type either "y" or "n"');
            end
        end
    end
    
    accepted_value = 1;
    while(accepted_value)
        prompt = '#Skip saving individual channels data? y/n\n#';
        skip = input(prompt,'s');
        if strcmp(skip,'y')
            skip_saving = 1;
            accepted_value = 0;
        else
            if strcmp(skip,'n')
                skip_saving = 0;
                accepted_value = 0;
            else
            disp('#Error. Type either "y" or "n"');
            end
        end
    end
    
    temperature=zeros(num_channels,num_meas);
    voltage=zeros(num_channels,num_meas);
    Rth=zeros(num_channels,num_meas);
    exit=0;
    while(~exit)
        prompt = '#Enter "1 to 16" to choose channel, "all" for all channels or "stop" to return\n#';
        user_input = input(prompt,'s');
        if strcmp(user_input,'all')
            
            prompt = '#Use plot(p) or scatter(s)?\n#';
            sop = input(prompt,'s');
            if strcmp(sop,'p')
                is_plot = 1;
            else
                is_plot = 0;
            end
            
            for i=1:num_channels
                [temperature(i,1:end), voltage(i,1:end), Rth(i,1:end)] = ...
                    ProcessConvResult(meas_result(i,1:end),i,therm_rt_data,ts,1,skip_saving,op_mode);
            end
            
            legend_val=[];
            for i=1:length(ch_num_array)
                legend_val_next = strcat("Ch ",num2str(ch_num_array(i)));
                legend_val = [legend_val, legend_val_next];
            end
            
            prompt = '#Plot measured voltage y/n?\n#';
            ui_v = input(prompt,'s');
            if strcmp(ui_v,'y')
                figure(fig_number)
                if is_plot
                    plot(ts,voltage);
                else
                    for i=1:num_channels
                        hold on
                        scatter(ts,voltage(i,1:end));
                        hold off
                    end
                end
                title 'Measured thermistor voltage for all channels'
                xlabel 'Time'; ylabel 'Thermistor voltage, V';
                legend(legend_val,'Location','eastoutside');
                axis tight
                fig_number = fig_number + 1;
                
                prompt = '#Show statistics for voltage data y/n?\n#';
                ui_s = input(prompt,'s');
                if strcmp(ui_s,'y')
                    analyse_logger_data_all_ch(ch_num_array,voltage,0);
                end
            end
            
            prompt = '#Plot thermistor resistance y/n?\n#';
            ui_r = input(prompt,'s');
            if strcmp(ui_r,'y')
                figure(fig_number)
                if is_plot
                    plot(ts,Rth);
                else
                    for i=1:num_channels
                        hold on
                        scatter(ts,Rth(i,1:end));
                        hold off
                    end
                end
                title 'Measured thermistor resistance for all channels'
                xlabel 'Time'; ylabel 'Thermistor resistance, Ohm';
                legend(legend_val,'Location','eastoutside');
                axis tight
                fig_number = fig_number + 1;  
                
                prompt = '#Show statistics for resistance data y/n?\n#';
                ui_s = input(prompt,'s');
                if strcmp(ui_s,'y')
                    analyse_logger_data_all_ch(ch_num_array,Rth,0);
                end
            end
            
            prompt = '#Plot thermistor temperature y/n?\n#';
            ui_t = input(prompt,'s');
            if strcmp(ui_t,'y')
                figure(fig_number)   
                if is_plot
                    plot(ts,temperature);
                else
                    for i=1:num_channels
                        hold on
                        scatter(ts,temperature(i,1:end));
                        hold off
                    end
                end
                title 'Measured temperature for all channels'
                xlabel 'Time'; ylabel 'Temperature, C';
                legend(legend_val,'Location','eastoutside');
                axis tight
                fig_number = fig_number + 1; 
                
                prompt = '#Show statistics for temperature data y/n?\n#';
                ui_s = input(prompt,'s');
                if strcmp(ui_s,'y')
                    analyse_logger_data_all_ch(ch_num_array,temperature,0);
                end
            end
              
        else
            if find(ch_num_array==str2double(user_input))
                ch_num = str2double(user_input);
                ProcessConvResult(meas_result(ch_num,1:end),ch_num,therm_rt_data,ts,0,skip_saving,op_mode);  
            else
                if strcmp(user_input,'stop')
                    exit = 1;
                else
                    disp('#Entered channel number is invalid. Valid values are "1 - 16"');
                end
            end
        end
    end

end