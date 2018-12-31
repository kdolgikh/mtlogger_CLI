function clock_received_callback(obj,~,command)

    clock = fread(obj,obj.BytesAvailable);
    fclose(obj);
    disp('#Serial port is closed');

    global year;
    global month;
    global day;
    global hour;
    global minute;
    global second;
    global rx_completed;
    global set_time_in_progress;
    
    if clock(1) == command
        year=clock(2)+2000;
        month=clock(3);
        day=clock(4);
        hour=clock(5);
        minute=clock(6);
        second=clock(7);
       if ~set_time_in_progress
           t=datetime(year,month,day,hour,minute,second);
           disp('#The device clock is:');
           disp(t);
       end
    else
        disp('#Invalid ACK is received. Please, retry')
    end
    
    rx_completed=1;
    
end

