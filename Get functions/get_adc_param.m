function get_adc_param(obj, usr_input)

    global get_data_rate;
    global get_num_bulk_segm;
    global get_vrefcon;
    global get_dev_state;
    global get_sysocal_en;
    global get_delay_en;
    global get_keep_data;
    global get_cal_en;
    global get_op_mode;
    
    if (strcmp(usr_input,'get data rate'))
        command = get_data_rate;
    else
        if (strcmp(usr_input,'get num bulk'))
        command = get_num_bulk_segm;
        else
            if (strcmp(usr_input,'get adc vrefcon'))
            command = get_vrefcon; 
            else
                if (strcmp(usr_input,'get dev state'))
                   command = get_dev_state;
                else
                    if (strcmp(usr_input,'get sysocal en'))
                        command = get_sysocal_en;
                    else
                        if (strcmp(usr_input,'get delay en'))
                            command = get_delay_en;
                        else
                            if (strcmp(usr_input,'get keep data'))
                                command = get_keep_data;
                            else
                                if (strcmp(usr_input,'get cal en'))
                                    command = get_cal_en;
                                else
                                    if (strcmp(usr_input,'get op mode'))
                                        command = get_op_mode;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    result_str = strcat('#',usr_input,' command is sent');
    
    obj.InputBufferSize = 3;

    % specify number of bytes to be received
    obj.BytesAvailableFcnCount = 2; % 2 bytes should be RXed: ACK and param    

    % interrupt when receive the specified number of bytes
    obj.BytesAvailableFcnMode = 'byte';   

    % specify function to be executed when received BytesAvailableFcnCount
    obj.BytesAvailableFcn = {@param_received_callback,command};  

    fopen(obj);       % open serial port
    disp('#Serial port is opened');
    readasync(obj);   % callbacks (interrupts) work only in async mode

    fwrite(obj,command);
    disp(result_str);
end