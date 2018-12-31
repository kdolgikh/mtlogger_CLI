function get_buffer_callback(obj,~)

    disp('Conv result was not received within 1 minute');
    num_bytes = num2str(obj.BytesAvailable);
    disp(['#Number of received bytes: ',num_bytes]);
    data = fread(obj,obj.BytesAvailable,'uint8');
    save(strcat('data_',num_bytes,'_bytes.mat'),'data');
    disp('#Received data is saved to file')
    fclose(obj);
    disp('#Serial port is closed');
end