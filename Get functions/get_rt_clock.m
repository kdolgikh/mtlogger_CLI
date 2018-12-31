function get_rt_clock(obj)

    global get_rtc;
    
    obj.InputBufferSize = 8;   

    % 7 bytes (1 byte ACK plus 6 bytes clock) should be received
    obj.BytesAvailableFcnCount = 7;     

    % interrupt when receive the specified number of bytes
    obj.BytesAvailableFcnMode = 'byte';   

    % specify function to be executed when received BytesAvailableFcnCount
    obj.BytesAvailableFcn = {@clock_received_callback,get_rtc};  
    
    fopen(obj);       % open serial port
    disp('#Serial port is opened');
    
    readasync(obj);   % callbacks (interrupts) work only in async mode

    % request number of conversions
    fwrite(obj,get_rtc);
    disp('#Get RT clock command is sent');
    
end

