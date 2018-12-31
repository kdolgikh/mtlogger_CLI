function send_set_cmd(obj, command, message)

% Function sends set commands over serial port.
% Message contains both the command code and data
% to be sent. Command code itself is used in ack_callback
% and displayed result.

    global set_meas_rate;
    global set_data_rate;
    global set_num_bulk_segm;
    global set_vrefcon;
    global set_dev_state;
    global set_rtc;
    global set_sysocal_en;
    global set_delay_en;
    global set_meas_start;
    global set_keep_data;
    global set_cal_en;
    global set_op_mode;
    
    switch (command)
        case set_meas_rate
            command_str ='set meas rate';
        case set_meas_start
            command_str ='set meas start';
        case set_data_rate
            command_str ='set data rate';
        case set_num_bulk_segm
            command_str ='set num bulk';
        case set_vrefcon
            command_str ='set_adc_vrefcon';
        case set_dev_state
            command_str ='set dev state';
        case set_sysocal_en
            command_str ='set sysocal en';
        case set_delay_en
            command_str ='set delay en';
        case set_rtc
            command_str ='set rtc';
        case set_keep_data
            command_str ='set keep data';
        case set_cal_en
            command_str ='set cal en';
        case set_op_mode
            command_str ='set op mode';
    end
    
    result_str = strcat('#',command_str,' command is sent');

    obj.InputBufferSize = 2;   

    % specify number of bytes to be received
    obj.BytesAvailableFcnCount = 1; % only 1 byte ACK should be received    

    % interrupt when receive the specified number of bytes
    obj.BytesAvailableFcnMode = 'byte';   

    % specify function to be executed when received BytesAvailableFcnCount
    obj.BytesAvailableFcn = {@ack_received_callback,command};  

    fopen(obj);       % open serial port
    disp('#Serial port is opened');
    
    readasync(obj);   % callbacks (interrupts) work only in async mode

    % send value of the data rate
    fwrite(obj,message);
    disp(result_str);

end

