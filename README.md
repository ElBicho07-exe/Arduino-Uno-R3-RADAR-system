# Arduino Ultrasonic RADAR System

A **military‑style RADAR visualization project** built using an Arduino Uno, a servo motor, and an ultrasonic distance sensor. The system scans an area mechanically and displays detected objects in real time on a PC with a glowing, tactical RADAR UI.

---

##  Project Overview

This project simulates a 2D RADAR system:

* A **servo motor** sweeps from 0° to 180°
* An **ultrasonic sensor** measures distance at each angle
* The Arduino streams angle–distance data via Serial
* A **Processing-based UI** renders a real-time RADAR screen with glow, sweep trails, target blips, and distance labels

The result is a visually rich, defense-style RADAR interface suitable for learning **embedded systems, serial communication, and visualization**.

---

##  Hardware Requirements

| Component                        | Quantity  |
| -------------------------------- | --------- |
| Arduino Uno R3                   | 1         |
| Ultrasonic Sensor (HC‑SR04)      | 1         |
| Servo Motor (SG90 / MG90)        | 1         |
| Jumper Wires                     | As needed |
| External 5V supply (recommended) | 1         |
| USB Cable                        | 1         |

---

##  Wiring Connections

### Ultrasonic Sensor (HC‑SR04)

| HC‑SR04 Pin | Arduino Pin |
| ----------- | ----------- |
| VCC         | 5V          |
| GND         | GND         |
| TRIG        | D10         |
| ECHO        | D11         |

### Servo Motor

| Servo Wire      | Arduino             |
| --------------- | ------------------- |
| Red             | 5V (or external 5V) |
| Brown / Black   | GND                 |
| Yellow / Orange | D9                  |

 **Important:**

* If using an external power supply for the servo, **connect Arduino GND and external GND together**.
* Servo jitter or no movement is almost always due to insufficient power.

---

##  Software Requirements

### Arduino Side

* Arduino IDE
* Servo library (included by default)

### PC Side (UI)

* Processing (latest version)
* Processing Serial library

---

##  How to Run the Project

### Step 1 — Upload Arduino Code

1. Open Arduino IDE
2. Paste the Arduino radar sketch
3. Select correct board and COM port
4. Upload
5. **Close Serial Monitor**

### Step 2 — Run the RADAR UI

1. Open Processing
2. Paste the Processing RADAR UI code
3. Replace `COM3` with your Arduino’s COM port
4. Click **Run ▶**

---

##  UI Features

* Phosphor‑green radar grid
* Sweeping beam with fade trail
* Pulsing target detection blips
* Distance label near detected object
* HUD showing angle, distance, and range

---

##  Data Protocol

Arduino sends data in the format:

```
angle,distance.
```

Example:

```
45,32.
```

Processing listens until `.` and parses angle and distance values.

---

##  Troubleshooting

| Issue            | Solution                     |
| ---------------- | ---------------------------- |
| Servo not moving | Use external 5V power        |
| UI freezes       | Close Arduino Serial Monitor |
| Black screen     | Wrong COM port               |
| No detections    | Object out of range          |
| Random errors    | Check loose wiring           |

---

##  Possible Enhancements

* Sound ping on detection
* Multiple target memory
* Distance rings with numeric labels
* Full‑screen / executable UI
* Python or OpenGL version
* Encoder-based rotation (no servo)

---

##  Learning Outcomes

This project helps understand:

* Servo control and PWM
* Ultrasonic ranging principles
* Serial communication
* Real‑time data visualization
* Embedded + PC software integration

---

##  License

Open-source. Free to use, modify, and extend for educational purposes.

---

**Author:** Shaurya Attreya AKA Ronny
