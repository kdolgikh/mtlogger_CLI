function set_rt_clock(obj)
    
    % implement one of the time syncing protocols!

    global set_rtc;
    
    c = clock;   
    c(1) = c(1) - 2000; % use only 18, 19 etc. and not 2018, 2019, etc.
    c(6) = floor(c(6)); % round seconds to the nearest integer
    c = uint8(c);
    % c(1) - year
    % c(2) - month
    % c(3) - day
    % c(4) - hour
    % c(5) - min
    % c(6) - sec
    
    message = cat(2,set_rtc,c); % concatenate command with clock
   
    % send the message
    send_set_cmd(obj,set_rtc,message);

end

