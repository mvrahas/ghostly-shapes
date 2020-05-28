class happyShape {
  PShape happyShape;
  int vertices[];
  float velocityX;
  float velocityY;
  int maxX, maxY, minX, minY;
  float positionX;
  float positionY;
  float shapeWidth;
  float shapeHeight;
  
  happyShape(int _vertices[]){
    
    //Pass vertice array into initializer
    vertices = _vertices;
    
    //Set x and y position width and height
    for(int i=0; i<vertices.length; i=i+2){
      if(vertices[i] > vertices[maxX]){maxX=i;}
      if(vertices[i+1] > vertices[maxY]){maxY=i+1;}
      if(vertices[i] < vertices[minX]){minX=i;}
      if(vertices[i+1] < vertices[minY]){minY=i+1;}
    }
    positionX = vertices[minX];
    positionY = vertices[minY];
    shapeWidth = vertices[maxX]-vertices[minX];
    shapeHeight = vertices[maxY]-vertices[minY];
    print(vertices[maxX]+" "+vertices[maxY]+" "+vertices[minX]+" "+vertices[minY]);
    print(shapeHeight+" "+shapeWidth);
    
    //Set velocity
    velocityX = random(-1,1);
    velocityY = random(-1,1);
    
    // Make the happy shape
    happyShape = createShape();
    happyShape.beginShape();
    happyShape.noStroke();
    happyShape.fill(random(255),random(255),random(255));
    for(int i=0; i<vertices.length; i=i+2){
      happyShape.vertex(vertices[i],vertices[i+1]);
    }
    happyShape.endShape(CLOSE);
  }
  
  void display(){
    happyShape.translate(velocityX,velocityY);
    shape(happyShape);
    
    //updatePosition
    positionX = positionX + velocityX;
    positionY = positionY + velocityY;
    
    if(positionX > width || positionX < 0){
      velocityX = velocityX*-1; 
    }
    if(positionY > height || positionY < 0){
      velocityY = velocityY*-1;
    }
  }
}