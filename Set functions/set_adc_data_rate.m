function set_adc_data_rate(obj)

    global data_rate;
    global set_data_rate;

    % Data rates
    dr5 = 0;
    dr10 = 1;
    dr20 = 2;
    dr40 = 3;
    dr80 = 4;
    dr160 = 5;
    dr320 = 6;
    dr640 = 7;
    dr1000 = 8;
    dr2000 = 9;
    
    accepted_value = 1;    

    while(accepted_value)
        disp('#Valid datarates: 5, 10, 20, 40, 80, 160, 320, 640, 1000, 2000');
        prompt = '#Enter data rate: ';
        dr = input(prompt);
          if dr==5 || dr==10 || dr==20 || dr==40|| dr==80 || dr==160 || dr==320 || dr==640 || dr==1000 || dr==2000
            accepted_value = 0;
          else
            disp('#Entered data rate is invalid');
            pause(1)
          end
    end
    
    data_rate = dr;
    
    switch(dr)
      case(5)
        dr = dr5;
      case(10)
        dr = dr10;
      case(20)
        dr = dr20;
      case(40)
        dr = dr40;
      case(80)
        dr = dr80;
      case(160)
        dr = dr160;
      case(320)
        dr = dr320;
      case(640)
        dr = dr640;
      case(1000)
        dr = dr1000;
      case(2000)
        dr = dr2000;
    end
      
    message =  [set_data_rate, dr];

    send_set_cmd(obj,set_data_rate,message);
end

