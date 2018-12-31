function [f_number, not_outliers] = plot_logger_channel(num_channels, temp_data, voltage_data, time_stamp, f_number, logger_id)

    not_outliers = 1:num_channels;

    prompt = '#Use plot(y) or scatter(n)?\n#';
    ui_p = input(prompt,'s');
    if strcmp(ui_p,'y')
        is_plot = 1;
    else 
        is_plot = 0;
    end
    
    exit = 0;
    while ~exit
        f_number = f_number+1;
        prompt = '#Enter a channel number to plot or type "all" or "stop"\n#';
        user_input = input(prompt,'s');
        if strcmp(user_input,'stop')
            exit = 1;
            f_number = f_number - 1;
        else
            if strcmp(user_input,'all') 
                figure(f_number)
                hold on
                for k=not_outliers
                    if is_plot
                        fig = plot(time_stamp,temp_data(k,1:end));
                    else
                        fig = scatter(time_stamp,temp_data(k,1:end));
                    end
                end
                hold off
                title 'Measured temperature';
                xlabel 'Time'; ylabel 'Temperature, C';
                legend_val=[];
                for i=1:length(not_outliers)
                   legend_val_next = strcat("Ch ",num2str(not_outliers(i)));
                   legend_val = [legend_val, legend_val_next];
                end
                legend(legend_val,'Location','eastoutside');
                
                prompt = '#Set y axis limit y/n?\n#';
                ui_yl = input(prompt,'s');
                if strcmp(ui_yl,'y')
                    prompt = '#Enter the lower limit\n#';
                    yl_lower = input(prompt);
                    prompt = '#Enter the upper limit\n#';
                    yl_upper = input(prompt);
                    ylim([yl_lower yl_upper]);
                end

                prompt = '#Set x axis limit y/n?\n#';
                ui_xl = input(prompt,'s');
                if strcmp(ui_xl,'y')
                    prompt = '#Enter the lower limit in the format yyyy-MM-dd HH:mm:ss\n#';
                    ui_xl_lower = input(char(prompt),'s');
                    xl_lower=datetime(ui_xl_lower,'InputFormat','yyyy-MM-dd HH:mm:ss');
                    prompt = '#Enter the upper limit in the format yyyy-MM-dd HH:mm:ss\n#';
                    ui_xl_upper = input(char(prompt),'s');
                    xl_upper=datetime(ui_xl_upper,'InputFormat','yyyy-MM-dd HH:mm:ss');
                    xlim([xl_lower xl_upper]);
                end
                
                %saveas(fig,strcat(logger_id,'_all_ch_temp.png'));
                
                prompt = '#Plot measured voltage y/n?\n#';
                ui_v = input(prompt,'s');
                if strcmp(ui_v,'y')
                    f_number = f_number + 1;
                    figure(f_number)
                    hold on
                    for k=not_outliers
                        if is_plot
                            fig = plot(time_stamp,voltage_data(k,1:end));
                        else
                            fig = scatter(time_stamp,voltage_data(k,1:end));
                        end
                        
                    end
                    hold off
                    title 'Measured input voltage';
                    xlabel 'Time'; ylabel 'Input voltage, V';
                    axis tight
                    legend_val=[];
                    for i=1:length(not_outliers)
                       legend_val_next = strcat("Ch ",num2str(not_outliers(i)));
                       legend_val = [legend_val, legend_val_next];
                    end
                    legend(legend_val,'Location','eastoutside');
                    %saveas(fig,strcat(logger_id,'_all_ch_volt.png'));
                end
                
            else
                channel = str2double(user_input);
                if channel < 1 || channel > num_channels
                    disp(strcat('Channel number should be a number from 1 to  ',num2str(num_channels)));
                else
                    figure(f_number)
                    if is_plot
                        fig = plot(time_stamp,temp_data(channel,1:end));
                    else
                        fig = scatter(time_stamp,temp_data(channel,1:end));
                    end
                    title(strcat('Measured temperature for ch  ',num2str(channel)));
                    xlabel 'Time'; ylabel 'Temperature, C';
                    
                    prompt = '#Set y axis limit y/n?\n#';
                    ui_yl = input(prompt,'s');
                    if strcmp(ui_yl,'y')
                        prompt = '#Enter the lower limit\n#';
                        yl_lower = input(prompt);
                        prompt = '#Enter the upper limit\n#';
                        yl_upper = input(prompt);
                        ylim([yl_lower yl_upper]);
                    end
                    
                    prompt = '#Set x axis limit y/n?\n#';
                    ui_xl = input(prompt,'s');
                    if strcmp(ui_xl,'y')
                        prompt = '#Enter the lower limit in the format yyyy-MM-dd HH:mm:ss\n#';
                        ui_xl_lower = input(char(prompt),'s');
                        xl_lower=datetime(ui_xl_lower,'InputFormat','yyyy-MM-dd HH:mm:ss');
                        prompt = '#Enter the upper limit in the format yyyy-MM-dd HH:mm:ss\n##';
                        ui_xl_upper = input(char(prompt),'s');
                        xl_upper=datetime(ui_xl_upper,'InputFormat','yyyy-MM-dd HH:mm:ss');
                        xlim([xl_lower xl_upper]);
                    end
                    
                    %saveas(fig,strcat(logger_id,'_',num2str(channel),'_temp.png'));
                    
                    prompt = '#Plot measured voltage y/n?\n#';
                    ui_v = input(prompt,'s');
                    if strcmp(ui_v,'y')
                        f_number = f_number + 1;
                        figure(f_number)
                        if is_plot
                            fig = plot(time_stamp,voltage_data(channel,1:end));
                        else
                            fig = scatter(time_stamp,voltage_data(channel,1:end));
                        end
                        title(strcat('Measured voltage for ch  ',num2str(channel)));
                        xlabel 'Time'; ylabel 'Voltage, V';
                        %saveas(fig,strcat(logger_id,'_',num2str(channel),'_volt.png'));
                    end
                    
                    prompt_outlier = '#Is outlier? y/n\n#';
                    useri_outlier = input(prompt_outlier,'s');
                    if strcmp(useri_outlier,'y')
                       ind_outlier = find(not_outliers == channel);     % find index of the outlier
                       not_outliers(ind_outlier)=[];                    % remove outlier
                    end
                end
            end
        end
    end

end