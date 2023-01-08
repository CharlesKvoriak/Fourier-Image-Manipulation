float[][] FactorFFT(float[][] input){
  if(input.length == 1){
    return input;
  }

  int[] primes = {673, 2, 3, 5};
  int n = 0;
  
  for(int i = 0; i < primes.length; i++){
    if(input.length % primes[i] == 0){
      n = primes[i];
      break;
    }
  }
  
  if(n == 0){
    return SFT(input);
  }
  
  float[][][] EquivClasses = new float[n][input.length/n][2];
  float[][][] TransformedEquivClasses = new float[n][input.length/n][2];
  for(int i = 0; i<EquivClasses.length; i++){
    for(int j = 0; j<input.length/n; j++){
      EquivClasses[i][j] = input[i + j*n];
    }
    TransformedEquivClasses[i] = FactorFFT(EquivClasses[i]);
  }  
  
  float[][] output = new float[input.length][2];
  for(int i = 0; i<EquivClasses[0].length; i++){
    for(int j = 0; j<EquivClasses.length; j++){
      float[] total = {0, 0};
      for(int k = 0; k<EquivClasses.length; k++){
        total = add(total, mult(TransformedEquivClasses[k][i], euler(TWO_PI/input.length*i*k+k*j*TWO_PI/n)));
      }
      output[i + j*EquivClasses[0].length] = total;
    }
  }
  
  return output;
}

float[][] IFactorFFT(float[][] input){
  if(input.length == 1){
    return input;
  }
  
  int[] primes = {2, 3, 5};
  int n = 0;
  
  for(int i = 0; i < primes.length; i++){
    if(input.length % primes[i] == 0){
      n = primes[i];
      break;
    }
  }
  
  if(n == 0){
    return ISFT(input);
  }
  
  float[][][] EquivClasses = new float[n][input.length/n][2];
  float[][][] TransformedEquivClasses = new float[n][input.length/n][2];
  for(int i = 0; i<EquivClasses.length; i++){
    for(int j = 0; j<input.length/n; j++){
      EquivClasses[i][j] = input[i + j*n];
    }
    TransformedEquivClasses[i] = IFactorFFT(EquivClasses[i]);
  }  
  
  float[][] output = new float[input.length][2];
  for(int i = 0; i<EquivClasses[0].length; i++){
    for(int j = 0; j<EquivClasses.length; j++){
      float[] total = {0, 0};
      for(int k = 0; k<EquivClasses.length; k++){
        total = add(total, mult(TransformedEquivClasses[k][i], euler(-(TWO_PI/input.length*i*k+k*j*TWO_PI/n))));
      }
      output[i + j*EquivClasses[0].length] = total;
    }
  }
  
  return output;
}

float[][] SFT(float[][] input){
  float[][] output = new float[input.length][2];
  for(int i = 0; i < input.length; i++){
    float[] total = {0, 0};
    for(int j = 0; j < input.length; j++){
      total = add(total, mult(input[j], euler(TWO_PI*i*j/input.length)));
    }
    output[i] = total;
  }
  
  return output;
}

float[][] ISFT(float[][] input){
  float[][] output = new float[input.length][2];
  for(int i = 0; i < input.length; i++){
    float[] total = {0, 0};
    for(int j = 0; j < input.length; j++){
      total = add(total, mult(input[j], euler(-TWO_PI*i*j/input.length)));
    }
    float[] scaledown = {1, 0};
    output[i] = mult(total, scaledown);
  }
  
  return output;
}

//Complex Number Arithmetic

float[] euler(float theta){
  float[] output = {cos(theta), sin(theta)};
  return output;
}

float[] mult(float[] a, float[] b){
  float[] output = {a[0]*b[0]-a[1]*b[1], a[0]*b[1]+a[1]*b[0]};
  return output;
}

float[] add(float[] a, float[] b){
  float[] output = {a[0]+b[0], a[1]+b[1]};
  return output;
}
