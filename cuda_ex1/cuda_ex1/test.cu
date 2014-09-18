
#include "test.cuh"

CUDA_CALL Ball::Ball(int r)
{
	radius = r;
}

CUDA_CALL int Ball::getRadius()
{
	return radius;
}

CUDA_CALL void Ball::setRadius(int r)
{
	radius = r;
}


__device__ float getRad()
{
	return 1.0f/0.0f;
}