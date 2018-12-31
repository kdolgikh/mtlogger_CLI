function set_measurement_rate (obj)

    global set_meas_rate;
    global data_rate;
    global meas_rate;
    
    empty_array='';
    
    disp('#Enter measurement rate in days, hours, months and seconds');
    disp('#Number of seconds should always be divisible by 2');
    
    accepted_value = 1;
    while(accepted_value)
        prompt = '#Enter number of days: ';
        Days = input(prompt,'s');
        if(find(isstrprop(Days,'digit')==0))
            disp('#Invalid value. Days should be a number');
        else
            if strcmp(Days,empty_array)   
                disp('#Invalid value. Days should be a number');
            else
                days = str2double(Days);
                if days < 0 || days > 49710 % num of days in 2^32 seconds
                    disp('#Invalid value. Days should lie within 0 - 49710 range');
                else
                    accepted_value=0;
                end
            end
        end
    end
    
    accepted_value = 1;
    while(accepted_value)
        prompt = '#Enter number of hours: ';
        Hours = input(prompt,'s');    
        if(find(isstrprop(Hours,'digit')==0))
            disp('#Invalid value. Hours should be a number');
        else
            if strcmp(Hours,empty_array)
                disp('#Invalid value. Hours should be a number');
            else
                hours = str2double(Hours);
                if hours <0 || hours >23
                    disp('#Invalid value. Hours should lie within 0 - 23 range');
                else
                    accepted_value=0;
                end
            end
        end     
    end

    accepted_value = 1;
    while(accepted_value)
        prompt = '#Enter number of minutes: ';
        Minutes = input(prompt,'s');
        if(find(isstrprop(Minutes,'digit')==0))
            disp('#Invalid value. Minutes should be a number');
        else
            if strcmp(Minutes,empty_array)
                disp('#Invalid value. Minutes should be a number');
            else
                minutes = str2double(Minutes);
                if minutes <0 || minutes >59
                    disp('#Invalid value. Minutes should lie within 0 - 59 range');
                else
                    accepted_value=0;
                end
            end
        end
    end
    
    accepted_value = 1;
    while(accepted_value)
        prompt = '#Enter number of seconds: ';
        Seconds = input(prompt,'s');
        if(find(isstrprop(Seconds,'digit')==0))
            disp('#Invalid value. Seconds should be a number');
        else
            if strcmp(Seconds,empty_array)
                disp('#Invalid value. Seconds should be a number');
            else
                seconds = str2double(Seconds);
                if seconds <0 || seconds >59
                    disp('#Invalid value. Seconds should lie within 0 - 59 range');
                else
                    if rem(seconds,2) ~= 0
                        disp('#Invalid value. Seconds should be divisible by 2')
                    else
                        if data_rate == 5
                                if seconds < 12 && days == 0 && hours == 0 && minutes == 0
                                    disp('#Invalid value. For data rate 5 sps min seconds is 12');
                                else
                                    accepted_value=0;
                                end
                        else
                            if data_rate == 10
                                if seconds < 6 && days == 0 && hours == 0 && minutes == 0
                                    disp('#Invalid value. For data rate 10 sps min seconds is 6');
                                else
                                    accepted_value=0;
                                end
                            else
                                if data_rate == 20 || data_rate == 40
                                    if seconds < 4 && days == 0 && hours == 0 && minutes == 0
                                        disp('#Invalid value. For data rates 20 and 40 sps min seconds is 4');
                                    else
                                        accepted_value=0;
                                    end
                                else
                                    if data_rate == 80 || data_rate == 160 || data_rate == 320 ||...
                                       data_rate == 640 || data_rate == 1000 || data_rate == 2000
                                       if seconds < 2 && days == 0 && hours == 0 && minutes == 0
                                            disp('#Invalid value. For data rates 80 - 2000 sps min seconds is 2');
                                       else
                                            accepted_value=0;
                                       end
                                    end
                                end
                            end
                        end
                    end
                end          
            end         
        end
    end
    
    meas_rate = swapbytes(uint32(transform_meas_rate_sec(days,hours,minutes,seconds)));
    
    mr = typecast(meas_rate,'uint8');
    
    meas_rate = swapbytes(meas_rate);
    
    message =  cat(2,set_meas_rate,mr);

    send_set_cmd(obj,set_meas_rate,message);

end