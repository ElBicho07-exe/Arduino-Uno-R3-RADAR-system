#include <Servo.h>

Servo radarServo;

const int trigPin = 10;
const int echoPin = 11;

long duration;
int distance;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  radarServo.attach(9);
  Serial.begin(9600);
}

void loop() {

  // Sweep 0 → 180
  for (int angle = 0; angle <= 180; angle++) {
    radarServo.write(angle);
    distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.println(".");

    delay(20);
  }

  // Sweep 180 → 0
  for (int angle = 180; angle >= 0; angle--) {
    radarServo.write(angle);
    distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.println(".");

    delay(20);
  }
}

int getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH, 25000); // timeout ~4m
  int dist = duration * 0.034 / 2;

  if (dist > 200 || dist == 0) return 200; // clamp
  return dist;
}
