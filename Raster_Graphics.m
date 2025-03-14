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

    ssim_gif = ssim(im2double(originalImage), gifImage);

    describedPNG = insertText(pngImage, [10 10], sprintf('No compression (BMP):\nSize %2.f kB\nPNG (PSNR: %.2f dB)\nSize: %.2f kB', fileInfoPNG.bytes  / 1024, psnr_png, fileInfoPNG.bytes / 1024), 'FontSize', 14, 'TextColor', 'black', 'BoxOpacity', 0.4);
    imwrite(describedPNG, 'PNGoutput.png');

    describedGIF = insertText(pngImage, [10 10], sprintf('GIF\nSize: %.2f kB\nPSNR: %.2f dB\nSSIM: %.4f', fileInfoGIF.bytes / 1024, psnr_gif, ssim_gif), 'FontSize', 14, 'TextColor', 'black', 'BoxOpacity', 0.4);
    [indexedImage, cmap] = rgb2ind(describedGIF, 256); 
    imwrite(indexedImage, cmap, 'GIFoutput.png');

    delete(sprintf('output.png'));
    delete(sprintf('output.gif'));
end

function processImageJPEGJPEG2000()
    [filename, pathname] = uigetfile({'*.bmp;*.tiff;*'}, 'Select original image (BMP or TIFF)');
    if isequal(filename, 0)
        fprintf('User cancelled file selection.\n');
        return;
    end
    originalImage = imread(fullfile(pathname, filename));
    fileInfoOriginal = dir(fullfile(pathname, filename));
    % JPG
    Q = [1, 25, 50, 75, 100];
    jpgFilenames = {'output_Q1.jpg', 'output_Q2.jpg', 'output_Q3.jpg', 'output_Q4.jpg', 'output_Q5.jpg'};
    jpgData = cell(size(Q));
    psnr_jpg = zeros(size(Q));
    ssim_jpg = zeros(size(Q));
    fileInfo_jpg = cell(size(Q));
    % JPEG2000
    CR = [1, 5, 30, 140, 250];
    jp2Filenames = {'output_CR1.jp2', 'output_CR2.jp2', 'output_CR3.jp2', 'output_CR4.jp2', 'output_CR5.jp2'};
    jp2Data = cell(size(CR));
    psnr_jp2 = zeros(size(CR));
    ssim_jp2 = zeros(size(CR));
    fileInfo_jp2 = cell(size(CR));
    % JPG Processing
    for i = 1:length(Q)
        imwrite(originalImage, jpgFilenames{i}, 'Quality', Q(i));
        jpgData{i} = imread(jpgFilenames{i});
        psnr_jpg(i) = psnr(originalImage, jpgData{i});
        ssim_jpg(i) = ssim(originalImage, jpgData{i});
        fileInfo_jpg{i} = dir(jpgFilenames{i});
        
        % Description for JPG
        describedImage = insertText(jpgData{i}, [10 10], sprintf('JPG Q%d (%d%% quality)\nSize: %.2f kB\nPSNR: %.2f dB\nSSIM: %.4f', i, Q(i), fileInfo_jpg{i}.bytes / 1024, psnr_jpg(i), ssim_jpg(i)), 'FontSize', 14, 'TextColor', 'black', 'BoxOpacity', 0.4);
        imwrite(describedImage, jpgFilenames{i});
    end
    % JPEG2000 Processing
    for i = 1:length(CR)
        imwrite(originalImage, jp2Filenames{i}, 'CompressionRatio', CR(i));
        jp2Data{i} = imread(jp2Filenames{i});
        psnr_jp2(i) = psnr(originalImage, jp2Data{i});
        ssim_jp2(i) = ssim(originalImage, jp2Data{i});
        fileInfo_jp2{i} = dir(jp2Filenames{i});
        % Description for JPEG2000
        describedImage = insertText(jp2Data{i}, [10 10], sprintf('JPEG2000 CR%d (CR=%d)\nSize: %.2f kB\nPSNR: %.2f dB\nSSIM: %.4f', i, CR(i), fileInfo_jp2{i}.bytes / 1024, psnr_jp2(i), ssim_jp2(i)), 'FontSize', 14, 'TextColor', 'black', 'BoxOpacity', 0.4);
        imwrite(describedImage, jp2Filenames{i});
    end
    % results
    fprintf('\nFile sizes:\n');
    fprintf('Original: %d bytes\n', fileInfoOriginal.bytes);
    for i = 1:length(Q)
        fprintf('JPG Q%d (%d%% quality): %d bytes\n', i, Q(i), fileInfo_jpg{i}.bytes);
    end
    for i = 1:length(CR)
        fprintf('JPEG2000 CR%d (CR=%d): %d bytes\n', i, CR(i), fileInfo_jp2{i}.bytes);
    end
    % PSNR values
    fprintf('\nPSNR values:\n');
    for i = 1:length(Q)
        fprintf('JPG Q%d (%d%% quality): %.2f dB\n', i, Q(i), psnr_jpg(i));
    end
    for i = 1:length(CR)
        fprintf('JPEG2000 CR%d (CR=%d): %.2f dB\n', i, CR(i), psnr_jp2(i));
    end
    % SSIM values
    fprintf('\nSSIM values:\n');
    for i = 1:length(Q)
        fprintf('JPG Q%d (%d%% quality): %.4f\n', i, Q(i), ssim_jpg(i));
    end
    for i = 1:length(CR)
        fprintf('JPEG2000 CR%d (CR=%d): %.4f\n', i, CR(i), ssim_jp2(i));
    end

    % Compression parameter explanation
    fprintf('\nCompression parameters:\n');
    fprintf('JPG: Q1, Q2, and Q3 represent the quality levels (0-100). Higher values mean better quality but larger file size.\n');
    fprintf('JPEG2000: CR1, CR2, and CR3 represent the compression ratios. Higher values mean higher compression but lower quality.\n');
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
    qualityLevels = 1:2:100;
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
    compressionRatios = 1:1:100;
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