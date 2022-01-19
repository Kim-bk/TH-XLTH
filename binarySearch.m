function T = binarySearch(f, g, T_min, T_max)
    T_mid = 0.5 * (T_min + T_max);
    length_f_lower_Tmid = sum(f < T_mid);
    length_g_upper_Tmid = sum(g > T_mid);
    number_lower_T = -1; number_upper_T = -1;
    
    while ~(number_lower_T == length_f_lower_Tmid && number_upper_T == length_g_upper_Tmid)
        state = (1 / length(f(f > T_min)))*sum(f(f > T_mid) - T_mid) - (1 / length(g(g < T_max)))*sum(T_mid - g(g < T_mid));
        if (state > 0)
            T_min = T_mid;
%            binarySearch(f, g, T_mid, T_max, length_x_lower_Tmid, length_x_upper_Tmid);
        else
            T_max = T_mid;
            %binarySearch(f, g, T_min, T_mid, length_x_lower_Tmid, length_x_upper_Tmid);
        end
        T_mid = 0.5 * (T_min + T_max);
        number_lower_T = length_f_lower_Tmid;
        number_upper_T = length_g_upper_Tmid;
        length_f_lower_Tmid = sum(f < T_mid);
        length_g_upper_Tmid = sum(g > T_mid);
        %binarySearch(f(f > T_min), g(g < T_max), T_min, T_max, sum(f < T_mid), length_g_upper_Tmid, length_g_upper_Tmid);
    end
    T = T_mid;
end