function [Vin005,therm_rt_data,dVin001,dt001,resT,dt005ds,dVin005ds,f_number] = analyze_accuracy(Rth_nom,devID,range_id,f_number)

%     % For debug
%     Rth_nom = 20;
%     devID='nice';
%     range_id = 0;   % 1 for -40 to 40, 0 for -50 to 30
%     f_number = 1;
    
    
    % Voltage excitation scheme %

    if Rth_nom==10
        therm_rt_data = load('PR103J2_RT_10K.csv');
        is_10 = 1;
        Rstr='10K';
    else
        if Rth_nom==20
            therm_rt_data = load('PR203J2_RT_20K.csv');
            is_10 = 0;
            Rstr='20K';
        end
    end

    if devID=='nice'
        is_nice = 1;
    else
        if devID=='ugly'
            is_nice = 0;
        end
    end

    Rth=therm_rt_data(1:end,2);
    t005=therm_rt_data(1:end,1);

    %% Data
    RR=116662.3; % ref resistor
    Rwire=0.0079;
    Ron=4.25; % MUX max Ron
    Vref=2.0464; %typ ref V

    %% Voltage resolution and accuracy
    if is_nice
        Rin=Rth+2*Rwire+Ron;            % Resistance on the ADC input
        Vin=Vref*Rin./(RR+Rin);     % ADC Vin
    else
        Rin=Rth+2*Rwire;
        Vin=Vref*Rin./(RR+Rin+Ron);
    end

    % use -40 to 40 C range only
    
    if range_id %  -40 to 40 C range
        start = find(t005==-40);
        stop = find(t005==40);
    else
        start = find(t005==-50);
        stop = find(t005==30);
    end
    
    t005 = t005(start:stop);

    t001=t005(1):0.01:t005(end);    % temp for fitted curve, resolution 0.01 
    dt001=t001(1:(end-1));          % temp for difference

    Vin005 = Vin(start:stop);
 
    if range_id
        % Polinomial interpolation with 7 terms for -40 to 40 C range
        if is_nice && ~is_10 % nice & 20K
            p1 =   -1.07e-13; % (-1.099e-13, -1.04e-13)
            p2 =   1.524e-11; % (1.518e-11, 1.53e-11)
            p3 =   1.501e-10; % (1.423e-10, 1.579e-10)
            p4 =  -9.141e-08; % (-9.154e-08, -9.128e-08)
            p5 =   2.783e-06; % (2.777e-06, 2.789e-06)
            p6 =   0.0002469; % (0.0002468, 0.000247)
            p7 =    -0.02406; % (-0.02406, -0.02406)
            p8 =      0.7345; % (0.7345, 0.7345) 
        else
            if ~is_nice && ~is_10 % ugly & 20K
                p1 =   -1.07e-13; % (-1.099e-13, -1.04e-13)
                p2 =   1.524e-11; % (1.518e-11, 1.53e-11)
                p3 =   1.501e-10; % (1.423e-10, 1.579e-10)
                p4 =  -9.141e-08; % (-9.154e-08, -9.128e-08)
                p5 =   2.783e-06; % (2.777e-06, 2.789e-06)
                p6 =   0.0002469; % (0.0002468, 0.000247)
                p7 =    -0.02406; % (-0.02406, -0.02406)
                p8 =      0.7345; % (0.7345, 0.7345)
            else
                if is_nice && is_10 % nice & 10K  
                    p1 =  -2.217e-13; % (-2.24e-13, -2.194e-13)
                    p2 =   3.038e-12; % (2.992e-12, 3.084e-12)
                    p3 =   1.318e-09; % (1.312e-09, 1.324e-09)
                    p4 =  -6.257e-08; % (-6.267e-08, -6.246e-08)
                    p5 =   -1.55e-06; % (-1.555e-06, -1.545e-06)
                    p6 =   0.0003153; % (0.0003153, 0.0003154)
                    p7 =    -0.01786; % (-0.01786, -0.01786)
                    p8 =      0.4475; % (0.4474, 0.4475)
                else
                    if ~is_nice && is_10 % ugly & 10K
                        p1 =  -2.217e-13; % (-2.24e-13, -2.194e-13)
                        p2 =   3.038e-12; % (2.992e-12, 3.084e-12)
                        p3 =   1.318e-09; % (1.312e-09, 1.324e-09)
                        p4 =  -6.257e-08; % (-6.267e-08, -6.247e-08)
                        p5 =   -1.55e-06; % (-1.555e-06, -1.546e-06)
                        p6 =   0.0003153; % (0.0003153, 0.0003154)
                        p7 =    -0.01786; % (-0.01786, -0.01786)
                        p8 =      0.4474; % (0.4474, 0.4474)
                    end
                end
            end
        end
    else
        % Polinomial interpolation with 6 terms for -50 to 30 C range
        if is_nice && ~is_10 % nice & 20K
            p1 =   1.263e-11; % (1.244e-11, 1.283e-11)
            p2 =  -1.976e-10; % (-2.101e-10, -1.852e-10)
            p3 =  -8.761e-08; % (-8.787e-08, -8.736e-08)
            p4 =   3.044e-06; % (3.029e-06, 3.058e-06)
            p5 =   0.0002452; % (0.000245, 0.0002454)
            p6 =     -0.0241; % (-0.02411, -0.0241)
            p7 =      0.7347; % (0.7346, 0.7347)
        else
            if ~is_nice && ~is_10 % ugly & 20K
                p1 =   1.263e-11; % (1.244e-11, 1.283e-11)
                p2 =  -1.977e-10; % (-2.102e-10, -1.852e-10)
                p3 =  -8.762e-08; % (-8.787e-08, -8.736e-08)
                p4 =   3.044e-06; % (3.03e-06, 3.058e-06)
                p5 =   0.0002452; % (0.000245, 0.0002454)
                p6 =    -0.02411; % (-0.02411, -0.0241)
                p7 =      0.7346; % (0.7346, 0.7347)
            else
                if is_nice && is_10 % nice & 10K  
                    p1 =   1.905e-11; % (1.882e-11, 1.928e-11)
                    p2 =   1.217e-09; % (1.202e-09, 1.231e-09)
                    p3 =  -8.389e-08; % (-8.418e-08, -8.36e-08)
                    p4 =  -1.628e-06; % (-1.644e-06, -1.612e-06)
                    p5 =   0.0003226; % (0.0003224, 0.0003228)
                    p6 =    -0.01784; % (-0.01785, -0.01784)
                    p7 =      0.4471; % (0.447, 0.4471)
                else
                    if ~is_nice && is_10 % ugly & 10K
                        p1 =   1.905e-11; % (1.882e-11, 1.928e-11)
                        p2 =   1.217e-09; % (1.202e-09, 1.231e-09)
                        p3 =   -8.39e-08; % (-8.419e-08, -8.361e-08)
                        p4 =  -1.628e-06; % (-1.644e-06, -1.612e-06)
                        p5 =   0.0003226; % (0.0003224, 0.0003228)
                        p6 =    -0.01784; % (-0.01785, -0.01784)
                        p7 =       0.447; % (0.447, 0.4471)
                    end
                end
            end
        end
    end   
    
    if range_id
        for i = 1:length(t001)  
            Vin001(i) = p1*t001(i)^7 + p2*t001(i)^6 + p3*t001(i)^5 ...
                        + p4*t001(i)^4 + p5*t001(i)^3 ... 
                        + p6*t001(i)^2 + p7*t001(i) + p8;
        end
    else
        for i = 1:length(t001)  
            Vin001(i) = p1*t001(i)^6 + p2*t001(i)^5 + p3*t001(i)^4 ...
                        + p4*t001(i)^3 + p5*t001(i)^2 ... 
                        + p6*t001(i) + p7;
        end
    end
    
    set(0, 'DefaultAxesColorOrder',[0         0.4470    0.7410
                                    0.8500    0.3250    0.0980
                                    0.4940    0.1840    0.5560
                                    0.4660    0.6740    0.1880
                                    0.6350    0.0780    0.1840], ...
          'DefaultAxesLineStyleOrder','-|--')

