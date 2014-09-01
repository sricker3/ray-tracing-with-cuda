
#include <stdio.h>
#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void add(int a, int b, int *c)
{
	*c = a + b;
}

int main(int argc, char* agrv[])
{
	int host_c;
	int *dev_c;

	cudaMalloc((void**)&dev_c, sizeof(int));
	add<<< 1,1 >>>(2, 7, dev_c);
	cudaMemcpy(&host_c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);

	std::cout << "2 + 7 = " << host_c << std::endl;
	cudaFree(dev_c);

	return 0;
} //if rename a cpp file to a cu file, right click file to make sure it is being treated as a cu file!!!