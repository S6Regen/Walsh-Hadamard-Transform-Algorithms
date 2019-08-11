// Walsh Hadamard transform (out of place algorithm)
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
 final int k;
 final int size;
 final int halfSize;
 final float recip;
 final float[] buffer;
 
 public WHT(int k){
   this.k=k;
   size=1<<k;  // size is 2 to the power of k
   halfSize=1<<(k-1);
   recip=1f/sqrt(2); // 1 over the square root of 2
   buffer=new float[size];
 }  
 
 // Out of place Walsh Hadamard transform
 // Useful to know but typically memory bandwidth
 // constrained. Can use with CPU registers.
 public void transform(float[] vec){
   for(int i=0;i<k;i++){ // k out of place steps
     hStep(vec);
   }  
 }

//Go through the input data pairwise.
//Put the sum in the lower half of a new array.
//Put the difference in the upper half of the new array.
 public void hStep(float[] vec){
   for(int i=0;i<halfSize;i++){
     float a=vec[i+i];    // access vec pairwise
     float b=vec[i+i+1];  // sequentially
     buffer[i]=a+b;       // in lower half of buffer
     buffer[i+halfSize]=a-b;  // in upper part of buffer
   }
   for(int i=0;i<size;i++){
     vec[i]=recip*buffer[i];  //scale and transfer back
   }                          //scaling can be combined
 }  
}  