%     % Check that interpolation works as expected
%     figure(f_number)
%     plot(t005,Vin005,'blue')
%     hold on
%     plot(t001,Vin001,'red')
%     hold off
%     f_number = f_number + 1;


    % Voltage resolution required for 0.01C accuracy
    dVin001=diff(Vin001);
    figure(f_number)
    plot(dt001,1e6*dVin001,'blue')
    title(char(strcat ...
        ({'Min voltage resolution reqd for 0.01\circ C resolution with '}, ...
        {num2str(Rth_nom)},{'K thermistor'})));
    xlabel 'Temperature, \circC'; ylabel 'Voltage resolution, \muV';
    f_number = f_number + 1;

    nVpp=struct('dr5',14.24,'dr10',16.85,'dr20',24.74,'dr40',34.59, ...
                'dr80',43.46, 'dr160',68.28,'dr320',140.06, ...
                'dr640',192.96,'dr1000',388.28,'dr2000',322.85);

    Vin005ds = downsample(Vin005,20); % make 1C scale
    dVin005ds = diff(Vin005ds);
   
    if range_id
        dt005ds = -40:39;
    else
        dt005ds = -50:29;
    end
        
    resT=struct('dr5',1,'dr10',0,'dr20',0,'dr40',0, ...
                'dr80',0, 'dr160',0,'dr320',0, ...
                'dr640',0,'dr1000',0,'dr2000',0);

    fn = fieldnames(nVpp);

    for i=1:numel(fn)      
        resT.(char(fn(i))) = 1e-6*nVpp.(char(fn(i)))./abs(dVin005ds);
    end

    figure(f_number)
    hold on
    for i=1:numel(fn)
        plot(dt005ds,resT.(char(fn(i))));
    end
    plot(dt005ds,(0*dt005ds + 0.01),'-r');
    hold off
    ylim([0 0.12])
    title(char(strcat({'Expected temperature resolution for '},{Rstr},{' thermistor'})));
    xlabel 'Temperature, C'; ylabel 'Temperature resolution, C';
    legend('dr5','dr10','dr20','dr40', 'dr80','dr160','dr320', ...
           'dr640','dr1000','dr2000','Location','eastoutside')
    f_number = f_number + 1;

end