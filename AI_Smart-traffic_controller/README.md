

  
# AI-Driven Density-Based Smart Traffic Controller

An intelligent traffic management system that uses Computer Vision and Arduino to dynamically adjust traffic light timers based on real-time vehicle density.

## 🛠 Tech Stack & Hardware
* **Hardware:** Arduino Mega, ESP32 (IP Camera Stream), 74HC595 Shift Register, 7-Segment Display
* **Software:** Python, OpenCV, Arduino IDE
* **AI/Model:** Roboflow Inference API (Custom Car Detection Model)

## ⚙️ System Architecture & Logic
1. **Live Feed:** ESP32 captures and streams the live video feed of the road intersection.
2. **Object Detection:** A Python script (`traffic_vision.py`) fetches the stream and runs inference using a custom-trained Roboflow model to detect and count the number of cars present.
3. **Hardware Integration:** The live car count is transmitted to the Arduino board via Serial communication (e.g., `CARS:3`).
4. **Dynamic Timer Allocation:** The Arduino (`timer_logic.ino`) scales the green light duration dynamically (`1 Car = 5 seconds`) and drives a hardware countdown using a shift-register and 7-segment display mechanism


## 📂 File Structure
* `traffic_vision.py`: Handles video streaming, API calls for object detection, and serial transmission.
* `timer_logic.ino`: Embedded C++ script for processing serial inputs, state management, and 7-segment hardware execution.
