% Gabriel Melendez Melendez
% October 2017


% GET_COMPLEXITY Summary 
% This function receives a block and computes its complexity or noise level

function [NL] = get_complexity(block)
%   
    [sb1,sb2,sb3,sb4] = get_subblocks(block);    
    
    sb1_o = sort(reshape(sb1,[1,4]));
    sb2_o = sort(reshape(sb2,[1,4]));
    sb3_o = sort(reshape(sb3,[1,4]));
    sb4_o = sort(reshape(sb4,[1,4]));    
    
    NL = max([sb1_o(3),sb2_o(3),sb3_o(3),sb4_o(3)]) - min([sb1_o(2),sb2_o(2),sb3_o(2),sb4_o(2)]);
end

