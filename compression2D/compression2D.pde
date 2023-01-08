PImage image;
int red, green, blue;


void setup(){
	size(1000, 1000);
	//surface.setResizable(true);

	image = loadImage("2.jpg", "jpg");
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

  //2FFT
  float[][][] pixelComplex = new float[image.width][image.height][2];
  for(int i = 0; i < image.width; i++){
    for(int j = 0; j < image.height; j++){ 
      pixelComplex[i][j][0] = image.pixels[j*image.width + i]&0x0000FF;
      pixelComplex[i][j][1] = 0;
    }
  }
  
  float[][][] transformed = new float[image.width][image.height][2];
  
  //Transform in the Y direction
  for(int i = 0; i < image.width; i++){
    transformed[i] = FactorFFT(pixelComplex[i]);
  }
  
  //Transform in the X direction :sob:
  for(int i = 0; i < image.height; i++){
    float[][] row = new float[image.width][2];
    for(int j = 0; j < image.width; j++){
      row[j] = pixelComplex[j][i];
    }
    row = FactorFFT(row);
    for(int j = 0; j < image.width; j++){
      transformed[j][i] = row[j];
    }
  }
  
  printArray(transformed);
  
  //Inverse 2FFT
  float[][][] untransformed = new float[image.width][image.height][2];
  
  for(int i = 0; i < image.width; i++){
    untransformed[i] = IFactorFFT(pixelComplex[i]);
  }
  
  for(int i = 0; i < image.height; i++){
    float[][] row = new float[image.width][2];
    for(int j = 0; j < image.width; j++){
      row[j] = transformed[j][i];
    }
    row = IFactorFFT(row);
    for(int j = 0; j < image.width; j++){
      untransformed[j][i] = row[j];
    }
  }
  
  for(int i = 0; i < image.height; i++){
    for(int j = 0; j < image.width; j++){
      untransformed[j][i][0] = untransformed[j][i][0]/float(image.height);
    }
  }
  
  for(int i = 0; i < image.height; i++){
    for(int j = 0; j < image.width; j++){
      image.pixels[j + i*image.width] = color(floor(untransformed[j][i][0]), floor(untransformed[j][i][0]), floor(untransformed[j][i][0]));
    }
  }
  
	image.updatePixels();
	image(image, 0, 0);
  println("Done!");
	//surface.setResizable(false);
}
