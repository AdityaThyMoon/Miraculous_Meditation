//Miraculous Meditation
//Creator: Aditya Moon
//For: Mr. Schattman
//Last Modified: 12/16/20

//Feel free to change these ;)
boolean displayOxygen = false; //Displays oxygen that comes into the brain during inhalation.
color background = color(66, 135, 245);
color betaCol = color(0, 0, 255);
color neutralCol = color(231, 235, 224);
color thetaCol = color(125, 180, 108);
int breathSpeed = 4; //The higher this value is the more breaths per minute. Recommended between 2 and 6.
int meditationTime = 5; //How long do you want to meditate for?
int resilience = 50; //Precision is key here. I recommend keeping it somewhere between 43-57 for interesting results!
                     //SPOILER ALERT AHEAD! SPOILER ALERT AHEAD! SPOILER ALERT AHEAD! SPOILER ALERT AHEAD! SPOILER ALERT AHEAD!
                     
                     //Beginner meditators often find it hard to meditate, as so many thoughts appear in their mind during meditation.
                     //This is represented by the greater number of Beta cells produced compared to Theta cells, during resilience levels lower than 50.

//Global variables
boolean breathState = true; //Used for the inhalation and exhalation cycle. True = inhalation and false = exhalation.
int betaCounter; //Counts the number of Beta cells everytime the screen refreshes.
int frameSpeed = 1; //Ideally very low.
int gridSize = 600;
int cells[][] = new int[gridSize][gridSize];
int cellSize = 600/gridSize;
int initialBetaCount; 
int initialThetaCount; 
int thetaCounter; //Counts the number of Theta cells everytime the screen refreshes.
int xPadding = 50;
int yPadding = 100;
PFont f;
PImage img;
String betaChange; //Change in Beta cells from the start to the end of the animation.
String breathText; //Conditional renders appropriate text based on the current stage of the breathing cycle.
String thetaChange; //Change in Theta cells from the start to the end of the animation.

void setup() {
  frameRate(frameSpeed);
  f = createFont("Arial", 24);
  textAlign(CENTER);
  textFont(f);
  noStroke(); //Since the brain is both soft and squishy, I turned this on to give you a more realistic-looking animation :)
  size(1000, 1000);
  setInitialValues();
}

void setInitialValues() { //Assigns randomly generated values to all cells, which are then used to determine their cell type and colour.
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      cells[i][j] = int(random(0, 3));
      drawSquare(cells[i][j], i, j);
      if (cells[i][j] == 0) {
        initialBetaCount += 1;
      } else if (cells[i][j] == 2) {
        initialThetaCount += 1;
      }
    }
  }
}

void draw() {
  background(background);
  breathState = !breathState;
  statistics();
  drawButtons();
  setNextGeneration();
  betaCounter = 0;
  thetaCounter = 0;
  newCounter();
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      drawSquare(cells[i][j], i, j);
    }
  }
  delay(1000);
  if (breathState == true && displayOxygen) { //Displays oxygen when the brain is receiving it, if the displayOxygen variable is set to true.
    displayOxygen();
  }
}

void drawSquare(int square, int x, int y) { 
  if (square == 0) {
    fill(betaCol);
  } else if (square == 1) {
    fill(neutralCol);
  } else if (square == 2) {
    fill(thetaCol);
  }
  square(x*cellSize+xPadding, y*cellSize+yPadding, cellSize);
}

void statistics() {
  if (breathState) {
    breathText = "Breathing in...";
  } else {
    breathText = "Breathing out...";
  }
  fill(255);
  text("CT Brain Scan During Meditation (Coloured)", width/2, 60); 
  if (frameCount/breathSpeed == 1) {
    text("Time elapsed: " + str(frameCount/breathSpeed) + " minute", height/1.2, 200);
  } else if (frameCount/breathSpeed == meditationTime) { // Fun stats at the end!
    text("The mind is ready to learn!", height/1.2, 200);
    if (betaCounter > initialBetaCount) {
      betaChange = "increased";
    } else if (betaCounter == initialBetaCount) {
      betaChange = "stayed the same. The original value stood ";
    } else if (betaCounter < initialBetaCount) {
      betaChange = "reduced";
    }

    if (thetaCounter > initialThetaCount) {
      thetaChange = "increased ";
    } else if (thetaCounter == initialThetaCount) {
      thetaChange = "stayed the same. Or in other words, the original value";
    } else if (thetaCounter < initialThetaCount) {
      thetaChange = "reduced ";
    }

    text("Total number of Beta cells " + betaChange + " by " + abs(betaCounter-initialBetaCount) + "!", 500, 770);
    text("Total number of Theta cells " + thetaChange + "by " + abs(thetaCounter-initialThetaCount) + "!", 500, 820);
    breathText = "";
    noLoop();
  } else {
    text("Time elapsed: " + str(frameCount/breathSpeed) + " minutes", height/1.2, 200);
  }
  text(breathText, height/1.2, 150);
  text("Beta Cell Counter: " + betaCounter, height/1.2, 300);
  text("Theta Cell Counter: " + thetaCounter, height/1.2, 350);
}

void drawButtons() {
  rectMode(CENTER);
  fill(255);
  text("Turn The Tides!", width/1.2, 500); // Quite literally *smirks*
  text("The Brain's Resilience: " + resilience, width/1.2, 650);
  fill(219, 209, 180);
  square(792.33, 575, 50); //Button for adding resilience.
  square(874.33, 575, 50); //Button for reducing resilience.
  rectMode(CORNER);
  fill(0);
  text("+", 792.33, 581.25); 
  text("-", 874.33, 578);
}

void mouseClicked() {
  if ((mouseX >= 767.33 && mouseX <= 817.33) && (mouseY >= 550 && mouseY <= 600) && (resilience < 91)) {
    resilience += 10;
  } else if ((mouseX >= 859.33 && mouseX <= 909.33) && (mouseY >= 550 && mouseY <= 600) && (resilience > 9)) {
    resilience -= 10;
  }
}

void setNextGeneration() {
  if (breathState == false) { //Only sets the next generation during exhalation.
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (cells[i][j] == 2) { //Detects Theta cells.
          for (int a = -1; a <= 1; a++) {
            for (int b = -1; b <= 1; b++) {
              if (cells[i][j] != 2) { //Prevents a Theta-turned Beta cell from continuing its normal behaviour as a Theta cell; prevents faulty looping.
                a = b = 2;
                break;
              }
              try {
                if (cells[a+i][b+j] == 1) {
                  cells[a+i][b+j] = 2;
                } else if (cells[a+i][b+j] == 0) {
                  int value = int(random(101));
                  if (value > resilience) {
                    cells[i][j] = 0;
                  } else if (value < resilience) {
                    cells[a+i][b+j] = 2;
                  }
                }
              }
              catch(Exception e) {
                //println("Looks like we've received Exception ", e, "!");
              }
            }
          }
        }
      }
    }
  }
}

void newCounter() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (cells[i][j] == 0) {
        betaCounter += 1;
      } else if (cells[i][j] == 2) {
        thetaCounter += 1;
      }
    }
  }
}

void displayOxygen() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < i; j++) { //The line in the middle of both triangles is for design.
      fill(216); 
      square(i*cellSize+xPadding, j*cellSize+yPadding, cellSize*0.98); //The minor misalignment is used to create the cool-looking outline on the oxygen cells.
      square(j*cellSize+xPadding, i*cellSize+yPadding, cellSize*0.98); //Same goes for here :)
    }
  }
}
