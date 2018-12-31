function set_keep_data_in_memory (obj)

    global set_keep_data;
    
    accepted_value = 1;    

    while(accepted_value)
        prompt = '#Keep data in memory y/n? ';
        kd = input(prompt,'s');
        if strcmp(kd,'y') || strcmp(kd,'n')
            accepted_value = 0;
        else
            disp('#Error. Type either "y" or "n"');
        end
    end
      
    switch kd
        case 'y'
            keep_data = 1;
        case 'n'
            keep_data = 0;
    end
            
    message =  [set_keep_data, keep_data];

    send_set_cmd(obj,set_keep_data,message);

end