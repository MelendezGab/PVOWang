% Gabriel Melendez Melendez
% October 2017

function [ sb1,sb2,sb3,sb4 ] = get_subblocks(block)
    sb1 = block(1:2,1:2);
    sb2 = block(1:2, 3:4);
    sb3 = block(3:4,1:2);
    sb4 = block(3:4, 3:4);
end

