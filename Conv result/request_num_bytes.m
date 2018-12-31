function request_num_bytes(obj)
% This function requests amount of data to be received from the device

    global get_conv_result;

    % Length of the buffer for num_bytes ( 1 byte ACK + 4 bytes num_bytes)
    num_bytes_buff_lgth = 5;

    % input buffer size for receiving num conv bytes from the device
    % Buffer size is larger than BytesAvailableFcnCount by 1
    obj.InputBufferSize =  num_bytes_buff_lgth + 1;

    % specify number of bytes to be received
    % 5 bytes, ACk and one uint32_t, should be received
    obj.BytesAvailableFcnCount = num_bytes_buff_lgth; 

    % interrupt when receive the specified number of bytes
    obj.BytesAvailableFcnMode = 'byte';   

    % specify function to be executed when received BytesAvailableFcnCount
    obj.BytesAvailableFcn = {@num_bytes_RXed_callback};  

    fopen(obj);       % open serial port
    disp('#Serial port is opened');
    readasync(obj);   % callbacks (interrupts) work only in async mode

    % request number of conversions
    fwrite(obj,get_conv_result);
    disp('#Get conv result is sent');
end

