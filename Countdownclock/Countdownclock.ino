/*
  Countdown Clock Software
 */
 
int G = 0;
int SR_CK = 1;
int SR_RCK = 2;
int SR_IN = 3;

byte digits[] = {B11111100, B01100000, B1011010, B11110000, B01100110, B10110110, B10111110, B11100000, B11111110};

  
void setup() {                
  pinMode(G, OUTPUT);
  pinMode(SR_CK, OUTPUT);
  pinMode(SR_RCK, OUTPUT);
  pinMode(SR_IN, OUTPUT);

  enable_display();
  digitalWrite(SR_CK, LOW);
  digitalWrite(SR_RCK, LOW);
}

void loop() {

}

void enable_display() {
   digitalWrite(G, LOW);
}

void disable_display() {
   digitalWrite(G, HIGH);
}

void shift_out(int value) {
  digitalWrite(SR_IN, value);
  digitalWrite(SR_CK, HIGH);
  digitalWrite(SR_CK, LOW);
}

void write_digit(int value) {
  int digit_byte = digits[value];
  for (int i = 0; i < 8; i++) {
    shift_out(digit_byte && 0x1);
    digit_byte = digit_byte >> 1;
  }
}

void latch() {
  digitalWrite(SR_RCK, HIGH);
  digitalWrite(SR_RCK, LOW);
}



