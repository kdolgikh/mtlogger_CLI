function ProcessInputBulkData(cr,num_bytes,num_segm_bulk)

    global data_rate;
    global op_mode;
    
    segment_size = 512;
    meas_per_segment = 170;
    crc_bytes = 2;
    
    %% process input data
    
    % !Important! It's crucial that the program receives the complete
    % blocks of data of size num_segm_bulk*num_segm for each channel.
    % There might be less channels than 16, but the blocks must be
    % complete, or the code won't work. It is a future task to create the
    % code that will handle incomplete blocks (which is needed for the case
    % when USB is inserted at any time)
    
   % determine num channels 
    num_channels = num_bytes/(num_segm_bulk*segment_size);
   
    bad_data = 189; % 0xBD
    conv_result_crc = zeros(1,num_segm_bulk*num_channels);
    j=1;
    for i=1:num_segm_bulk*num_channels
        conv_result_crc(i) = cr((i*segment_size - 1));
        if conv_result_crc(i) == bad_data
            cr(j:(j + segment_size - 3)) = NaN;
        end
        j= j + segment_size;
    end

    % find if bad_data is present and display it
    crc_bd = find(conv_result_crc == bad_data);
    disp(['#Number of CRC errors: ',num2str(length(crc_bd))]);
    if ~isempty(crc_bd)
        disp('#Invalid data was replaced with NaN');
    end
    
    a=[];
    for i=1:num_segm_bulk*num_channels
        if (i==1)
            a_next = cr(i:(i*segment_size - crc_bytes));
        else
            a_next = cr(((i-1)*segment_size+1):(i*segment_size - crc_bytes));
        end
        a=[a; a_next];
    end

    code_bulk = zeros(1,(length(a)/3));
    k=1;    % index of a
    i=1;    % index of code_bulk
    while (k <= (length(a)-2))
        code_bulk(i) = a(k)*2^16 + a(k+1)*2^8 + a(k+2); % shifting operation equals multiplication
        k=k+3;
        i=i+1;
    end
    
    %% separate different channels data
    code = [];
    i=1;
    for j=1:num_channels
        code_next = code_bulk(i:j*num_segm_bulk*meas_per_segment);
        code = [code; code_next];
        i = i + num_segm_bulk*meas_per_segment;
    end
    
    tstep = 1/data_rate;     % sampling time
    time=0:tstep:(tstep*(length(code)-1));
    
    %% process and present the result
   [temperature,voltage,Rth] = PresentConvResult(num_segm_bulk*meas_per_segment,num_channels,code,time,op_mode);
   
    %% save data
    DataRate = num2str(data_rate);
    TimeStamp = datestr(datetime(clock),'yymmddTHHMM');
    FileName = strcat(TimeStamp,'_All_Ch_DR',DataRate);
    save(strcat(FileName,'_code.txt'),'code','-ascii','-double','-tabs');
    save(strcat(FileName,'_volt.txt'),'voltage','-ascii','-double','-tabs');
    save(strcat(FileName,'_rth.txt'),'Rth','-ascii','-double','-tabs');
    save(strcat(FileName,'_temp.txt'),'temperature','-ascii','-double','-tabs');
    save(strcat(FileName,'_time.mat'),'time','-mat');
    save(strcat(FileName,'.mat'));

end