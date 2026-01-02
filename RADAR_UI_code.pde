import processing.serial.*;

Serial myPort;
String data = "";

int angle = 0;
int distance = 0;

float pulse = 0;

void setup() {
  size(900, 650);
  smooth(8);

  myPort = new Serial(this, "COM4", 9600);
  myPort.bufferUntil('.');
}

void draw() {
  background(0, 40);

  translate(width/2, height - 50);

  drawRadarGrid();
  drawSweep();
  drawTarget();
  drawHUD();

  pulse += 0.08;
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = trim(data);
    data = data.substring(0, data.length() - 1);

    String[] values = split(data, ',');
    if (values.length == 2) {
      angle = int(values[0]);
      distance = int(values[1]);
    }
  }
}

void drawRadarGrid() {
  stroke(0, 255, 80, 120);
  noFill();

  for (int r = 100; r <= 400; r += 100) {
    arc(0, 0, r*2, r*2, PI, TWO_PI);
  }

  for (int a = 0; a <= 180; a += 30) {
    float rad = radians(a);
    line(0, 0, 400*cos(rad), -400*sin(rad));
  }
}

void drawSweep() {
  float rad = radians(angle);

  for (int i = 0; i < 6; i++) {
    stroke(0, 255, 0, 60 - i*10);
    strokeWeight(2);
    line(0, 0,
         420*cos(rad - radians(i)),
        -420*sin(rad - radians(i)));
  }
}

void drawTarget() {
  if (distance < 200) {
    float rad = radians(angle);
    float d = map(distance, 0, 200, 0, 400);

    float px = d * cos(rad);
    float py = -d * sin(rad);

    stroke(0, 255, 0);
    fill(0, 255, 0, 150 + 100*sin(pulse));
    ellipse(px, py, 10, 10);

    fill(0, 255, 0);
    textSize(14);
    text(distance + " cm", px + 10, py - 10);
  }
}

void drawHUD() {
  resetMatrix();
  fill(0, 255, 0);
  textSize(16);

  text("RADAR SCAN SYSTEM", 20, 30);
  text("ANGLE : " + angle + "°", 20, 55);
  text("DIST  : " + distance + " cm", 20, 80);
  text("RANGE : 200 cm", 20, 105);
}
