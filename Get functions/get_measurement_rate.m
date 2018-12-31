function get_measurement_rate(obj)

    global get_meas_rate;
    
    obj.InputBufferSize = 6;   

    % 5 bytes (1 byte ACK plus 4 bytes meas rate) should be received
    obj.BytesAvailableFcnCount = 5;     

    % interrupt when receive the specified number of bytes
    obj.BytesAvailableFcnMode = 'byte';   

    % specify function to be executed when received BytesAvailableFcnCount
    obj.BytesAvailableFcn = {@meas_rate_received_callback,get_meas_rate};  
    
    fopen(obj);       % open serial port
    disp('#Serial port is opened');
    readasync(obj);   % callbacks (interrupts) work only in async mode

    % request number of conversions
    fwrite(obj,get_meas_rate);
    disp('#Get meas rate command is sent');
end

