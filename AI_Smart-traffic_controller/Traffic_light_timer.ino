// timer final 
int DS_pin = 4;
int STCP_pin = 6;  // Latch
int SHCP_pin = 5;  // Clock

int dec_digits[10] = {126, 48, 109, 121, 51, 91, 95, 112, 127, 123};

int timerSeconds = 0;
bool timerRunning = false;
unsigned long lastTick = 0;

void displayNumber(int num) {
  if (num < 0) num = 0;
  if (num > 99) num = 99;

  int tens = num / 10;
  int ones = num % 10;

  digitalWrite(STCP_pin, LOW);
  shiftOut(DS_pin, SHCP_pin, LSBFIRST, dec_digits[ones]);  // Units
  shiftOut(DS_pin, SHCP_pin, LSBFIRST, dec_digits[tens]);  // Tens
  digitalWrite(STCP_pin, HIGH);
}

void setup() {
  Serial.begin(9600);
  pinMode(DS_pin, OUTPUT);
  pinMode(STCP_pin, OUTPUT);
  pinMode(SHCP_pin, OUTPUT);
  displayNumber(0);
  Serial.println("Arduino Ready!");
}

void loop() {
  // Python se command aane ka wait
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n');
    command.trim();

    if (command.startsWith("CARS:")) {
      // "CARS:3" → 3 cars → 3*5 = 15 sec
      int carCount = command.substring(5).toInt();

      if (carCount == 0) {
        timerRunning = false;
        timerSeconds = 0;
        displayNumber(0);
        Serial.println("⏹ Timer band - 0 cars!");
      } else {
        timerSeconds = carCount * 5;  // ✅ Formula: cars * 5
        timerRunning = true;
        lastTick = millis();
        displayNumber(timerSeconds);
        Serial.print("✅ Timer shuru: ");
        Serial.print(timerSeconds);
        Serial.println(" sec");
      }
    }
  }

  // Countdown
  if (timerRunning && (millis() - lastTick >= 1000)) {
    lastTick = millis();
    timerSeconds--;
    displayNumber(timerSeconds);
    Serial.print("⏱ ");
    Serial.println(timerSeconds);

    if (timerSeconds <= 0) {
      timerSeconds = 0;
      timerRunning = false;
      displayNumber(0);
      Serial.println("✅ Timer khatam!");
    }
  }
}
