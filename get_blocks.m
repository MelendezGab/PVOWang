% Gabriel Melendez Melendez
% October 2017

function [blocks_array, blocks_complexity, loc_map] = get_blocks(image, block_size_n, block_size_m)
    [num_fi, num_ci] = size(image);
    % Blocks number in each dimension 
    num_fb = floor(num_fi/block_size_n); 
    num_cb = floor(num_ci/block_size_m); 
    %----------------------------------------------------------------------
    loc_map = '';
    loc_map(1:num_fb*num_cb)='0';
    blocks_complexity    = zeros(1,num_fb*num_cb);
    blocks_array = cell(1,num_fb*num_cb);
    cont = 0;
    
    for i = 1:(num_fb)
        for j = 1:(num_cb)
            a = ((i-1)*block_size_n)+1;
            b = ((j-1)*block_size_m)+1;
            block = image(a:a+(block_size_n-1),b:b+(block_size_m-1));
            cont = cont + 1;
            blocks_complexity(cont) = get_complexity(block);
            blocks_array{cont} = double(block);   
            if(max(block(:))==255 || min(block(:)) == 0)
                loc_map(cont)='1';
            end
        end
    end  
end