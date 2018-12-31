function set_adc_vrefcon_reg(obj)

    global set_vrefcon;
    
    % vrefcon values
    vrefcon_vref_off = 0;
    vrefcon_vref_on = 32;
    vrefcon_vref_alt = 64;
    
    accepted_value = 1;    

    while(accepted_value)
        disp('#Valid vrefcon strings: vref off, vref on, vref alt');
        prompt = '#Enter vrefcon string: ';
        vrefcon = input(prompt,'s');
        if strcmp(vrefcon,'vref off')  || strcmp(vrefcon,'vref on')  || strcmp(vrefcon,'vref alt') 
            accepted_value = 0;
        else
            disp('#Error. Unacceptable vrefcon string. Acceptable strings are: vref off, vref on, vref alt.');
            disp('#Type "help vrefcon" for more details.');
        end
    end

    switch(vrefcon)
      case('vref off')
        vrefcon = vrefcon_vref_off;
      case('vref on')
        vrefcon = vrefcon_vref_on;
      case('vref alt')
        vrefcon = vrefcon_vref_alt;
    end

    message = [set_vrefcon, vrefcon];

    send_set_cmd(obj,set_vrefcon,message);

end

