function meas_rate_received_callback(obj,~,command)

    data = fread(obj,obj.BytesAvailable,'uint8');
    fclose(obj);
    disp('#Serial port is closed');

    global meas_rate;
    
    if data(1) == command
        meas_rate = swapbytes(typecast(uint8(data(2:end)),'uint32'));
        [D,H,M,S] = transform_meas_rate(meas_rate);
        disp('#The device measurement rate is:');
        disp([num2str(D),' days ',num2str(H),' hours ',num2str(M),...
            ' minutes ',num2str(S),' seconds ']);
    else
        disp('#Invalid ACK is received. Please, retry')
    end

end