function [temperature, v, Rth] = ProcessConvResult(conv_result,channel,therm_rt_data,time_stamp,skip_display,skip_saving,op_mode)
% Processes conversion result for a single channel
% Returns measured temperature   

    %% Defines
    global fig_number;
    global is_nice;
    global data_rate;
    
    %% Get measured voltage
    vref=2.0464;                       % reference voltage
    v=conv_result*vref/(2^23-1);        % measured voltage for the case FS = 0 to +Vref
    
    %% Get measured thermistor resistance
   
%     % Input impedance of ADC depends on data rate
%     if data_rate == 5 || data_rate == 10 || data_rate == 20
%         Rin_adc=5e9;
%     else
%         if data_rate == 40 || data_rate == 80 || data_rate == 160
%             Rin_adc=1.2e9;
%         else
%             if data_rate == 320 || data_rate == 640 || data_rate == 1000
%                 Rin_adc=600e6;
%             else
%                 if data_rate == 2000
%                     Rin_adc=300e6;
%                 end
%             end
%         end
%     end

    RR=116662.3;               % reference resistance, Ohm
    Rmux=4;                    % mux Ron, see plot on page 7 ADG706 UG
    Rmeas=RR*conv_result./(2^23 - 1 - conv_result); % measured resistance
    
%     Rmeas=conv_result*RR*Rin_adc./(Rin_adc*(2^23 - 1 - conv_result)-conv_result*RR);
% 
% %     if is_nice
% %         Rth=(Rmeas*(Rin_adc+Rmux) - Rin_adc*Rmux)./(Rin_adc-Rmeas);
% %     else
% %         Rth=Rin_adc*Rmeas./(Rin_adc-Rmeas);
% %     end
    
    if is_nice
        Rth=Rmeas-Rmux;
    else
        Rth=Rmeas;
    end

    %% Get measured temperature

    % thermistor calibration curves
    y = therm_rt_data(1:end,2); % resistance
    x = therm_rt_data(1:end,1); % temperature
    temperature=interp1(y,x,Rth,'pchip'); % interpolated temperature values

    %% Plot
    if (~skip_display)
        
        prompt = '#Use plot(p) or scatter(s)?\n#';
        sop = input(prompt,'s');
        if strcmp(sop,'p')
            is_plot = 1;
        else
            is_plot = 0;
        end
        
        prompt = '#Plot measured voltage y/n?\n#';
        ui_v = input(prompt,'s');
        if strcmp(ui_v,'y')
            figure(fig_number)
            if is_plot
                fig = plot(time_stamp,v);
            else
                fig = scatter(time_stamp,v);
            end           
            title(strcat('Measured thermistor voltage for ch',num2str(channel)));
            xlabel 'Time'; ylabel 'Input voltage, V';
            axis tight
            saveas(fig,strcat('Device_Ch',num2str(channel),'_volt.png'));
            fig_number = fig_number + 1;
            
            prompt = '#Show statistics for voltage data y/n?\n#';
            ui_s = input(prompt,'s');
            if strcmp(ui_s,'y')
                analyse_logger_data(v,skip_display);
            end
            
            if op_mode % show histogram only in bulk_mode
                prompt = '#Plot histogram y/n?\n#';
                ui_s = input(prompt,'s');
                if strcmp(ui_s,'y')
                    figure(fig_number)
                    fig = histogram(v);
                    str = {strcat('Ch',num2str(channel)),...
                        strcat('MeasRate=',num2str((1000/data_rate)),'ms'),...
                        strcat(num2str(length(v)),' Samples')};
                    dim = [.15 .6 .3 .3];
                    annotation('textbox',dim,'String',str,'FitBoxToText','on');
                    title 'Measured Voltage Distribution';
                    xlabel 'Voltage, V'; ylabel 'Counts';
                    saveas(fig,strcat('Device_Ch',num2str(channel),'_volt_hist.png'));
                    fig_number = fig_number + 1;
                end
            end
        end
        
        prompt = '#Plot thermistor resistance y/n?\n#';
        ui_r = input(prompt,'s');
        if strcmp(ui_r,'y')
            figure(fig_number)
            if is_plot
                fig = plot(time_stamp,Rth);
            else
                fig = scatter(time_stamp,Rth);
            end  
            title(strcat('Measured thermistor resistance for ch',num2str(channel)));
            xlabel 'Time'; ylabel 'Resistance, Ohm';
            axis tight
            saveas(fig,strcat('Device_Ch',num2str(channel),'_res.png'));
            fig_number = fig_number + 1;
           
            prompt = '#Show statistics for resistance data y/n?\n#';
            ui_s = input(prompt,'s');
            if strcmp(ui_s,'y')
                analyse_logger_data(Rth,skip_display);
            end
            
            if op_mode % show histogram only in bulk_mode
                prompt = '#Plot histogram y/n?\n#';
                ui_s = input(prompt,'s');
                if strcmp(ui_s,'y')
                    figure(fig_number)
                    fig = histogram(Rth/1e3);
                    str = {strcat('Ch',num2str(channel)),...
                        strcat('MeasRate=',num2str((1000/data_rate)),'ms'),...
                        strcat(num2str(length(Rth)),' Samples')};
                    dim = [.15 .6 .3 .3];
                    annotation('textbox',dim,'String',str,'FitBoxToText','on');
                    title 'Measured Resistance Distribution';
                    xlabel 'Resistance, KOhm'; ylabel 'Counts';
                    saveas(fig,strcat('Device_Ch',num2str(channel),'_res_hist.png'));
                    fig_number = fig_number + 1;
                end
            end
        end
    
    %     figure(fig_number)
    %     scatter(time_stamp,conv_result);
    %     title 'Code';
    %     axis tight
    %     fig_number = fig_number + 1;    
    
        prompt = '#Plot thermistor temperature y/n?\n#';
        ui_t = input(prompt,'s');
        if strcmp(ui_t,'y')
            figure(fig_number)
            if is_plot
                fig = plot(time_stamp,temperature);
            else
                fig = scatter(time_stamp,temperature);
            end  
            title(strcat('Measured temperature for ch',num2str(channel)));
            xlabel 'Time'; ylabel 'Temperature, C';
            axis tight
            saveas(fig,strcat('Device_Ch',num2str(channel),'_temp.png'));
            fig_number = fig_number + 1;
            
            prompt = '#Show statistics for temperature data y/n?\n#';
            ui_s = input(prompt,'s');
            if strcmp(ui_s,'y')
                analyse_logger_data(temperature,skip_display);
            end
            
            if op_mode % show histogram only in bulk_mode
                prompt = '#Plot histogram y/n?\n#';
                ui_s = input(prompt,'s');
                if strcmp(ui_s,'y')
                    figure(fig_number)
                    fig = histogram(temperature);
                    str = {strcat('Ch',num2str(channel)),...
                        strcat('MeasRate=',num2str((1000/data_rate)),'ms'),...
                        strcat(num2str(length(temperature)),' Samples')};
                    dim = [.15 .6 .3 .3];
                    annotation('textbox',dim,'String',str,'FitBoxToText','on');
                    title 'Measured Temperature Distribution';
                    xlabel 'Temperature, C'; ylabel 'Counts';
                    saveas(fig,strcat('Device_Ch',num2str(channel),'_temp_hist.png'));
                    fig_number = fig_number + 1;
                end
            end
        end
    end
    
    %% Save data 
    % generate file name
    if (~skip_saving)
        ChanNum = num2str(channel);
        DataRate = num2str(data_rate);
        TimeStamp = datestr(datetime(clock),'yymmddTHHMM');

        if is_nice
            FileName = strcat(TimeStamp,'_N_Ch',ChanNum,'_DR',DataRate);
            FileNameTemp = strcat(TimeStamp,'_N_Ch',ChanNum,'_DR',DataRate,'_temp.txt');
            FileNameCode = strcat(TimeStamp,'_N_Ch',ChanNum,'_DR',DataRate,'_code.txt');
            FileNameVolt = strcat(TimeStamp,'_N_Ch',ChanNum,'_DR',DataRate,'_volt.txt');
        else
            FileName = strcat(TimeStamp,'_U_Ch',ChanNum,'_DR',DataRate);
            FileNameTemp = strcat(TimeStamp,'_U_Ch',ChanNum,'_DR',DataRate,'_temp.txt');
            FileNameCode = strcat(TimeStamp,'_U_Ch',ChanNum,'_DR',DataRate,'_temp.txt');
            FileNameVolt = strcat(TimeStamp,'_N_Ch',ChanNum,'_DR',DataRate,'_volt.txt');
        end

        % Save the result to file
        save(FileNameTemp,'temperature','-ascii','-double','-tabs');
        save(FileNameCode,'conv_result','-ascii','-double','-tabs');
        save(FileNameVolt,'v','-ascii','-double','-tabs');
        save(strcat(FileName,'.mat'));
    end

end

