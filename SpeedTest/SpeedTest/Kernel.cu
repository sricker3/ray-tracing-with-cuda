
#include "Kernel.h"
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void grayScaleConvertGPU(unsigned char* image, int dimx, int dimy, int d)
{
    int x = threadIdx.x + blockIdx.x * blockDim.x;
	int y = threadIdx.y + blockIdx.y * blockDim.y;

    if(x < dimx && y < dimy)
    {
        unsigned int lum = image[d*(x + y*dimx) + 0]*.2126 + image[d*(x + y*dimx) + 1]*.7152 + image[d*(x + y*dimx) + 2]*.0722;
        image[d*(x + y*dimx) + 0] = (unsigned char) lum;
        image[d*(x + y*dimx) + 1] = (unsigned char) lum;
        image[d*(x + y*dimx) + 2] = (unsigned char) lum;
    }
}

void grayScaleConvert(unsigned char* image, int x, int y, int d)
{
    unsigned char* pixelBuffer;
    cudaMalloc((void**)&pixelBuffer, sizeof(unsigned char)*x*y*d);
    cudaMemcpy(pixelBuffer, image, sizeof(unsigned char)*x*y*d, cudaMemcpyHostToDevice);

    dim3 blocks(roundf(x/16), roundf(y/16));
	dim3 threads(16, 16);
	grayScaleConvertGPU<<<blocks, threads>>>(pixelBuffer, x, y, d);

    cudaMemcpy(image, pixelBuffer, sizeof(unsigned char)*x*y*d, cudaMemcpyDeviceToHost);
	cudaFree(pixelBuffer);
}