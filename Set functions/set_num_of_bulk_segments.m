function set_num_of_bulk_segments(obj)

    global set_num_bulk_segm;
    global num_segm_bulk; 
    
    accepted_value = 1;    

    while(accepted_value)
        disp('#Valid number of bulk segments is 1 - 48');
        prompt = '#Enter number of bulk segments: ';
        number_conv = input(prompt);
        if ((number_conv > 0) && (number_conv <  49))
            accepted_value = 0;
        else
            disp('#Error. Number of segments must be within 1 - 48 range');
            pause(1)
        end
    end
      
    num_segm_bulk = number_conv;
      
    message =  [set_num_bulk_segm, number_conv];

    send_set_cmd(obj,set_num_bulk_segm,message);
end

