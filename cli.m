global is_nice;
is_nice=0;

global ch_num;
ch_num=0;

global year;
global month;
global day;
global hour;
global minute;
global second;
global set_time_fail_count;
global rx_completed;
global set_time_in_progress;
year = 0;
month = 0;
day = 0;
hour = 0;
minute=0;
second=0;
set_time_fail_count=0;
rx_completed=0;
set_time_in_progress=0;

global num_segm_bulk; 
num_segm_bulk = uint8(30);

global data_rate;
data_rate = 2000;

global meas_rate;
meas_rate = uint32(10);

global op_mode;
op_mode = uint8(0); % 0 is rtc mode, 1 is bulk mode 

% % USB commands
global set_meas_rate;
global get_conv_result;
global get_data_rate;
global set_data_rate;
global get_num_bulk_segm;
global set_num_bulk_segm;
global get_vrefcon;
global set_vrefcon;
global get_ofc;
global get_fsc;
global get_dev_state;
global set_dev_state;
global get_rtc;
global set_rtc;
global set_sysocal_en;
global get_sysocal_en;
global set_delay_en;
global get_delay_en;
global set_meas_start;
global get_meas_rate;
global set_keep_data;
global get_keep_data;
global get_cal_en;
global set_cal_en;
global get_op_mode;
global set_op_mode;


get_conv_result = uint8(127);          % 0x7F
get_data_rate = uint8(3);              % 0x03
set_data_rate = uint8(5);              % 0x05
get_num_bulk_segm = uint8(7);          % 0x07
set_num_bulk_segm = uint8(9);          % 0x09
get_vrefcon = uint8(10);               % 0x0A
set_vrefcon = uint8(11);               % 0x0B
get_ofc = uint8(12);                   % 0x0C
get_fsc = uint8(13);                   % 0x0D
get_dev_state = uint8(14);             % 0x0E
set_dev_state = uint8(15);             % 0x0F
get_rtc = uint8(17);                   % 0x11
set_rtc = uint8(18);                   % 0x12
get_sysocal_en = uint8(19);            % 0x13
set_sysocal_en = uint8(20);            % 0x14
get_delay_en = uint8(21);              % 0x15
set_delay_en = uint8(22);              % 0x16
set_meas_rate = uint8(23);             % 0x17
set_meas_start = uint8(24);            % 0x18
get_meas_rate = uint8(25);             % 0x19
set_keep_data = uint8(26);             % 0x1A
get_keep_data = uint8(27);             % 0x1B
set_cal_en = uint8(28);                % 0x1C
get_cal_en = uint8(29);                % 0x1D
get_op_mode = uint8(30);               % 0x1E
set_op_mode = uint8(31);               % 0x1F


break_event = 1;
return_key='';

accepted_val = 1;    

com_ports = seriallist;

while(accepted_val)
    disp('#Available COM ports: ');
    disp(com_ports);
    choose_dev_prompt = '#Choose COM port by entering its name (e.g. COM1)\n#';
    choose_dev = input(choose_dev_prompt,'s');
    
    for i=1:numel(com_ports)
        if strcmp(choose_dev,com_ports(i))
            accepted_val = 0;
            s = serial(com_ports(i));
        end
    end
    
    if accepted_val == 1
        disp('#Entered COM port is invalid, please retry');
        pause(1)
    end
end

% % Functions for reference:
% % seriallist - provides list of connected COM ports
% % get(s)
% % instrfind()
% % new = instrfind();
% % fclose(new); - to close improperly exited serial object;
% % delete(new); - to delete all closed objects in the list

get_adc_param(s,'get data rate');

% start CLI
prompt = '#';

while(break_event)
    pause(1)
    user_input = input(prompt,'s');
    switch (user_input)
        case 'get conv result'
            request_num_bytes(s);
        case 'get data rate'
            get_adc_param(s,user_input);
        case 'get meas rate'
            get_measurement_rate(s);
        case 'get num bulk'
            get_adc_param(s,user_input);
        case 'get adc vrefcon'
            get_adc_param(s,user_input);
        case 'get dev state'
            get_adc_param(s,user_input);
        case 'get sysocal en'
            get_adc_param(s,user_input);
        case 'get delay en'
            get_adc_param(s,user_input);
        case 'get keep data'
            get_adc_param(s,user_input);
        case 'get cal en'
            get_adc_param(s,user_input);
        case 'get op mode'
            get_adc_param(s,user_input);
        case 'get ofc reg'
            get_adc_cal_register(s,user_input);
        case 'get fsc reg'
            get_adc_cal_register(s,user_input);
        case 'get rtc'
            get_rt_clock(s);
        case 'set meas rate'
            set_measurement_rate(s);
        case 'set meas start'
            set_measure_start(s);
        case 'set data rate'
            set_adc_data_rate(s); 
        case 'set num bulk'
            set_num_of_bulk_segments(s);
        case 'set adc vrefcon'
            set_adc_vrefcon_reg(s);
        case 'set dev state'
            set_device_state(s);
        case 'set sysocal en'
            set_sysocal_enable(s);
        case 'set delay en'
            set_delay_enable(s);
        case 'set rtc'
             set_rt_clock(s);
        case 'set time'
            set_time(s);
        case 'set keep data'
            set_keep_data_in_memory(s);
        case 'set cal en'
            set_cal_enable(s);
        case 'set op mode'
            set_operational_mode(s);
        case 'help'
            cli_help();
        case 'help vrefcon'
            cli_help_vrefcon();
        case 'help dev state'
            cli_help_dstate();
        case 'abort'
            fclose(s);
            disp('#Serial port is closed');
        case 'exit'
            break_event = 0;
        case return_key
            disp('#');
        otherwise
            disp('#Unrecognized command');
    end
end

fclose(s);
delete(s);
clear
%clc


