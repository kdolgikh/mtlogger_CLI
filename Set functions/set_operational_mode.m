function set_operational_mode(obj)

    global set_op_mode;
    global op_mode;

    accepted_value = 1;    

    while(accepted_value)
        prompt = '#Enter operational mode: type either "rtc" or "bulk"\n#';
        som_en = input(prompt,'s');
        if strcmp(som_en,'rtc')
            op_mode = 0;
            accepted_value = 0;
        else
            if strcmp(som_en,'bulk')
                op_mode = 1;
                accepted_value = 0;
            else
            disp('#Error. Type either "rtc" or "bulk"');
            end
        end
    end
            
    message =  [set_op_mode, op_mode];

    send_set_cmd(obj,set_op_mode,message);
end