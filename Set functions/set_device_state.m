function set_device_state(obj)

    global set_dev_state;
    
    % device states
    adc_set = 3;
    adc_cal = 4;
    adc_measure = 5;
    adc_rst = 6;
  
    accepted_value = 1;    

    while(accepted_value)
        disp('Valid states: adc_set, adc_cal, adc_measure, adc_rst');
        prompt = '#Enter device state: ';
        dstate = input(prompt,'s');
        if strcmp(dstate,'adc_set') || strcmp(dstate,'adc_cal') || strcmp(dstate,'adc_measure') || strcmp(dstate,'adc_rst')
            accepted_value = 0;
        else
            disp('#Error. Unacceptable device state. Enter "help dev_state" for more details');
        end
    end
      
   switch(dstate)
      case('adc_set')
        dstate = adc_set;
      case('adc_cal')
        dstate = adc_cal;
      case('adc_measure')
        dstate = adc_measure;
      case('adc_rst')
        dstate = adc_rst;  
    end  
      
    message =  [set_dev_state, dstate];

    send_set_cmd(obj,set_dev_state,message);
end

