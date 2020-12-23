%{
    Function    : pre_emphasis_filter
    Input       : resampled speech signal
    Output      : pre emphasised speech signal
    Description : pre-emphasis filter will be applied to the input signl
%}
function pre_emp_fil_sig = pre_emphasis_filter(speech_sig)
    pre_emp_fil = [1 -0.97];
    pre_emp_fil_sig = filter(pre_emp_fil, 1, speech_sig);
end
