function set_delay_enable(obj)

    global set_delay_en;

    accepted_value = 1;    

    while(accepted_value)
        prompt = '#Enable delay y/n? ';
        d_en = input(prompt,'s');
        if strcmp(d_en,'y') || strcmp(d_en,'n')
            accepted_value = 0;
        else
            disp('#Error. Type either "y" or "n"');
        end
    end
      
    switch d_en
        case 'y'
            del_enable = 1;
        case 'n'
            del_enable = 0;
    end
            
    message =  [set_delay_en, del_enable];

    send_set_cmd(obj,set_delay_en,message);
    
end

