/*
  processing.org reference
  Capture \ Language (API) \ Processing 2+
  https://processing.org/reference/libraries/video/Capture.html
*/

//Camera variables
import processing.video.*;
Capture cam;

//Sensing area variables
boolean cameraOn = false;
int camWidth = 640;
int camHeight = 360;
int sensorWidth = 160;
int sensorHeight = 120;
int resolution = 4;

//Array of shapes to be created
happyShape happyShapes[] = new happyShape[0];

void setup() {
  size(1280, 720);
  background(255);
  
  //String of all available cameras
  String[] cameras = Capture.list();
  
  //Camera setup
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, camWidth, camHeight, cameras[0]);
    cam.start();
  }      
}

void draw() {
  
  //background important for making the camera disappear on and off
  background(255);
  
  //Prepare the camera image
  if (cam.available() == true) {
    cam.read();
  }
  
  //Hide the camera on and off as well as the sensor guide
  if(cameraOn){
    set(0, 0, cam);
    stroke(255,0,0);
    strokeWeight(1);
    noFill();
    rect(camWidth/2-sensorWidth/2,camHeight/2-sensorHeight/2,sensorWidth,sensorHeight);
    //the above finds the corners of the rectangle based on the size of the sensor and camera.
  }
  
  //Draw the sensor box on the screen
  //stroke(0);
  //strokeWeight(2);
  //rect(camWidth-sensorWidth,camHeight-sensorHeight,sensorWidth*2,sensorHeight*2);
  
  //Draw the shapes
  for(int i=0; i<happyShapes.length; i++){
    happyShapes[i].display();
  }
}

void readPixels(){
  
  //declare array for the vertices
  int vertices[] = new int[0];
  //load in the pixels array
  cam.loadPixels();
  //declare the shape to be created
  happyShape tempShape;
  
  //sampling along the top of the image from left to right.
  for(int x=(camWidth/2-sensorWidth/2); x<(camWidth/2+sensorWidth/2); x=x+resolution){
    boolean captured = false;
    for(int y=(camHeight/2-sensorHeight/2); y<(camHeight/2+sensorHeight/2); y++){
      if(captured == false){
        
        //average of pixels before
        float avBefore=0;
        for(int i=1; i<5; i++){
          avBefore = avBefore + brightness(cam.pixels[(y-i)*camWidth + x]);
        }
        avBefore = avBefore/4;
        
        //average of pixels after
        float avAfter=0;
        for(int i=0; i<4; i++){
          avAfter = avAfter + brightness(cam.pixels[(y+i)*camWidth + x]);
        }
        avAfter = avAfter/4;
        
        //test the condition and push coordinates to array if true
        if((avBefore-avAfter) > 10){
          //append x and y to the array to capture the vertices
          vertices = append(vertices,x);
          vertices = append(vertices,y);
          point(x,y);
          captured = true;
        }
      }
    }
  }
  
  //sampling along the bottom of the image from right to left.
  for(int x=(camWidth/2+sensorWidth/2); x>(camWidth/2-sensorWidth/2); x=x-resolution){
    boolean captured = false;
    for(int y=(camHeight/2+sensorHeight/2); y>(camHeight/2-sensorHeight/2); y--){
      if(captured == false){
        
        //average of pixels before
        float avBefore=0;
        for(int i=0; i<4; i++){
          avBefore = avBefore + brightness(cam.pixels[(y+i)*camWidth + x]);
        }
        avBefore = avBefore/4;
        
        //average of pixels after
        float avAfter=0;
        for(int i=1; i<5; i++){
          avAfter = avAfter + brightness(cam.pixels[(y-i)*camWidth + x]);
        }
        avAfter = avAfter/4;
        
        //test the condition and push coordinates to array if true
        if((avBefore-avAfter) > 10){
          //append x and y to the array to capture the vertices
          vertices = append(vertices,x);
          vertices = append(vertices,y);
          captured = true;
        }
      }
    }
  }
  
  //adjust vertices to be the size of the whole screen
  for(int i=0; i<vertices.length; i++){
    vertices[i] = vertices[i]*2;
  }
  println(vertices);
  
  tempShape = new happyShape(vertices);
  happyShapes = (happyShape[]) append(happyShapes,tempShape);
}


void colorPixels(){
  for(int x=(camWidth/2-sensorWidth/2); x<(camWidth/2+sensorWidth/2); x++){ 
    for(int y=(camHeight/2-sensorHeight/2); y<(camHeight/2+sensorHeight/2); y++){
      int pixel = (y-1)*camWidth + x;
      cam.pixels[pixel] = color(255,0,0);
    }
  }
  cam.updatePixels();
}

void keyPressed() {

  switch (key) {
  case 'c':
    if(cameraOn == true){
      cameraOn = false;
    }else{
      cameraOn = true;
    }
   break;
   case 'd':
     readPixels();
   break;
  }
}