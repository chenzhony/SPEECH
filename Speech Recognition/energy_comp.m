%{
    Function    : energy_comp
    Input       : DCT speech signal
    Output      : DCT signal with energy component added
    Description : Energy component is calculated and added to the DCT
    signal
%}

function dct_signal = energy_comp(dct_signal)
    energy_val = 0;
    for i = 1:length(dct_signal)
        energy_val = energy_val + dct_signal(i)*dct_signal(i);
    end
    dct_signal(length(dct_signal)+1) = energy_val;
end