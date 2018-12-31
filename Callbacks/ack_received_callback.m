function ack_received_callback(obj,~,command)

    ack = fread(obj,obj.BytesAvailable,'uint8');
    fclose(obj);
    disp('#Serial port is closed');
    
    if ack == command
        disp('#Parameter is set successfully')
    else
        disp('#Invalid ACK is received. Please, retry')
    end
    
    global rx_completed;
    rx_completed = 1;
end

