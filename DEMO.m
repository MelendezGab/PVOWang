% Gabriel Melendez Melendez
% October 2017

% Reversible data hiding scheme based on PVO technique and adaptive block 
% selection strategy, Wang et al., 2016. 


clearvars
state_global_values;        %   Define global paths into .m file
payload_size = 10000;  
block_size_n =4;            %   Block dimensions 4x4
block_size_m =4;            
T1 = 40;                    %   Set thresholds T1[1-255], T2[1,T1]
T2 = 5;                         

global image_path
cover_image = imread(strcat(image_path,'SIPI01.bmp'));
cover_image = cover_image(:,:,1);                                   %   Use rgb2gray if cover image is not grayscale
[hist_mod_image,scan_sec] = histogram_preprocessing(cover_image);   %   Location map is replaced by scan secquence generated into histogram preprocessing
[scan_sec_comp] = compress_locmap(scan_sec);
                              
payload = num2str(round(rand(1,payload_size)));                     %   Random payload 
payload = payload(~isspace(payload));
payload = payload(1:length(payload)-(65+length(scan_sec_comp)));

[blocks_array, blocks_complexity] = get_blocks(hist_mod_image,block_size_n, block_size_m);  %   Non overlapping blocks partition (4x4)

disp('--------------------  EMBEDDING  --------------------');
[marked_image] = embedding(hist_mod_image,blocks_array,blocks_complexity,scan_sec_comp,payload,T1,T2);

disp('--------------------  EXTRACTION  --------------------');
[recovered_image, recovered_payload] = extraction(marked_image);
disp('------------------------------------------------------');
disp(strcat('PSNR (cover_image, marked_image)     :', num2str(psnr(cover_image,marked_image))));
disp(strcat('PSNR (cover_image, recovered_image)  :', num2str(psnr(cover_image,recovered_image))));
show_images;

