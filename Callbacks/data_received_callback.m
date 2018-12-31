function data_received_callback (obj,~,num_bytes)
    % This callback function is executed when finished receiving data from
    % the device.   
    
    global get_conv_result;
    global meas_rate;
    global op_mode;
    global num_segm_bulk; 
    
    %read conversion result (cr)
    cr = fread(obj,obj.BytesAvailable,'uint8');
    
    fclose(obj);
    disp('#Serial port is closed');
    
    if cr(1) == get_conv_result
        disp('#Conversion result is successfully received');
        cr=cr(2:end);   % get rid of ack
        
        if ~op_mode % rtc mode
            ProcessInputData(cr, num_bytes, meas_rate);
        else        % bulk mode
            ProcessInputBulkData(cr,num_bytes, num_segm_bulk);
        end
        
    else
        disp('#Invalid ACK is received. Please, retry');
    end
end
   
