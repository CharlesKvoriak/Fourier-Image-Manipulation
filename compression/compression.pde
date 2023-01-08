PImage image;
int red, green, blue;

void setup(){
	size(1000, 1000);
	//surface.setResizable(true);

	image = loadImage("4.jpg", "jpg");
	//surface.setSize(image.width, image.height);
  
	noLoop();
}

void draw(){
	image.loadPixels();
  
  //grayscale
	for(int i = 0; i<image.pixels.length; i++){
    red=(image.pixels[i]&0xFF0000)>>16;
    green=(image.pixels[i]&0x00FF00)>>8;
    blue=image.pixels[i]&0x000FF;
    
    
    image.pixels[i] = floor((red+green+blue)/3) << 16 | floor((red+green+blue)/3) << 8 | floor((red+green+blue)/3);
	}

  println(image.pixels.length);

  //FFT
  float[][] pixelComplex = new float[image.pixels.length][2];
  for(int i = 0; i < image.pixels.length; i++){
    pixelComplex[i][0] = image.pixels[i]&0x0000FF;
    pixelComplex[i][1] = 0;
  }
  float[][] transformed = FactorFFT(pixelComplex);
  
  printArray(transformed);
  
  //float[] zero = {0, 0};
  //for(int i = 1; i < transformed.length; i++){
  //  transformed[i][0] = transformed[i][0] + (transformed.length-i)*-100;
  //}
  
  float[][] untransformed = IFactorFFT(transformed);
  
  for(int i = 0; i < image.pixels.length; i++){
    untransformed[i][0] = untransformed[i][0]/float(image.pixels.length);
    //image.pixels[i] = (floor(untransformed[i][0]) << 16 | floor(untransformed[i][0]) << 8 | floor(untransformed[i][0]));
    image.pixels[i] = color(floor(untransformed[i][0]), floor(untransformed[i][0]), floor(untransformed[i][0]));
  }
  
	image.updatePixels();
	image(image, 0, 0);
  println("Done!");
	//surface.setResizable(false);
}
