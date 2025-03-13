function imageProcessor()
    choice = input('Choose an image processing function:\n1. PNG and GIF conversion\n2. JPG and JPEG2000 compression\n3. Generate Statistics for JPEG/JPEG2000\n4. Clear command\nYour choice: ');
    switch choice
        case 1
            fprintf('----- Processing  Image PNG/GIF() -----\n');
            processImagePNGGIF();
        case 2
            fprintf('----- Process Image JPEG/JPEG2000() -----\n');
            processImageJPEGJPEG2000();
        case 3
            fprintf('----- Generate Statistics for JPEG/JPEG2000 -----\n');
            generateJPEGJPEG2000Statistics();
        case 4
            clc;
            clear all;
            close all;
        otherwise
            fprintf('Invalid choice.\n');
    end
end

function processImagePNGGIF()
    [filename, pathname] = uigetfile({'*.bmp;*.tiff;*'}, 'Select an image (BMP or TIFF)');
    if isequal(filename, 0)
        fprintf('User cancelled file selection.\n');
        return;
    end
    originalImage = imread(fullfile(pathname, filename));

    % Check the number of gray/color levels
    if size(originalImage, 3) == 1 % Grayscale
        numLevels = length(unique(originalImage));
    else % RGB
        numLevels = length(unique(reshape(originalImage, [], 1)));
    end
    fprintf('Number of levels: %d\n', numLevels);

    imwrite(originalImage, 'output.png');
    if size(originalImage, 3) == 3  %RGB
        [indexedImage, cmap] = rgb2ind(originalImage, 256); 
        imwrite(indexedImage, cmap, 'output.gif'); 
    else %grayscale
        imwrite(originalImage, 'output.gif'); 
    end
    pngImage = imread('output.png');
    gifImage = imread('output.gif');
    if size(originalImage, 3) == 3  %RGB
        pngImage = im2double(pngImage); 
        gifImage = ind2rgb(gifImage, cmap); 
        gifImage = im2double(gifImage);
    else %grayscale
        pngImage = im2double(rgb2gray(pngImage)); 
        gifImage = im2double(gifImage); 
    end
    fileInfoOriginal = dir(fullfile(pathname, filename));
    fileInfoPNG = dir('output.png');
    fileInfoGIF = dir('output.gif');
    fprintf('File sizes:\n');
    fprintf('Original (%s): %d bytes\n', filename, fileInfoOriginal.bytes);
    fprintf('PNG: %d bytes\n', fileInfoPNG.bytes);
    fprintf('GIF: %d bytes\n', fileInfoGIF.bytes);
    %PSNR
    psnr_png = psnr(im2double(originalImage), pngImage);
    psnr_gif = psnr(im2double(originalImage), gifImage);

    % PSNR = Inf handling
    if isinf(psnr_png)
        fprintf('PSNR PNG: Inf dB (Identical images)\n');
    else
        fprintf('PSNR PNG: %.2f dB\n', psnr_png);
    end
    fprintf('PSNR GIF: %.2f dB\n', psnr_gif);
end

function processImageJPEGJPEG2000()
    [filename, pathname] = uigetfile({'*.bmp;*.tiff;*'}, 'Select original image (BMP or TIFF)');
    if isequal(filename, 0)
        fprintf('User cancelled file selection.\n');
        return;
    end
    originalImage = imread(fullfile(pathname, filename));
    fileInfoOriginal = dir(fullfile(pathname, filename));
    %JPG
    Q1 = 50; 
    Q2 = 10; 
    %JPEG2000
    CR1 = 10; 
    CR2 = 50; 
    %JPG with different quality levels
    imwrite(originalImage, 'output_Q1.jpg', 'Quality', Q1);
    imwrite(originalImage, 'output_Q2.jpg', 'Quality', Q2);
    %JPEG2000 with different compression ratios
    imwrite(originalImage, 'output_CR1.jp2', 'CompressionRatio', CR1);
    imwrite(originalImage, 'output_CR2.jp2', 'CompressionRatio', CR2);
    jpg_Q1 = imread('output_Q1.jpg');
    jpg_Q2 = imread('output_Q2.jpg');
    jp2_CR1 = imread('output_CR1.jp2');
    jp2_CR2 = imread('output_CR2.jp2');
    psnr_jpg_Q1 = psnr(originalImage, jpg_Q1);
    psnr_jpg_Q2 = psnr(originalImage, jpg_Q2);
    psnr_jp2_CR1 = psnr(originalImage, jp2_CR1);
    psnr_jp2_CR2 = psnr(originalImage, jp2_CR2);
    fileInfo_Q1 = dir('output_Q1.jpg');
    fileInfo_Q2 = dir('output_Q2.jpg');
    fileInfo_CR1 = dir('output_CR1.jp2');
    fileInfo_CR2 = dir('output_CR2.jp2');
    %results
    fprintf('\nFile sizes:\n');
    fprintf('Original: %d bytes\n', fileInfoOriginal.bytes);
    fprintf('JPG Q1 (%d%% quality): %d bytes\n', Q1, fileInfo_Q1.bytes);
    fprintf('JPG Q2 (%d%% quality): %d bytes\n', Q2, fileInfo_Q2.bytes);
    fprintf('JPEG2000 CR1 (CR=%d): %d bytes\n', CR1, fileInfo_CR1.bytes);
    fprintf('JPEG2000 CR2 (CR=%d): %d bytes\n', CR2, fileInfo_CR2.bytes);
    fprintf('\nPSNR values:\n');
    fprintf('JPG Q1 (%d%% quality): %.2f dB\n', Q1, psnr_jpg_Q1);
    fprintf('JPG Q2 (%d%% quality): %.2f dB\n', Q2, psnr_jpg_Q2);
    fprintf('JPEG2000 CR1 (CR=%d): %.2f dB\n', CR1, psnr_jp2_CR1);
    fprintf('JPEG2000 CR2 (CR=%d): %.2f dB\n', CR2, psnr_jp2_CR2);
    % Compression parameter explanation
    fprintf('\nCompression parameters:\n');
    fprintf('JPG: Q1 and Q2 represent the quality levels (0-100). Higher values mean better quality but larger file size.\n');
    fprintf('JPEG2000: CR1 and CR2 represent the compression ratios. Higher values mean higher compression but lower quality.\n');
    fprintf('Note: JPG uses Discrete Cosine Transform, JPEG2000 uses Wavelet Transform.\n');

