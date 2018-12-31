function num_bytes_RXed_callback(obj,~,~)

    % Function receives num of conv result bytes, prepares data buffer
    % to receive data and sends ACK to the device to start TXing conv data
    
    global get_conv_result;
    
    ack_bytes = 1;  % number of ack bytes that will be sent to the host
    
    param = fread(obj,obj.BytesAvailable,'uint8');
   
    fclose(obj);
    disp('#Serial port is closed');
    
    % the first byte is ACK
    if param(1) == get_conv_result
        
        % use bytes 2 to 5 to obtain num bytes
        % use typecast to conver four uint8 to one uint32
        % data is received MSB first
        param = swapbytes(typecast(uint8((param(2:5))),'uint32'));
        disp(['#Num conv bytes:   ',num2str(param)]);

        % input buffer size for receiving num conv bytes from the device
        % Buffer size is larger than BytesAvailableFcnCount by 1
        obj.InputBufferSize =  param + ack_bytes + 1;

        % specify number of bytes to be received
        % + 1 accounts for get_conv_result comand sent back as ACK from the
        % device
        obj.BytesAvailableFcnCount = param + ack_bytes;

        % interrupt when receive the specified number of bytes
        obj.BytesAvailableFcnMode = 'byte';   

        % specify function to be executed when received BytesAvailableFcnCount
        obj.BytesAvailableFcn = {@data_received_callback,param};  

        % if required number of bytes is not received within 1 min,
        % go to get_buffer_callback
        obj.TimerPeriod = 60; % seconds
        obj.TimerFcn = @get_buffer_callback;
        
        fopen(obj);       % open serial port
        disp('#Serial port is opened');
        readasync(obj);   % callbacks (interrupts) work only in async mode

        % request conv data
        fwrite(obj,get_conv_result);
        disp('#Get conv result is sent');
        
    else
        disp('#Invalid ACK is received. Please, retry');
    end
end

