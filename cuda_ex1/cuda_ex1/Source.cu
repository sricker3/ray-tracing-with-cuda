
#include <stdio.h>
#include <string>
#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include "test.cuh"

__global__ void add(int a, int b, int *c, Ball ba)
{
	*c = a + b;
	//*c += getRad();
	*c += ba.getRadius();
}

int main(int argc, char* agrv[])
{
	int host_c;
	int *dev_c;
	Ball ball(5);

	cudaMalloc((void**)&dev_c, sizeof(int));
	add<<< 1,1 >>>(2, 7, dev_c, ball);
	cudaMemcpy(&host_c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);

	std::cout << "2 + 7 + ball radius = " << host_c << std::endl;
	cudaFree(dev_c);

	std::cout << "Enter something then hit enter to close...\n";
	std::string input;
	std::cin >> input;

	return 0;
} //if rename a cpp file to a cu file, right click file to make sure it is being treated as a cu file!!!
//Note: if using avast, you should probably turn off deepscreen under settings->antivirus. Noticed it was causing my vs 2013 programs to run twice and they ran much slower. Still not sure why the debugger output says 2 threads exited.