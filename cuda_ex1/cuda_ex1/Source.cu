
#include <stdio.h>
#include <string>
#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <math_constants.h>
#include "test.cuh"

__global__ void add(int a, int b, int *c, Ball ba)
{
	*c = a + b;
	//*c += getRad();
	ba.setRadius(17);
	*c = ba.getRadius();
	int nein = 99;
	memcpy(c, &nein, sizeof(int));
}

__global__ void test_math(float a, float* ret)
{
	//*ret = sqrtf(a);
	//float inf = 1.0/0.0;
	float inf = CUDART_INF;
	if(4 < inf)
		*ret = CUDART_INF;
	else
		*ret = inf;
}

int main(int argc, char* agrv[])
{
	int host_c;
	int *dev_c;
	float* ret;
	float host_ret;
	Ball ball(5);
	ball.setRadius(3);

	cudaMalloc((void**)&dev_c, sizeof(int));
	cudaMalloc((void**)&ret, sizeof(float));
	add<<< 1,1 >>>(2, 7, dev_c, ball);
	cudaMemcpy(&host_c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);
	test_math<<<1, 1>>>(7, ret);
	cudaMemcpy(&host_ret, ret, sizeof(float), cudaMemcpyDeviceToHost);

	std::cout << "2 + 7 + ball radius = " << host_c << std::endl;
	cudaFree(dev_c);
	std::cout<<"sqrt(7) = "<<host_ret<<std::endl;
	printf("0x%08x\n", host_ret);

	cudaFree(ret);

	std::cout << "Enter something then hit enter to close...\n";
	std::string input;
	std::cin >> input;

	return 0;
} //if rename a cpp file to a cu file, right click file to make sure it is being treated as a cu file!!!
//Note: if using avast, you should probably turn off deepscreen under settings->antivirus. Noticed it was causing my vs 2013 programs to run twice and they ran much slower. Still not sure why the debugger output says 2 threads exited.