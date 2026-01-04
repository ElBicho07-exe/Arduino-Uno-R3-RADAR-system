import processing.serial.*;
import java.util.ArrayList;

Serial myPort;
String data = "";

int sensorAngle = 0;
int visualAngle = 0;

int distance = 0;
int lastDistance = 0;

boolean isRunning = true;
float pulsePhase = 0;

// ==========================
// RADAR PULSE CLASS
// ==========================
class RadarPulse {
  float r;
  float alpha;

  RadarPulse() {
    r = 0;
    alpha = 180;
  }

  void update() {
    r += 4;
    alpha -= 2;
  }

  boolean dead() {
    return alpha <= 0 || r > 420;
  }

  void draw() {
    stroke(0, 255, 0, alpha);
    noFill();
    strokeWeight(2);
    arc(0, 0, r*2, r*2, PI, TWO_PI);
  }
}

ArrayList<RadarPulse> pulses = new ArrayList<RadarPulse>();

// ==========================
// SETUP
// ==========================
void setup() {
  size(900, 650);
  smooth(8);

  myPort = new Serial(this, "COM4", 9600);
  myPort.bufferUntil('.');
}

// ==========================
// MAIN DRAW LOOP
// ==========================
void draw() {
  background(0, 40);

  translate(width/2, height - 50);

  drawRadarGrid();
  drawPulses();
  drawSweep();
  drawTarget();
  drawHUD();
  drawButton();

  if (isRunning) {
    visualAngle = sensorAngle;   // 🔑 sync ONLY when running
    pulsePhase += 0.08;

    if (frameCount % 15 == 0) {
      pulses.add(new RadarPulse());
    }
  }
}

// ==========================
// SERIAL EVENT
// ==========================
void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = trim(data);
    data = data.substring(0, data.length() - 1);

    String[] values = split(data, ',');
    if (values.length == 2) {
      sensorAngle = int(values[0]);
      distance = int(values[1]);

      if (isRunning) {
        lastDistance = distance;
      }
    }
  }
}

// ==========================
// RADAR GRID
// ==========================
void drawRadarGrid() {
  stroke(0, 255, 80, 120);
  noFill();
  strokeWeight(1);

  for (int r = 100; r <= 400; r += 100) {
    arc(0, 0, r*2, r*2, PI, TWO_PI);
  }

  for (int a = 0; a <= 180; a += 30) {
    float rad = radians(a);
    line(0, 0, 400*cos(rad), -400*sin(rad));
  }
}

// ==========================
// RADAR PULSES
// ==========================
void drawPulses() {
  if (!isRunning) return;

  for (int i = pulses.size() - 1; i >= 0; i--) {
    RadarPulse p = pulses.get(i);
    p.update();
    p.draw();
    if (p.dead()) pulses.remove(i);
  }
}

// ==========================
// SWEEP BEAM
// ==========================
void drawSweep() {
  float rad = radians(visualAngle);

  for (int i = 0; i < 12; i++) {
    stroke(0, 255, 0, 120 - i*8);
    strokeWeight(2);
    line(0, 0,
         (420 - i*10)*cos(rad),
        -(420 - i*10)*sin(rad));
  }
}

// ==========================
// TARGET BLIP
// ==========================
void drawTarget() {
  if (lastDistance > 0 && lastDistance < 200) {
    float rad = radians(visualAngle);
    float d = map(lastDistance, 0, 200, 0, 400);

    float px = d * cos(rad);
    float py = -d * sin(rad);

    stroke(0, 255, 0);
    fill(0, 255, 0, 180);
    ellipse(px, py, 12, 12);

    fill(0, 255, 0);
    textSize(14);
    text(lastDistance + " cm", px + 12, py - 8);
  }
}

// ==========================
// HUD
// ==========================
void drawHUD() {
  resetMatrix();
  fill(0, 255, 0);
  textSize(16);

  text("RADAR SCAN SYSTEM", 20, 30);
  text("ANGLE : " + visualAngle + "°", 20, 55);
  text("DIST  : " + lastDistance + " cm", 20, 80);
  text("STATUS: " + (isRunning ? "RUNNING" : "PAUSED"), 20, 105);
}

// ==========================
// BUTTON
// ==========================
void drawButton() {
  int bx = width - 160;
  int by = 30;
  int bw = 120;
  int bh = 40;

  resetMatrix();

  stroke(0, 255, 0);
  fill(isRunning ? color(0, 120, 0) : color(120, 0, 0));
  rect(bx, by, bw, bh, 6);

  fill(0, 255, 0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text(isRunning ? "PAUSE" : "RESUME", bx + bw/2, by + bh/2);
  textAlign(LEFT, BASELINE);
}

// ==========================
// MOUSE CLICK
// ==========================
void mousePressed() {
  int bx = width - 160;
  int by = 30;
  int bw = 120;
  int bh = 40;

  if (mouseX > bx && mouseX < bx + bw &&
      mouseY > by && mouseY < by + bh) {

    isRunning = !isRunning;
  }
}

