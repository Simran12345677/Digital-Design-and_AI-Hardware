Import cv2
import serial
import time
import collections
from inference import get_model

# --- 1. SETTINGS ---
ARDUINO_PORT = "COM3"
BAUD_RATE = 9600
MODEL_ID = "car-nimrg/2"
API_KEY = "dDaSb7oogANpjfnOYx0P"
ESP32_STREAM_URL = "http://10.207.84.104/stream"

# --- 2. MODEL LOAD ---
print("🔄 Model load ho raha hai...")
model = get_model(model_id=MODEL_ID, api_key=API_KEY)
print("✅ Model ready!")

# --- 3. ARDUINO CONNECT ---
try:
    arduino = serial.Serial(ARDUINO_PORT, BAUD_RATE, timeout=1)
    time.sleep(2)
    print("✅ Arduino connected!")
except Exception as e:
    print(f"❌ Arduino connection failed: {e}")
    arduino = None

# --- 4. TIMER COMMAND ---
# --- 4. TIMER COMMAND ---
def send_timer_command(car_count):
    if arduino is None:
        return
    command = f"CARS:{car_count}\n"  # ✅ CARS:1, CARS:2, CARS:3...
    arduino.write(command.encode())
    print(f"📤 Command: {command.strip()} → Timer: {car_count * 5} sec")
# --- 5. DETECTION ---
def detect_cars(frame):
    try:
        results = model.infer(frame)[0]
        car_count = 0
        for det in results.predictions:
            if det.confidence > 0.5:
                car_count += 1
                x1 = int(det.x - det.width / 2)
                y1 = int(det.y - det.height / 2)
                x2 = int(det.x + det.width / 2)
                y2 = int(det.y + det.height / 2)
                cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
                cv2.putText(frame, f"Car {det.confidence:.2f}",
                            (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX,
                            0.6, (0, 255, 0), 2)
        return car_count, frame
    except Exception as e:
        print(f"❌ Detection error: {e}")
        return 0, frame

# --- 6. MAIN LOOP ---
def main():
    print("🎥 ESP32 stream connect ho raha hai...")
    cap = cv2.VideoCapture(ESP32_STREAM_URL)

    if not cap.isOpened():
        print("❌ Stream nahi khula!")
        return
    print("✅ Stream connected!")

    last_command_time = 0
    last_car_count = -1
    DETECT_INTERVAL = 2  # har 2 sec mein detect karo

    while True:
        ret, frame = cap.read()
        if not ret:
            print("⚠️ Frame nahi mila, retry...")
            time.sleep(0.5)
            continue

        current_time = time.time()

        if current_time - last_command_time >= DETECT_INTERVAL:
            car_count, frame = detect_cars(frame)
            print(f"🚗 Gaadi count: {car_count}")

            if car_count != last_car_count:
                send_timer_command(car_count)
                last_car_count = car_count

            last_command_time = current_time

        cv2.putText(frame, f"Cars: {last_car_count}", (10, 30),
                    cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
        cv2.imshow("ESP32 Car Detection", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()
    if arduino:
        arduino.close()

if __name__ == "__main__":
    main()
