function set_time(obj)

    global year;
    global month;
    global day;
    global hour;
    global minute;
    global second;
    global set_time_fail_count;
    global rx_completed;
    global set_time_in_progress;
    
    set_time_in_progress = 1;
    
    cc = clock;
    
    while ~(cc(1)==year && cc(2)==month && cc(3)==day)
        set_rt_clock(obj);
        while(~rx_completed) 
        end
        rx_completed=0;
        get_rt_clock(obj);
        while(~rx_completed) 
        end
        rx_completed=0;
        if ~(cc(1)==year && cc(2)==month && cc(3)==day)
            set_time_fail_count = set_time_fail_count + 1;
        end
    end
    
    t=datetime(year,month,day,hour,minute,second);
    disp('#The device clock is:');
    disp(t);
%     disp(['#Set time fail counter is ',num2str(set_time_fail_count)]);
%     disp('#');

    set_time_in_progress = 0;
    
    set_time_fail_count = 0;
end

