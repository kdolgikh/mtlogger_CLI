function get_adc_cal_register(obj, user_input)

    global get_ofc;
    global get_fsc;
    
    if (strcmp(user_input,'get ofc reg'))
        command = get_ofc;
    else if (strcmp(user_input,'get fsc reg'))
        command = get_fsc;
        end
    end
    
    obj.InputBufferSize = 5;   

    % 4 bytes (1 byte ACK plus 3 bytes register) should be received
    obj.BytesAvailableFcnCount = 4;     

    % interrupt when receive the specified number of bytes
    obj.BytesAvailableFcnMode = 'byte';   

    % specify function to be executed when received BytesAvailableFcnCount
    obj.BytesAvailableFcn = {@cal_reg_received_callback,command};  
    
    fopen(obj);       % open serial port
    disp('#Serial port is opened');
    readasync(obj);   % callbacks (interrupts) work only in async mode

    % request number of conversions
    fwrite(obj,command);
    disp('#Command is sent');
end

