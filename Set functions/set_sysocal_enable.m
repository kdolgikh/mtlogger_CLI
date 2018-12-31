function set_sysocal_enable(obj)

    global set_sysocal_en;

    accepted_value = 1;    

    while(accepted_value)
        prompt = '#Enable sysocal y/n? ';
        soc_en = input(prompt,'s');
        if strcmp(soc_en,'y') || strcmp(soc_en,'n')
            accepted_value = 0;
        else
            disp('#Error. Type either "y" or "n"');
        end
    end
      
    switch soc_en
        case 'y'
            soc_enable = 1;
        case 'n'
            soc_enable = 0;
    end
            
    message =  [set_sysocal_en, soc_enable];

    send_set_cmd(obj,set_sysocal_en,message);
end

