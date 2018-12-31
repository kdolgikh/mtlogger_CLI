function set_measure_start(obj)

    global set_meas_start;

    % options:
    % start immediately
    % start at 00 ( xx min 00 sec, xx hour 00 min 00 sec, etc)
    % start at specific time: will implement later
    % start with delay -> enter delay: will implement later
    
    % Start with delay is implemented in set_delay_en,
    % although the delay itsel cannot be set.
    % Will remove set_delay_en and replace with this function later.
    
    start_zero = 0;
    
    disp('#Choose measurement start options:');
    
    accepted_value = 1;
    while(accepted_value)
    prompt = '#Start immediately? Enter y/n ';
    start_imm = input(prompt,'s');
        if strcmp(start_imm,'y')
            accepted_value=0;
            start_imm = 1;
        else
            if strcmp(start_imm,'n')
               accepted_value=0;
               start_imm = 0;
            else
                disp('#Invalid value. Enter y for "yes" or n for "no"');       
             end
        end
    end
    
    if ~start_imm
        accepted_value = 1;
        while(accepted_value)
        prompt = '#Start at zero clock? Enter y/n ';
        start_zero = input(prompt,'s');
            if strcmp(start_zero,'y') 
                accepted_value=0;
                start_zero = 1;
            else
                if strcmp(start_zero,'n')
                    accepted_value=0;
                    start_zero = 0; 
                else
                    disp('#Invalid value. Enter y for "yes" or n for "no"');    
                end
            end
        end
    end
    
    message = [set_meas_start,uint8(start_imm),uint8(start_zero)];
    
    send_set_cmd(obj,set_meas_start,message);

end