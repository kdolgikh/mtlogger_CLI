function cal_reg_received_callback(obj,~,command)

    calreg = fread(obj,obj.BytesAvailable,'uint8');
    fclose(obj);
    disp('#Serial port is closed');
    
    if calreg(1) == command
        % shifting operation equals multiplication
        cal_register = calreg(2)*2^16 + calreg(3)*2^8 + calreg(4);
        disp(['#Requested calibration register value is ',num2str(cal_register)]);
    else
        disp('#Invalid ACK is received. Please, retry');
    end
end

