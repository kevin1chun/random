import processing.opengl.*;
import java.util.Iterator;

ArrayList<Star> starList;
int zDepth = 400;
class Star {
  float x;
  float y;
  float z;
  int size;
  color c;
  
  float xVelocity;
  float yVelocity;
  float zVelocity;
  

  
  float rotation;
  float rVelocity;
  int collisionDistance = 1;
  int interactionDistance = 1;
  float pull = .1;
  
  Star(int  size, color c)  {
    this.x = random(0,width );
    this.y = random(0, height);
    this.z = random(0, width);
    this.size = size;
    this.c = c;
    this.xVelocity = 0;
    this.yVelocity = 0;
    this.zVelocity = 0;
    this.rotation = 0;
    this.rVelocity = 0;
    this.collisionDistance = size;
    this.interactionDistance = 10 * size;
  }
  
  boolean tick(ArrayList<Star> list) {
  for (Star s : list){
    if (s != this && abs(s.x - this.x) <= collisionDistance 
        && abs(s.y - this.y) <= collisionDistance
        && abs(s.z - this.z) <= collisionDistance) {
          if ( random(100) > 1) {
            this.xVelocity = (s.xVelocity + this.xVelocity) / 2;
            this.yVelocity = (s.yVelocity + this.yVelocity) / 2;
            this.zVelocity = (s.zVelocity + this.zVelocity) / 2;
            
            s.xVelocity = this.xVelocity;
            s.yVelocity = this.yVelocity;
            s.zVelocity = this.zVelocity;
          } else if (false) {
            this.xVelocity = (s.xVelocity + this.xVelocity);
            this.yVelocity = (s.yVelocity + this.yVelocity);
            this.zVelocity = (s.zVelocity + this.zVelocity);
            s.xVelocity = 0;
            s.yVelocity = 0;
            s.zVelocity = 0;
          }
    }
    
    if (s != this) {
            this.xVelocity += Math.signum(s.x - this.x) * (this.pull * s.pull) * (1 / pow(max(abs(s.x - this.x), 1), 2));
            this.yVelocity +=  Math.signum(s.y - this.y) * (this.pull * s.pull) * (1 / pow(max(abs(s.y - this.y), 1), 2));
            this.zVelocity +=  Math.signum(s.z - this.z) * (this.pull * s.pull) * (1 / pow(max(abs(s.z - this.z), 1), 2));
            
            //s.xVelocity -= Math.signum(s.x - this.x) * this.pull * (1 / pow(max(abs(s.x - this.x), 1), 2));
            //s.yVelocity -=  Math.signum(s.y - this.y) * this.pull * (1 / pow(max(abs(s.y - this.y), 1), 2));
            //s.zVelocity -=  Math.signum(s.z - this.z) * this.pull * (1 / pow(max(abs(s.z - this.z), 1), 2));
    }
  }

    this.x += xVelocity;
    this.y += yVelocity;
    this.z += zVelocity;
    //this.rotation += rVelocity;
    return false;
  }
  
  void draw() {
    pushMatrix();
    translate(x, y, z);
    rotate(rotation);
    fill(c);
    noStroke(); 
    sphere(size);
    popMatrix();
  }
}

class Stationary extends Star {
  
  Stationary(int x, int y, int z, int  size, color c, float pull)  {
    super(size, c); 
    this.x = x;
    this.y = y;
    this.z = z;
    this.pull = pull;
  }
  
boolean tick(ArrayList<Star> list) {
    return false;
  }
}

void setup(){
  size(1000, 800, OPENGL);
  smooth();
  fill(255,0,0);
  starList = new ArrayList<Star>();
  starList.add(new Stationary(width/2, height/2, width/2, 20, color(255, 0, 0), 10000));
}

void draw(){
  background(255);
  lights();
  pushMatrix();
  rotateY(map(mouseX,0,width,-PI/2,PI/2));
  rotateX(map(mouseY,0,height,-PI/2,PI/2));

  //translate(width/3,height/3, 0);
  drawShapes();
  popMatrix();
  


}

void mousePressed() {
    int lim = 50;
    for (int i = 0; i < lim; i++) {
      starList.add(new Star(5, color((int) random(255), (int) random(255), (int) random(255))));
    }
}



void drawShapes(){
   stroke(255,0,0);
   line(0, height/2, width/2, width, height/2, width/2);//X
   stroke(0, 255,0);
   line(width/2, 0, width/2, width/2, height, width/2);//Y
   stroke(0,0,255);
   line(width/2, height/2, 0, width/2, height/2, width);//Z
    
  float velocityTotal =0; 
  int vCount = 0;
  Iterator<Star> iter = starList.iterator();
  while(iter.hasNext())
  {
      Star s  = iter.next();
      s.draw();
      if (s.tick(starList)) {
        iter.remove();
      }
      velocityTotal += sqrt(pow(s.xVelocity, 2) + pow(s.yVelocity, 2) + pow(s.zVelocity, 2));
      vCount += 1;
  }
  textSize(32);
  text("# Balls: " + vCount, 10, 30);
  text("Average V: " + velocityTotal / vCount, 10, 60);
}   
