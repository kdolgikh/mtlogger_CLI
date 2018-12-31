function cli_help_dstate()

    
    disp('#Acceptable device states are:');
    disp('#adc_set          Calibration is skipped');
    disp('#adc_cal          Calibration is performed');
    disp('#adc_measure      Measurements are performed');
    disp('#adc_rst          Reset ADC, proceed to adc_cal or adc_set');
    disp('#dev_mem_full     Device memory is full');
    disp('#dev_malfunction  Device is broken');
    disp('#dev_param_error  Device parameter error');
    disp('#');

end

