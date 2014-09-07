
#include "test.cuh"

CUDA_CALL Ball::Ball(int r)
{
	radius = r;
}

CUDA_CALL int Ball::getRadius()
{
	return radius;
}


__device__ int getRad()
{
	return 3;
}