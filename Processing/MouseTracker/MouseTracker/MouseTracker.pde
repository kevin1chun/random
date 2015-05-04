import java.awt.*;
import java.awt.image.*;

import java.awt.event.*;
import javax.swing.*;
import java.io.*;  
import javax.print.*;  
import java.awt.geom.AffineTransform;
  
  
HScrollbar hs1, hs2;  // Two scrollbars


HTextInput nameInput;
HTextInput commentsInput;
HTextInput sampleRateInput;
HTextInput[] textBoxes;

JTextField sampleInput;
Robot auto;

int screenStage = 0;
String version = "Version 1.00";
int versionFontSize = 20;
String year = "2014";
int yearFontSize = 14;
color textColor = color(0, 0, 0);  

color xColor = color(0, 0, 255);
color yColor = color(255, 100, 0);
color vColor = color(0, 255, 0);

//Polling vars
boolean activePolling = false;
int maxSamples = 10000000;
int[] x = new int[maxSamples];
int[] y = new int[maxSamples];
float[] velocity = new float[maxSamples];
int lastTime;
int stride = 1000000;

Integer sampleRate = 8;
int axisLength = 600;
int sampleLocation = 1;
int displayLocation = 1;


//Drawing Vars

int graphX = 300;
int graphMarginY = 10;
int graphYPosition = 75;

float xAmplitude = 1;
float xTimeScale = 1;
int xAxisHeight = 125;

float yAmplitude = 1;
float yTimeScale = 1;
int yAxisHeight = 125;

float vAmplitude = 1;
int vTimeScale = 1;
int vAxisHeight = 75;

float maxV = 0.0;
float maxX = 0.0;
float maxY = 0.0;

float minTimeScale = 2000; //ms
float maxTimeScale = 60000; //ms

//Buttons

Rectangle start;
String start_stop = "start";

Rectangle reset;

Rectangle save;
Rectangle open;
Rectangle printButton;
Rectangle settings;

Rectangle enableVelocityGraph;
boolean showV = true;

