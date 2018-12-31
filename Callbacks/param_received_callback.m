function param_received_callback(obj,~,command)

    global num_segm_bulk;
    global data_rate;
    global op_mode;
    
    global get_data_rate;
    global get_num_bulk_segm;
    global get_vrefcon;
    global get_dev_state;
    global get_sysocal_en;
    global get_delay_en;
    global get_keep_data;
    global get_cal_en;
    global get_op_mode;
    
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
    
    % vrefcon values
    vrefcon_vref_off = 0;
    vrefcon_vref_on = 32;
    vrefcon_vref_alt = 64;
    
    % device states
    get_dev_state_disabled = 0;
    adc_set = 3;
    adc_cal = 4;
    adc_measure = 5;
    adc_rst = 6;
    dev_memory_full = 7;
    dev_malfunction = 8;
    param_error = 9;
    
    
    %read received param
    param = fread(obj,obj.BytesAvailable,'uint8');
    
    fclose(obj);
    disp('#Serial port is closed');
    
    if param(1) == command
        
            if command == get_data_rate
                switch(param(2))
                    case dr5
                       param_disp = 5; 
                    case dr10
                        param_disp = 10;
                    case dr20
                        param_disp = 20;
                    case dr40
                        param_disp = 40;
                    case dr80
                        param_disp = 80;
                    case dr160
                        param_disp = 160;
                    case dr320
                        param_disp = 320;
                    case dr640
                        param_disp = 640;
                    case dr1000
                        param_disp = 1000;
                    case dr2000
                        param_disp = 2000;
                end  
                data_rate = param_disp;
            else
                if command == get_num_bulk_segm
                    param_disp = num2str(param(2));
                    num_segm_bulk = param(2);
                else
                    if command == get_vrefcon
                        switch(param(2))
                            case vrefcon_vref_off
                                param_disp = 'vref_off';
                            case vrefcon_vref_on
                                param_disp = 'vref_on';
                            case vrefcon_vref_alt
                                param_disp = 'vref_alt';
                        end   
                    else
                        if command == get_dev_state
                            switch(param(2))
                                case get_dev_state_disabled
                                    param_disp = 'get device state function is disabled';
                                case adc_set
                                    param_disp = 'adc_set';
                                case adc_cal
                                    param_disp = 'adc_cal';
                                case adc_measure
                                    param_disp = 'adc_measure';
                                case adc_rst
                                    param_disp = 'adc_rst';
                                case dev_malfunction
                                    param_disp = 'dev_malfunction';
                                case dev_memory_full
                                    param_disp = 'dev_mem_full';
                                case param_error
                                    param_disp = 'dev_param_error';
                            end
                        else
                            if command == get_sysocal_en || command == get_delay_en ||...
                                    command == get_keep_data || command == get_cal_en
                                switch(param(2))
                                    case 0
                                        param_disp = 'False';
                                    case 1
                                       param_disp = 'True'; 
                                end
                            else
                                if command == get_op_mode
                                    op_mode = param(2);
                                    switch(param(2))
                                        case 0
                                            param_disp = 'rtc_mode';
                                        case 1
                                            param_disp = 'bulk_mode';
                                    end
                                end
                            end
                        end
                    end
                end
            end

            switch (command)
                case get_data_rate
                    command_str ='data_rate';
                case get_num_bulk_segm
                    command_str ='num_bulk';
                case get_vrefcon
                    command_str ='adc_vrefcon';
                case get_dev_state
                    command_str ='dev_state';
                case get_sysocal_en
                    command_str ='sysocal_en';
                case get_delay_en
                    command_str ='delay_en';
                case get_keep_data
                    command_str = 'keep_data';
                case get_cal_en
                    command_str = 'cal_en';
                case get_op_mode
                    command_str = 'get_op_mode';
            end
            
            if command == get_data_rate
                disp(['#Requested ',command_str,' value is   ',num2str(param_disp)]);
             else 
                disp(['#Requested ',command_str,' value is   ',param_disp]);
            end
    
    else
            disp('#Invalid ACK is received. Please, retry');
    end
end

