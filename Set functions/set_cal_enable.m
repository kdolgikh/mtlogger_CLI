function set_cal_enable(obj)

    global set_cal_en;

    accepted_value = 1;    

    while(accepted_value)
        prompt = '#Enable calibration y/n? ';
        c_en = input(prompt,'s');
        if strcmp(c_en,'y') || strcmp(c_en,'n')
            accepted_value = 0;
        else
            disp('#Error. Type either "y" or "n"');
        end
    end
      
    switch c_en
        case 'y'
            cal_enable = 1;
        case 'n'
            cal_enable = 0;
    end
            
    message =  [set_cal_en, cal_enable];

    send_set_cmd(obj,set_cal_en,message);
    
end