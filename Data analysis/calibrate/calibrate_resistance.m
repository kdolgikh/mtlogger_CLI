function [cal_resistance] = calibrate_resistance (data_rate, uncal_resistance)

    RmeasDMM = [4982.33; 10701.6; 13001.0; 16002.0; 19997.8; ...
                24894.3; 31597.6; 39001.5; 50998.9; 60001.5; 84516; ...
                109802; 147032; 196078; 261052; 356756; 487418; 665405];
    
    if data_rate == 5
        Rmeas = load('Rmeas_dr5_wo_Rin.mat');
        Rmeas_dr5 = Rmeas.Rmeas; % load function creates a struct. This line accesses variable from this struct
        R_diff_5 = RmeasDMM - Rmeas_dr5;
        if uncal_resistance >= min(Rmeas_dr5) && uncal_resistance <= max(Rmeas_dr5)       
            cal_value = interp1(Rmeas_dr5,R_diff_5,uncal_resistance,'pchip');
        else
            cal_value = interp1(Rmeas_dr5,R_diff_5,uncal_resistance,'pchip','extrap');
        end
    else
        if data_rate == 10
            Rmeas = load('Rmeas_dr10_wo_Rin.mat');
            Rmeas_dr10 = Rmeas.Rmeas;
            R_diff_10 = RmeasDMM - Rmeas_dr10;
            if uncal_resistance >= min(Rmeas_dr10) && uncal_resistance <= max(Rmeas_dr10)  
                cal_value = interp1(Rmeas_dr10,R_diff_10,uncal_resistance,'pchip'); 
            else
                cal_value = interp1(Rmeas_dr10,R_diff_10,uncal_resistance,'pchip','extrap');
            end
        end
    end

    cal_resistance = uncal_resistance + cal_value; % cal_value is negative

end