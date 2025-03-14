# Raster Graphics

The "Raster Graphics" project analyzes and compares various raster image compression methods, both lossless (PNG, GIF) and lossy (JPG, JPEG2000), evaluating their impact on file size and image quality through PSNR and SSIM calculations.

## Features

The project includes the following functions:

* **processImagePNGGIF()**: Converts images to PNG and GIF formats, compares file sizes, and calculates PSNR and SSIM.
* **processImageJPEGJPEG2000()**: Compresses images using JPG and JPEG2000 algorithms with predefined quality levels and compression ratios, compares file sizes, and calculates PSNR and SSIM.
* **generateJPEGJPEG2000Statistics()**: Generates detailed statistics for JPEG and JPEG2000 compression, including file sizes, PSNR, and SSIM, for a range of quality levels and compression ratios. It also generates plots to visualize the relationship between file size and image quality metrics.
* **imageProcessor()**: Allows the user to select the function to execute.

## How to Use

1.  Ensure you have MATLAB installed.
2.  Clone this repository to your local machine.
3.  Open MATLAB and navigate to the project folder.
4.  Run the `imageProcessor()` function.
5.  Follow the on-screen instructions to select an image and choose the desired processing function.

## Requirements

* MATLAB

## Compression Parameters

* **JPG**: Quality levels are set to [1, 25, 50, 75, 100]. Higher values mean better quality but larger file size.
* **JPEG2000**: Compression ratios are set to [1, 5, 30, 140, 250]. Higher values mean higher compression but lower quality.

## Additional Feature: generateJPEGJPEG2000Statistics()

The `generateJPEGJPEG2000Statistics()` function has been added to provide a more comprehensive analysis of JPEG and JPEG2000 compression. When selected, this function:

1.  Prompts the user to select an image.
2.  Compresses the image using JPEG with quality levels from 1 to 100 (in steps of 2).
3.  Compresses the image using JPEG2000 with compression ratios from 1 to 100 (in steps of 1).
4.  Calculates and displays the file size, PSNR, and SSIM for each compression level.
5.  Generates plots showing:
    * PSNR vs. Image Size
    * SSIM vs. Image Size

### Summary

It is evident that JPEG2000 offers superior quality (higher PSNR and SSIM) at smaller file sizes compared to JPEG, especially within the range of smaller file sizes. Both formats demonstrate a decrease in quality as the file size diminishes, which is typical for lossy compression.

PSNR is a widely used metric to quantify the quality of reconstructed images after compression. Higher PSNR values generally indicate that the reconstructed image is closer to the original, with less distortion.

SSIM is designed to assess the perceived quality of images by considering structural information. It aims to better reflect human visual perception compared to PSNR.

## Note

* JPG uses Discrete Cosine Transform, and JPEG2000 uses Wavelet Transform.

## License

This project is licensed under the MIT License.
