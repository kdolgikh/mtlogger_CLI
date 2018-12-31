function [Month,Day,Hour,Minute,Second] = extract_time(time_uint32)

        % Bitwise AND with 0x1F to zero bits 4-7
        % mon is 4 bit long
        Month = bitand(bitsrl(time_uint32,28),15);  
        
        % Bitwise AND with 0x1F to zero bits 5-7
        % day is 5 bit long
        Day = bitand(bitsrl(time_uint32,23),31);
        
        % Bitwise AND with 0x1F to zero bits 5-7
        % hour is 5 bit long
        Hour = bitand(bitsrl(time_uint32,18),31);
        
        % Bitwise AND with 0x1F to zero bits 6-7
        % min is 6 bit long
        Minute = bitand(bitsrl(time_uint32,12),63);
        
        % Bitwise AND with 0x1F to zero bits 6-7
        % sec is 6 bit long
        Second = bitand(bitsrl(time_uint32,6),63);

end

