% Gabriel Melendez Melendez
% October 2017

function [] = state_global_values()
    global comp_in comp_out comp_dec image_path results_path arith_coder_path;  
    
    root_path           = 'C:\Users\Gabriel\Documents\GitHub\PVOWang\';     
    comp_in             = strcat(root_path,'arithmetic_coder_files\in.txt');    %   Files required to use arithmetic coding
    comp_out            = strcat(root_path,'arithmetic_coder_files\out.txt');
    comp_dec            = strcat(root_path,'arithmetic_coder_files\salidades.txt');
    
    image_path          = strcat(root_path,'img\');                             %   Images path without name
    results_path        = strcat(root_path,'results\');                     %   Path in which image results will be saved
    arith_coder_path    = strcat(root_path,'codificador_aritmetico.jar');       %   Path and name to the arithmetic coder .jar file
end
