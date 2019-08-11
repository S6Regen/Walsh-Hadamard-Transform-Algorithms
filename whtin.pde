// Walsh Hadamard transform (in place algorithm)
// Code: processing language (java!) www.processing.org
int k;
int len;
float[] data;
WHT wht;
void setup(){
  size(256,256);
  background(0);
  noLoop();
  k=8;
  len=1<<k;  // size is 2 to the power of 8=256
  data=new float[len];
  wht=new WHT(k);
  for(int i=0;i<len;i++){
     java.util.Arrays.fill(data,0f); // zero array
     data[i]=1f;
     wht.transform(data);
     for(int j=0;j<len;j++){
       if(data[j]>0f){
         set(j,i,0xff0000ff);
       }else{
         set(j,i,0xff00ff00);
       }
     }
  }
  wht.transform(data); // (self) inverse of final transform
  println(data[255]);  // should be 1
  println(java.util.Arrays.toString(data)); //everything else should be zero
}

class WHT{
 final int size;
 final float recip;
 final float[] buffer;
 
 public WHT(int k){
   size=1<<k;  // size is 2 to the power of k
   recip=1f/sqrt(size); // 1 over the square root of size
   buffer=new float[size];
 }  
 
 // In place Walsh Hadamard transform
 public void transform(float[] vec){
   int i, j, hs = 1;
    while (hs < size) {
      i = 0;
      while (i < size) {
        j = i + hs;
        while (i < j) {
          float a = vec[i];
          float b = vec[i + hs];
          vec[i] = a + b;
          vec[i + hs] = a - b;
          i += 1;
        }
        i += hs;
      }
      hs += hs;
    }
    for(int k=0;k<size;k++){
      vec[k]*=recip;
    }
 }
}  
