% Gabriel Melendez Melendez
% January 2018

global results_path;
figure
set(gcf,'name','Images evaluation','Position', [20 20 800 750]); 
subplot(2, 2, 1);
imshow(cover_image);
title('Original image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2, 2, 2);
imshow(uint8(marked_image));
text(0.3,-0.1, strcat('PSNR = ',{' '},num2str(psnr(cover_image,marked_image))), 'Units', 'normalized')
title(strcat('Marked image with ',{' '},num2str(payload_size),' bits'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2, 2, 3);
imshow(uint8(recovered_image));
text(0.3,-0.1, strcat('PSNR = ',{' '},num2str(psnr(cover_image,recovered_image))), 'Units', 'normalized')
title('Recovered image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2, 2, 4);
imshow(uint8(cover_image-recovered_image));
text(0.3,-0.1, 'Pixel wise difference', 'Units', 'normalized')
title('Original vs recovered images');

saveas(gcf,char(strcat(results_path,'Obtained results wirh',{' '},'T1=',num2str(T1),{' '},' and T2=',num2str(T1),{' '},'-',{' '},num2str(payload_size),{' '},' bits.png')));

