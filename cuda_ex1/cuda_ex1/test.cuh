
#ifndef TEST_H
#define TEST_H

#define CUDA_CALL __host__ __device__

class Ball
{
	private:

		int radius;

	public:

		CUDA_CALL Ball(int r);
		CUDA_CALL int getRadius();
};

__device__ int getRad();

#endif

//needed compute_11,sm_11;compute_13,sm_13;compute_20,sm_20;compute_30,sm_30;compute_35,sm_35;compute_37,sm_37;compute_50,sm_50; under properties->CUDA C/C++->device->code generation, more specifically needed the 35's (or higher I'm guessing). It had only the 20 one before. wait maybe this didnt fix it

//in cuda c/c++ -> common, set generate relocatable device code to yes and it compiled. not sure why this worked as the mandlebrot cuda example has this as no (the example also uses .cu and .cuh)