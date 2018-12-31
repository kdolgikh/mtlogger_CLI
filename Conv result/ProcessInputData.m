function ProcessInputData(cr, num_bytes, meas_rate)

    % Function processes and presents conversion results to a user
    
    global data_rate;
    global op_mode;
    
    segment_size = 512;
    num_meas_per_sect = 10;
    millenium = 2000;
    num_channels = 16;

    % need to explicitly convert to appropriate data types, otherwise won't
    % work
    num_bytes=double(num_bytes);
    cr=uint8(cr);
    
    % Data organization
    % Byte 1: ACK
    % Byte 2 - 512, 513 - 1024 etc - data segments.
    % Each data segment has:
        % Byte 1 - 5:   timestamp, byte 1 - year, bytes 2-5 - MDHMS
        % Byte 6:       result of CRC check for time stamp
        % Byte 7:       0x00
        % Byte 8 - 55:  conversion result for 16 channels
        % Byte 56:      result of CRC check for conv results
        % Byte 57:      0x00   

    %% Generate time stamp vector

    % number of sectors in received data
    % round for the case the data was requested before segment was filled
    num_sectors = fix(num_bytes/segment_size);
    not_full_sector = rem(num_bytes,segment_size);

    % position of the time stamp CRC check result minus 1
    % to account for initial indexing starting at 1
    ts_crc_position = 5;
    bad_data = uint8(189); % 0xBD
    %correct_data = uint8(205); % 0xCD

    % number of time stamps in received data
    num_ts = num_sectors;

    % number of measurements in complete segments
    num_meas = num_ts* num_meas_per_sect;
    
    if (not_full_sector > 0)
        num_ts = num_ts + 1;
        num_meas_not_full_sect = fix(not_full_sector/50);
        num_meas = num_meas + num_meas_not_full_sect; % total num of meas
    end
    
    % Create array for time stamps
    year = uint32(zeros(1,num_ts));
    mon = uint32(zeros(1,num_ts));
    day = uint32(zeros(1,num_ts));
    hour = uint32(zeros(1,num_ts));
    minute = uint32(zeros(1,num_ts));
    sec = uint32(zeros(1,num_ts));

    segment_ts_err = zeros(1,num_ts);   % order of the segment with ts CRC error

    % Generate time stamps from input data
    i=1; j=1;
    while i <= num_ts
        if cr(j+ts_crc_position) ~= bad_data

            year(i) = uint32(cr(j)) + millenium;

            time_uint32 = swapbytes(typecast(cr((j+1):(j+4)),'uint32'));

            [mon(i),day(i),hour(i),minute(i),sec(i)] = ...
                            extract_time(time_uint32);
            t(i) = datetime(year(i),mon(i),day(i),hour(i),minute(i),sec(i)); % generate datetime values

        else
            segment_ts_err(i) = fix(j/segment_size) + 1;
            t(i) = NaT;        
        end
        i = i + 1;
        j = j + segment_size;
    end

    % Calculate number of TS CRC errors for CRC num display
    crc_tcount=0;
    for i=1:length(t)
       if isnat(t(i))
           crc_tcount=crc_tcount+1;
       end 
    end
    
    
    % Generate full time stamp vector
    [D,H,M,S]=transform_meas_rate(meas_rate);
    
    % In case all time stamps are invalid, use fake time stamp. This is
    % ! temporary for testing only !
    if crc_tcount == length(t)
       temp_t=datetime(clock);
       t(1) = temp_t - num_meas * (days(D)+hours(H)+minutes(M)+seconds(S));
       t_failed = 'True';
    else
       t_failed = 'False';
    end
    
    
    err_free_ts_ind = find(segment_ts_err==0);  % index of elements without error
    err_free_ts_ind = min(err_free_ts_ind);     % choose the minimal value of index (the first err free index)

    if num_ts > 1       
        if err_free_ts_ind > 1 % error free index not the first one
            %do backward counting from index to the first element,
            i=(err_free_ts_ind-1);
            while i>=1
                t(i)=t(i+1)-num_meas_per_sect*(days(D)+...
                    hours(H)+minutes(M)+seconds(S));
                i=i-1;
            end
        end 
       
        ts(1)=t(1);
        for i=2:1:num_meas
            ts(i)= ts(i-1) + days(D)+hours(H)+minutes(M)+seconds(S);
        end 
    else
        ts(1)=t;
        for i=2:1:num_meas
            ts(i)= ts(i-1) + days(D)+hours(H)+minutes(M)+seconds(S);
        end
    end


    %% Process data in spare bytes (5 bytes in the end of each segment)

    %% Generate data matrix

    % convert individual bytes into conversion results of 24 bits for all 16 ch
    % can't use swapbytes(typecast(,'uint32')) easily because I need 4 bytes,
    % and data is 3 bytes. Will use own function "transform_conv_result".


    % position of the conv result MSB for 16 channels starting at ch 1
    conv_res_pos = [8,11,14,17,20,23,26,29,...
                32,35,38,41,44,47,50,53];

    data_spread = 50;   % spread of crc as well as conv result data values
    data_crc_pos = 56;  % position of the first data CRC byte
    spare_bytes = 5;

    meas_result=double(zeros(num_channels,num_meas));

    % convert individual bytes into conversion results of 24 bits for all 16 ch
    % and replace results having CRC error with NaN

    for i=1:num_channels
    k=conv_res_pos(i);
    m=data_crc_pos;
    count=0;
    for  j=1:num_meas
        meas_result(i,j) = transform_conv_result(cr(k),cr(k+1),cr(k+2));
        if (cr(m)==bad_data)
            meas_result(i,j)=NaN;
        end
        count=count+1;
        if (count == 10)
            count = 0;
            k = k +data_spread +spare_bytes +conv_res_pos(1) - 1;
            m = m +data_crc_pos +spare_bytes +1;
        else
            k = k + data_spread;
            m = m + data_spread;
        end

    end
    end  

    % Display number of CRC errors
    % Number of TS CRC errors was determined during TS processing stage
    % Determine num of data CRC errors
    temp_var = meas_result(1,1:end);
    crc_dcount=0;
    for i=1:length(temp_var)
       if isnan(temp_var(i))
           crc_dcount=crc_dcount+1;
       end 
    end
    
    disp(['#Number of time stamps (TS):    ',num2str(num_ts)]);
    disp(['#Number of TS CRC errors:       ',num2str(crc_tcount)]);
    disp(['#Unable to reconstruct TS:      ',t_failed]);
    disp(['#Number of measurements:        ',num2str(num_meas)]);
    disp(['#Number of data CRC errors:     ',num2str(crc_dcount)]);
    
    %% Process and present conv result

    [temperature,voltage,Rth] = PresentConvResult(num_meas,...
                                num_channels,meas_result,ts,op_mode);
    
    %% save workspace and files
    DataRate = num2str(data_rate);
    TimeStamp = datestr(datetime(clock),'yymmddTHHMM');
    FileName = strcat(TimeStamp,'_All_Ch_DR',DataRate);
    save(strcat(FileName,'_code.txt'),'meas_result','-ascii','-double','-tabs');
    save(strcat(FileName,'_volt.txt'),'voltage','-ascii','-double','-tabs');
    save(strcat(FileName,'_rth.txt'),'Rth','-ascii','-double','-tabs');
    save(strcat(FileName,'_temp.txt'),'temperature','-ascii','-double','-tabs');
    save(strcat(FileName,'_ts.mat'),'ts','-mat');
    save(strcat(FileName,'.mat'));
    
end

