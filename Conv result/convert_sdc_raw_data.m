function [conv_result] = convert_sdc_raw_data (raw_data)

    conv_result = zeros(1,length(raw_data));
    i=1;
    while i <= length(raw_data)
        conv_result(i) = raw_data(i+3);
        conv_result(i+1) = raw_data(i+2);
        conv_result(i+2) = raw_data(i+1);
        conv_result(i+3) = raw_data(i);
        i = i + 4;
    end

end