end

function generateJPEGJPEG2000Statistics()
    [filename, pathname] = uigetfile({'*.bmp;*.tiff;*'}, 'Select original image (BMP or TIFF)');
    if isequal(filename, 0)
        fprintf('User cancelled file selection.\n');
        return;
    end
    originalImage = imread(fullfile(pathname, filename));
    
    % JPG Statistics
    qualityLevels = 5:5:100;
    jpgFileSizes = zeros(size(qualityLevels));
    jpgPSNR = zeros(size(qualityLevels));
    jpgSSIM = zeros(size(qualityLevels));
    
    for i = 1:length(qualityLevels)
        imwrite(originalImage, sprintf('temp_Q%d.jpg', qualityLevels(i)), 'Quality', qualityLevels(i));
        jpgFileSizes(i) = dir(sprintf('temp_Q%d.jpg', qualityLevels(i))).bytes / 1024; % in kB
        compressedImage = imread(sprintf('temp_Q%d.jpg', qualityLevels(i)));
        jpgPSNR(i) = psnr(originalImage, compressedImage);
        jpgSSIM(i) = ssim(originalImage, compressedImage);
        delete(sprintf('temp_Q%d.jpg', qualityLevels(i))); % Clean up temporary files
    end
    
    % JPEG2000 Statistics
    compressionRatios = 1:2:101;
    jp2FileSizes = zeros(size(compressionRatios));
    jp2PSNR = zeros(size(compressionRatios));
    jp2SSIM = zeros(size(compressionRatios));
    
    for i = 1:length(compressionRatios)
        imwrite(originalImage, sprintf('temp_CR%d.jp2', compressionRatios(i)), 'CompressionRatio', compressionRatios(i));
        jp2FileSizes(i) = dir(sprintf('temp_CR%d.jp2', compressionRatios(i))).bytes / 1024; % in kB
        compressedImage = imread(sprintf('temp_CR%d.jp2', compressionRatios(i)));
        jp2PSNR(i) = psnr(originalImage, compressedImage);
        jp2SSIM(i) = ssim(originalImage, compressedImage);
        delete(sprintf('temp_CR%d.jp2', compressionRatios(i))); % Clean up temporary files
    end
    
    % Display Results
    fprintf('\n----- JPEG Statistics -----\n');
    fprintf('Quality Levels: ');
    fprintf('%d ', qualityLevels);
    fprintf('\nFile Sizes (kB): ');
    fprintf('%.2f ', jpgFileSizes);
    fprintf('\nPSNR (dB): ');
    fprintf('%.2f ', jpgPSNR);
    fprintf('\nSSIM: ');
    fprintf('%.2f ', jpgSSIM);
    fprintf('\n\n----- JPEG2000 Statistics -----\n');
    fprintf('Compression Ratios: ');
    fprintf('%d ', compressionRatios);
    fprintf('\nFile Sizes (kB): ');
    fprintf('%.2f ', jp2FileSizes);
    fprintf('\nPSNR (dB): ');
    fprintf('%.2f ', jp2PSNR);
    fprintf('\nSSIM: ');
    fprintf('%.2f ', jp2SSIM);
    fprintf('\n');
    
    figure;
    
    % Plot PSNR vs. Image Size
    subplot(1, 2, 1);
    plot(jpgFileSizes, jpgPSNR, '-o', 'DisplayName', 'JPEG');
    hold on;
    plot(jp2FileSizes, jp2PSNR, '-x', 'DisplayName', 'JPEG2000');
    hold off;
    xlabel('Image Size [kB]');
    ylabel('PSNR [dB]');
    title('PSNR vs. Image Size');
    legend('show');
    
    % Plot SSIM vs. Image Size
    subplot(1, 2, 2);
    plot(jpgFileSizes, jpgSSIM, '-o', 'DisplayName', 'JPEG');
    hold on;
    plot(jp2FileSizes, jp2SSIM, '-x', 'DisplayName', 'JPEG2000');
    hold off;
    xlabel('Image Size [kB]');
    ylabel('SSIM');
    title('SSIM vs. Image Size');
    legend('show');
end

imageProcessor();