public BufferedImage rotate90DX(BufferedImage bi) {
    int width = bi.getWidth();
    int height = bi.getHeight();
    BufferedImage biFlip = new BufferedImage(height, width, bi.getType());
    for(int i=0; i<width; i++)
        for(int j=0; j<height; j++)
            biFlip.setRGB(j, width - (i + 1), bi.getRGB(i, j));
    return biFlip;
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void loadData() {
  SwingUtilities.invokeLater(new Runnable() {
      public void run() {
    try {
  
      JFileChooser fc = new JFileChooser();
      int returnVal = fc.showOpenDialog(null);
     if(returnVal == JFileChooser.APPROVE_OPTION) {
        BufferedReader reader = createReader(fc.getSelectedFile().getPath());
        
      try {  
          zeroData();
          nameInput.myText = reader.readLine().replace("\\n", "\n");
          commentsInput.myText = reader.readLine().replace("\\n", "\n");
          String line;
          int i = 0;
          while ((line = reader.readLine()) != null ) {
            String[] list = split(line, ',');

            x[i] = Integer.parseInt(list[0]);
            y[i] = Integer.parseInt(list[1]);
            velocity[i] = Float.parseFloat(list[2]);
            i++;
            sampleLocation++;
            displayLocation++;
          }
          
        } catch (IOException e) {
          e.printStackTrace();
        }
        
     }
    }
    catch (Exception e) {
      e.printStackTrace();
    }
      }
    });
}

void saveData() {
  SwingUtilities.invokeLater(new Runnable() {
      public void run() {
    try {
  
      JFileChooser fc = new JFileChooser();
      int returnVal = fc.showOpenDialog(null);
     if(returnVal == JFileChooser.APPROVE_OPTION) {
        PrintWriter output = createWriter(fc.getSelectedFile().getPath());
        output.println(nameInput.myText.replace("\n", "\\n"));
        output.println(commentsInput.myText.replace("\n", "\\n"));

       
        for (int i = 1; x[i] != -1; i++) {
          output.println(x[i] + "," + y[i] + "," + velocity[i]);
      
        }
        output.flush(); 
        output.close();
     }
    }
    catch (Exception e) {
      e.printStackTrace();
    }
      }
    });
}

void zeroData() {
  sampleLocation = 0;
  displayLocation = 0;
   for (int i = 0; i < maxSamples; i++) {
    int currentTime = millis();
    x[i] = -1;
    y[i] = -1;
    velocity[i] = -1;
  } 

}
void saveSettings() {
  PrintWriter output = createWriter("data/settings");
  output.println(sampleRate);
  output.println(xColor);
  output.println(yColor);
  output.println(vColor);     
  output.flush(); 
  output.close();
}

void loadSettings() {
      BufferedReader reader = createReader("settings");
      if (reader != null) {
        try {  
            sampleRate = Integer.parseInt(reader.readLine());
            Color tempXColor = new Color(Integer.parseInt(reader.readLine()));
            Color tempYColor = new Color(Integer.parseInt(reader.readLine()));
            Color tempVColor = new Color(Integer.parseInt(reader.readLine()));
            xColor = color(tempXColor.getRed(), tempXColor.getGreen(), tempXColor.getBlue());
            yColor = color(tempYColor.getRed(), tempYColor.getGreen(), tempYColor.getBlue());
            vColor = color(tempVColor.getRed(), tempVColor.getGreen(), tempVColor.getBlue());
          } catch (IOException e) {
            e.printStackTrace();
          }
    }
}

void updateSettings() {
  final JFrame myFrame = new JFrame("Update Settings");
  myFrame.setSize(150, 300);
  myFrame.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
  
  JButton xColorButton = new JButton("Set X Color");
  xColorButton.addActionListener(new ActionListener() {
   
    public void actionPerformed(ActionEvent e)
    {
      SwingUtilities.invokeLater(new Runnable() {
          public void run() {
        try {
          Color temp = JColorChooser.showDialog(myFrame, "Select a Color", new Color(xColor));
          xColor = color(temp.getRed(), temp.getGreen(), temp.getBlue());
          saveSettings();
        }
        catch (Exception e) {
          e.printStackTrace();
        }
          }
        });    }
  }); 
  myFrame.getContentPane().add(xColorButton);
  
  JButton yColorButton = new JButton("Set Y Color");
  yColorButton.addActionListener(new ActionListener() {
   
    public void actionPerformed(ActionEvent e)
    {
      SwingUtilities.invokeLater(new Runnable() {
          public void run() {
        try {
          Color temp = JColorChooser.showDialog(myFrame, "Select a Color", new Color(yColor));
          yColor = color(temp.getRed(), temp.getGreen(), temp.getBlue());
          saveSettings();
        }
        catch (Exception e) {
          e.printStackTrace();
        }
          }
        });

    }
  }); 
  myFrame.getContentPane().add(yColorButton);
  
  JButton vColorButton = new JButton("Set V Color");
  vColorButton.addActionListener(new ActionListener() {
   
    public void actionPerformed(ActionEvent e)
    {
      SwingUtilities.invokeLater(new Runnable() {
          public void run() {
        try {
          Color temp = JColorChooser.showDialog(myFrame, "Select a Color", new Color(vColor));
          vColor = color(temp.getRed(), temp.getGreen(), temp.getBlue());
          saveSettings();
        }
        catch (Exception e) {
          e.printStackTrace();
        }
          }
        });    }
  }); 
  myFrame.getContentPane().add(vColorButton);

  for (HTextInput item : textBoxes) {
    item.deselect();
  }
  
  
  sampleRateInput.select();
  sampleInput = new JTextField(sampleRate.toString(), 5);
  sampleInput.setEditable(true);
  myFrame.add(new JLabel("Sample Rate (ms):"));
  myFrame.add(sampleInput);
  
  JButton saveButton = new JButton("Save");
  saveButton.addActionListener(new ActionListener() {
   
    public void actionPerformed(ActionEvent e)
    {
          selectedTextBox().myText = sampleInput.getText();
          sampleInput.setText(selectedTextBox().myText);
          sampleRate = parseInt(selectedTextBox().myText);
          saveSettings();
    }
  }); 

  myFrame.getContentPane().add(saveButton);
  myFrame.setLayout(new FlowLayout());
  myFrame.setResizable(false);
  myFrame.setLocationRelativeTo(null);
  myFrame.setVisible(true);
  
}


void keyReleased() {
  if (key != CODED) {
    if (selectedTextBox() == null)
      return;
    switch(key) {
    case BACKSPACE:
      selectedTextBox().myText = selectedTextBox().myText.substring(0,max(0,selectedTextBox().myText.length()-1));
      break;
    case TAB:
      selectedTextBox().myText += "    ";
      break;
    case ENTER:
    case RETURN:
      // comment out the following two lines to disable line-breaks
      selectedTextBox().myText += "\n";
      break;
    case ESC:
    case DELETE:
      break;
    default:
      selectedTextBox().myText += key;
    }
  }


  if (selectedTextBox() == sampleRateInput) {
    sampleInput.setText(selectedTextBox().myText);
    sampleRate = parseInt(selectedTextBox().myText);
    saveSettings();
  }
}

void setup()  {
  try {
    auto = new Robot();
  } catch (Exception E) {
    auto = null; 
  }
  loadSettings();
  size(500, 400);
  frame.setResizable(true); 
  lastTime = millis();
  zeroData();
  int axisLength = 600;
  graphX = 100;
  
  
  int temp = 75;
  reset = new Rectangle(temp, 10, 100, 50);
  temp += 100;
  start = new Rectangle(temp, 10, 100, 50);
  temp += 100;
  save = new Rectangle(temp, 10, 100, 50);
  temp += 100;
  open = new Rectangle(temp, 10, 100, 50);
  temp += 100;
  printButton = new Rectangle(temp, 10, 100, 50);
  temp += 100;
  settings = new Rectangle(temp, 10, 120, 50);
  temp += 120;
  
  
  enableVelocityGraph = new Rectangle(705, 400, 10, 10);
  hs1 = new HScrollbar(300, 525, 200, 16, 5);
  hs2 = new HScrollbar(300, 475, 200, 16, 5);
  hs2.newspos = hs2.sposMax;
  
  nameInput = new HTextInput ("Name", 550, 500, 200, 20);
  commentsInput = new HTextInput ("Comments", 20, 450, 250, 100);
  sampleRateInput = new HTextInput (sampleRate.toString(), -500, -500, 100, 20);
  textBoxes = new HTextInput[3];
  textBoxes[0] = nameInput;
  textBoxes[1] = commentsInput;
  textBoxes[2] = sampleRateInput;
}

boolean sketchFullScreen() {
  return screenStage == 1;
}

void draw() {
  if (screenStage == 1) {
    
    
    //text(axisLength * sampleRate * xTimeScale + "ms",   hs1.xpos + 10, hs1.sheight + hs1.ypos + 20);

    xTimeScale = map(hs1.getNormalized(), 0, 1, minTimeScale / (axisLength * sampleRate) , (maxTimeScale / (axisLength * sampleRate)));

    yTimeScale = xTimeScale;
    boolean tracking = sampleLocation == displayLocation;
    int origLoc = sampleLocation;

    if (activePolling) {
      int temp = lastTime;
      int temp2 = sampleLocation;
      //Start Polling
      for (int i = 0; i < stride; i++) {
        int currentTime = millis();
        int elapsed = (currentTime - lastTime);
        x[sampleLocation] = mouseX;
        y[sampleLocation] = mouseY; 
       
  
        sampleLocation += elapsed >= sampleRate ? 1 : 0;
        lastTime = elapsed >= sampleRate ? currentTime : lastTime;
      }
      //End Poll 

      float msReading = ((millis() - temp) / (float) (sampleLocation - temp2));

      
      println((sampleLocation - temp2) + " readings in " + (millis() - temp) + " ms => " + msReading + " ms/reading") ;
    }
      
    displayLocation = (int) (hs2.getNormalized() * sampleLocation);

    //Draw Graph 
    background(255);
    //Graph Labels
    translate(5, graphMarginY + graphYPosition + 15);
    fill(xColor);
    textSize(16);
    text("Horizontal\nMovement", 0.0, 0.0);
      
    translate(0, xAxisHeight + graphMarginY);
    fill(yColor);
    text("Vertical\nMovement", 0.0, 0.0);


    translate(0, yAxisHeight + graphMarginY);
    fill(vColor);
    text("Velocity", 0.0, 0.0);

    translate(-5, -(xAxisHeight + graphMarginY*3 + yAxisHeight + graphYPosition + 15));


    int Xoffset = (int) max(0, displayLocation - (axisLength * xTimeScale));
    int Yoffset = (int) max(0, displayLocation - (axisLength * yTimeScale));

    int t1 = millis();
    for (int i = 2; i < axisLength; i++) {
      if (x[(int)  ((i) * xTimeScale) + Xoffset ] == - 1) {
        continue; 
    }


      translate(graphX, graphMarginY + graphYPosition);
      stroke(xColor);
      line(i-1, (int) constrain(map(x[(int) ((i -1) * xTimeScale) + Xoffset ] * xAmplitude, 0.0, displayWidth, 0.0, (float) xAxisHeight), 0, xAxisHeight), i, 
      (int) constrain(map(x[(int) (i * xTimeScale) + Xoffset ] * xAmplitude, 0.0,  displayWidth, 0.0, (float) xAxisHeight), 0, xAxisHeight));
        
      translate(0, xAxisHeight + graphMarginY);
      stroke(yColor);
      line(i-1, (int) constrain(map(y[(int) ((i -1) * yTimeScale) + Yoffset ] * yAmplitude, 0.0, displayHeight, 0.0, (float) yAxisHeight), 0, yAxisHeight), i, 
      (int) constrain(map(y[(int) (i * yTimeScale) + Yoffset ] * yAmplitude, 0.0, displayHeight, 0.0, (float) yAxisHeight), 0, yAxisHeight));

      translate(0, yAxisHeight + graphMarginY);
      stroke(vColor);
      
      if (showV) {
        float v1 = sqrt(pow(x[(int) ((i -2) * xTimeScale) + Xoffset ] - x[(int) ((i - 1) * xTimeScale) + Xoffset ], 2) + pow(y[(int) ((i -2) * yTimeScale) + Yoffset ] - y[(int) ((i - 1) * yTimeScale) + Yoffset ], 2)) / ((float) sampleRate);
        float v2 = sqrt(pow(x[(int) ((i -1) * xTimeScale) + Xoffset ] - x[(int) (i * xTimeScale) + Xoffset ], 2) + pow(y[(int) ((i -1) * yTimeScale) + Yoffset ] - y[(int) (i * yTimeScale) + Yoffset ], 2)) / ((float) sampleRate);
        if (v2 > maxV)
          maxV = v2;
        line(i - 1, map(v1, 0.0, maxV, vAxisHeight, 0.0), i, map(v2, 0.0, maxV, vAxisHeight, 0.0) );
      }
  
      translate(-graphX, -(xAxisHeight + graphMarginY*3 + yAxisHeight + graphYPosition));
    }    
    //Draw Buttons
    fill(color(#FFFFFF));
    stroke(color(0));
    rect(start.x, start.y, start.width, start.height);
    rect(save.x, save.y, save.width, save.height);
    rect(open.x, open.y, open.width, open.height);
    rect(reset.x, reset.y, reset.width, reset.height);

    rect(printButton.x, printButton.y, printButton.width, printButton.height);
    rect(settings.x, settings.y, settings.width, settings.height);
    
    if (showV)
      fill(color(0));
    rect(enableVelocityGraph.x, enableVelocityGraph.y, enableVelocityGraph.width, enableVelocityGraph.height);
    fill(textColor);
    textSize(20);
    textAlign(LEFT, LEFT);
    text(start_stop, start.x + 25, start.y + (start.height / 2) + 5);
    text("Save", save.x + 25, save.y + (save.height / 2) + 5);
    text("Open", open.x + 25, open.y + (open.height / 2) + 5);
    text("Print", printButton.x + 25, printButton.y + (printButton.height / 2) + 5);
    text("Reset", reset.x + 25, reset.y + (reset.height / 2) + 5);

    
    text("Settings", settings.x + 25, settings.y + (settings.height / 2) + 5);

    hs1.update();
    hs1.display();
    hs2.update();
    hs2.display();

    //Draw Timescale
    fill(textColor);
    textSize(14);
    textAlign(LEFT, LEFT);
    text(axisLength * sampleRate * xTimeScale + " ms",   hs1.xpos + 30, hs1.sheight + hs1.ypos + 20);
    text("scroll",   hs2.xpos + 90, hs2.sheight + hs2.ypos + 20);

    for (HTextInput item : textBoxes) {
      item.display();
    }
    //println("burn " + (millis() - t1) + " ms drawing");
    //End Draw Graph 
  } else {
    PImage img = loadImage("LOGO.JPG");
    int offsetX = (width - img.width) / 2;
    int offsetY =  (width - img.width) / 2;
    image(img, offsetX, offsetY);
    fill(textColor);
    textSize(versionFontSize);
    textAlign(CENTER);
    text(version, (width / 2), offsetY + img.height + versionFontSize * 2); 
    textSize(yearFontSize);
    text(year, (width / 2), offsetY + img.height + versionFontSize * 2 + yearFontSize );
  }
}

void mousePressed() {
  if (screenStage == 0) {
    screenStage = 1;
    frame.setSize(800, 600);

    return;
  }
  
  //If mouseOver start button when clicked.
  if (mouseX > start.x && mouseX < (start.width + start.x) &&  mouseY > start.y && mouseY < (start.height + start.y)) {
    if (start_stop == "start") {
      start_stop = "stop";
      activePolling = true;
      auto.mouseMove(frame.getX() + (width/2), frame.getY() +  (height/2));
    } else {
      start_stop = "start";
      activePolling = false;
    }

  }
  
  //If mouseOver save button when clicked.
  if (mouseX > save.x && mouseX < (save.width + save.x) &&  mouseY > save.y && mouseY < (save.height + save.y)) {
      saveData();
  }
  
  //If mouseOver save button when clicked.
  if (mouseX > open.x && mouseX < (open.width + open.x) &&  mouseY > open.y && mouseY < (open.height + open.y)) {
      loadData();
  }
  
  //If mouseOver settings button when clicked.
  if (mouseX > settings.x && mouseX < (settings.width + settings.x) &&  mouseY > settings.y && mouseY < (settings.height + settings.y)) {
      updateSettings();
  }
  
  //If mouseOver enableVelocityGraph button when clicked.
  if (mouseX > enableVelocityGraph.x && mouseX < (enableVelocityGraph.width + enableVelocityGraph.x) &&  mouseY > enableVelocityGraph.y && mouseY < (enableVelocityGraph.height + enableVelocityGraph.y)) {
    showV = !showV;
  }
  
  //If mouseOver reset button when clicked.
  if (mouseX > reset.x && mouseX < (reset.width + reset.x) &&  mouseY > reset.y && mouseY < (reset.height + reset.y)) {
    zeroData();
    hs1.reset();
    hs2.reset();
  }
  
  
  //If mouseOver printButton button when clicked.
  if (mouseX > printButton.x && mouseX < (printButton.width + printButton.x) &&  mouseY > printButton.y && mouseY < (printButton.height + printButton.y)) {
    PrintJob job = Toolkit.getDefaultToolkit().getPrintJob( new JFrame("Printing"),"Mouse Tracker",null);
    //check if user didn't cancel
    if(job != null) {

      Graphics page = job.getGraphics();
      Dimension pagesize = job.getPageDimension();
      page.setClip(0,0,pagesize.width,pagesize.height);
      BufferedImage screen = (BufferedImage) this.g.getNative();
      screen = screen.getSubimage(0, graphMarginY + graphYPosition, screen.getWidth(), screen.getHeight() - (graphMarginY + graphYPosition));
      screen = rotate90DX(screen);
      page.drawImage(screen, 0, 0, pagesize.width, pagesize.height, 0, 0, screen.getWidth(), screen.getHeight(), null);                


     job.end();
    }
  }
  
    HTextInput temp = selectedTextBox();
    for (HTextInput item : textBoxes) {
      if (item.mouseOver() ){
        temp = item;
      }
      item.deselect();
    }
    if (temp != null) {
      temp.select();
      if (temp.myText == "Name") {
        temp.myText = "";
      } else if (temp.myText == "Comments") {
        temp.myText = "";
      }
    }
}

HTextInput selectedTextBox() {
 for(HTextInput item : textBoxes ){
   if (item.selected)
     return item;
 }
 return null;
}

class HTextInput {
  int xpos, ypos;
  int swidth, sheight;
  String myText;
  boolean selected;
  JTextField outerField = null;
  
 HTextInput (JTextField txt) {
   myText =  txt.getText();
   selected = false;
 }
  
 HTextInput (String txt, int xp, int yp, int sw, int sh) {
   myText =  txt;
   xpos = xp;
   ypos = yp;
   swidth = sw;
   sheight = sh;
   selected = false;
 }
 boolean mouseOver() {
  return mouseX > xpos && mouseX < (swidth + xpos) &&  mouseY > ypos && mouseY < (sheight + ypos);
 }
  void select() {
    selected = true; 
  }
  
  void deselect() {
    selected = false; 
  }
  void display() {
    if (selected)
      stroke(color(255, 0, 0));
    else
      stroke(color(0));
      
    fill(color(#FFFFFF));
    rect(xpos, ypos, swidth, sheight);
    
    textSize(16);
    fill(color(0));
    int k = 0;
    int stride = swidth;
    text(myText, xpos + 5 , ypos + 16 );
    
    
  }  
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }
  void reset() {
    newspos = xpos + swidth/2 - sheight/2;

  }
  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  
  float getNormalized() {
     return map(spos * ratio, sposMin * ratio, sposMax * ratio, 0, 1);
  }
}

///////////////////////////////////////////////////////


class VScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  VScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int heighttowidth = sh - sw;
    ratio = (float)sh / (float)heighttowidth;
    xpos = xp-swidth/2;
    ypos = yp;
    spos = ypos;
    newspos = spos;
    sposMin = ypos;
    sposMax = ypos + sheight - swidth;
    loose = l;

  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseY-swidth/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(xpos, spos, swidth, swidth);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  
  float getNormalized() {
     return map(spos * ratio, sposMin * ratio, sposMax * ratio, 1, 10);
  }
}

