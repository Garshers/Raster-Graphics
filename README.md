# Raster Graphics

The "Raster Graphics" project analyzes and compares various raster image compression methods, both lossless (PNG, GIF) and lossy (JPG, JPEG2000), evaluating their impact on file size and image quality through PSNR calculations.

## Features

The project includes the following functions:

* **processImagePNGGIF()**: Converts images to PNG and GIF formats, compares file sizes, and calculates PSNR.
* **processImageJPEGJPEG2000()**: Compresses images using JPG and JPEG2000 algorithms with different compression levels, compares file sizes, and calculates PSNR.
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

* **JPG**: Q1 and Q2 represent the quality levels (0-100). Higher values mean better quality but larger file size.
* **JPEG2000**: CR1 and CR2 represent the compression ratios. Higher values mean higher compression but lower quality.

## Note

* JPG uses Discrete Cosine Transform, and JPEG2000 uses Wavelet Transform.

## License

This project is licensed under the MIT License.