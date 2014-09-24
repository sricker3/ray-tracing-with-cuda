
#define _CRT_SECURE_NO_DEPRECATE //stops fopen, strcpy warning errors
#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION

#include <string>
#include <iostream>
#include <chrono>
#include "stb_image.h"
#include "stb_image_write.h"
#include "Kernel.h"

int main(int argc, char** agrv)
{
    int x,y,d;
    unsigned char* oim1 = stbi_load("big_image.jpg", &x, &y, &d, 0);
    int x2,y2,d2;
    unsigned char* oim2 = stbi_load("big_image2.jpg", &x2, &y2, &d2, 0);
    int x3,y3,d3;
    unsigned char* oim3 = stbi_load("big_image3.jpg", &x3, &y3, &d3, 0);

    if(oim1 == NULL || oim2 == NULL || oim3 == NULL)
        return 1;

    unsigned char* im1 = (unsigned char*) malloc(sizeof(char)*x*y*d);
    memcpy(im1, oim1, sizeof(char)*x*y*d);

    unsigned char* im2 = (unsigned char*) malloc(sizeof(char)*x2*y2*d2);
    memcpy(im2, oim2, sizeof(char)*x2*y2*d2);

    unsigned char* im3 = (unsigned char*) malloc(sizeof(char)*x3*y3*d3);
    memcpy(im3, oim3, sizeof(char)*x3*y3*d3);

    unsigned char* im4 = (unsigned char*) malloc(sizeof(char)*x*y*d);
    memcpy(im4, oim1, sizeof(char)*x*y*d);

    unsigned char* im5 = (unsigned char*) malloc(sizeof(char)*x2*y2*d2);
    memcpy(im5, oim2, sizeof(char)*x2*y2*d2);

    unsigned char* im6 = (unsigned char*) malloc(sizeof(char)*x3*y3*d3);
    memcpy(im6, oim3, sizeof(char)*x3*y3*d3);

    std::cout<<"cpu start\n";
    auto start = std::chrono::high_resolution_clock::now();

    for(int row=0; row<y; row++)
    {
        for(int col=0; col<x; col++)
        {
            unsigned int lum = im1[d*(col + row*x) + 0]*.2126 + im1[d*(col + row*x) + 1]*.7152 + im1[d*(col + row*x) + 2]*.0722;
            im1[d*(col + row*x) + 0] = (unsigned char) lum;
            im1[d*(col + row*x) + 1] = (unsigned char) lum;
            im1[d*(col + row*x) + 2] = (unsigned char) lum;
        }
    }

    for(int row=0; row<y2; row++)
    {
        for(int col=0; col<x2; col++)
        {
            unsigned int lum = im2[d2*(col + row*x2) + 0]*.2126 + im2[d2*(col + row*x2) + 1]*.7152 + im2[d2*(col + row*x2) + 2]*.0722;
            im2[d2*(col + row*x2) + 0] = (unsigned char) lum;
            im2[d2*(col + row*x2) + 1] = (unsigned char) lum;
            im2[d2*(col + row*x2) + 2] = (unsigned char) lum;
        }
    }

    for(int row=0; row<y3; row++)
    {
        for(int col=0; col<x3; col++)
        {
            unsigned int lum = im3[d3*(col + row*x3) + 0]*.2126 + im3[d3*(col + row*x3) + 1]*.7152 + im3[d3*(col + row*x3) + 2]*.0722;
            im3[d3*(col + row*x3) + 0] = (unsigned char) lum;
            im3[d3*(col + row*x3) + 1] = (unsigned char) lum;
            im3[d3*(col + row*x3) + 2] = (unsigned char) lum;
        }
    }

    auto finish = std::chrono::high_resolution_clock::now();
    std::cout<<"converting images on cpu took: "<<std::chrono::duration_cast<std::chrono::nanoseconds>(finish-start).count() <<" ns\n";
    std::cout<<"end cpu\n";

    std::cout<<"start gpu\n";
    auto start2 = std::chrono::high_resolution_clock::now();

    grayScaleConvert(im4, x, y, d);
    grayScaleConvert(im5, x2, y2, d2);
    grayScaleConvert(im6, x3, y3, d3);

    auto finish2 = std::chrono::high_resolution_clock::now();
    std::cout<<"converting images on gpu took: "<<std::chrono::duration_cast<std::chrono::nanoseconds>(finish2-start2).count() <<" ns\n";
    std::cout<<"end gpu\n";

    char imgName[25];
	strcpy(imgName, "cpuGray1.bmp");
    if(!stbi_write_bmp(imgName, x, y, d, im1))
	{
		std::cout<<"error writing image1 auugg\n";
	}
    free(im1);

	strcpy(imgName, "cpuGray2.bmp");
    if(!stbi_write_bmp(imgName, x2, y2, d2, im2))
	{
		std::cout<<"error writing image2 auugg\n";
	}
    free(im2);

	strcpy(imgName, "cpuGray3.bmp");
    if(!stbi_write_bmp(imgName, x3, y3, d3, im3))
	{
		std::cout<<"error writing image3 auugg\n";
	}
    free(im3);

    strcpy(imgName, "gpuGray1.bmp");
    if(!stbi_write_bmp(imgName, x, y, d, im4))
	{
		std::cout<<"error writing image1 auugg\n";
	}
    free(im4);

	strcpy(imgName, "gpuGray2.bmp");
    if(!stbi_write_bmp(imgName, x2, y2, d2, im5))
	{
		std::cout<<"error writing image2 auugg\n";
	}
    free(im5);

	strcpy(imgName, "gpuGray3.bmp");
    if(!stbi_write_bmp(imgName, x3, y3, d3, im6))
	{
		std::cout<<"error writing image3 auugg\n";
	}
    free(im6);

    stbi_image_free(oim1);
    stbi_image_free(oim2);
    stbi_image_free(oim3);

    std::cout << "Enter something then hit enter to close...\n";
	std::string input;
	std::cin >> input;

    return 0;
}

//gpu ~4.5 faster than cpu using intel i7 and gtx 780 ti using this code on windows 8.1
//I expected the gpu to be much faster, but I am by no means an expert at cuda so perhaps 
//the implementation of the code could be improved to increase gpu speed. One thought 
//would be to change the kernel call to take in multiple images at the same time in
//an effort to reduce overhead incurred from multiple calls.


