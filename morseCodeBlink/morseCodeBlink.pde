/* Blink without Delay
 
 Turns on and off a light emitting diode(LED) connected to a digital  
 pin, without using the delay() function.  This means that other code
 can run at the same time without being interrupted by the LED code.
 
 The circuit:
 * LED attached from pin 13 to ground.
 * Note: on most Arduinos, there is already an LED on the board
 that's attached to pin 13, so no hardware is needed for this example.
 
 
 created 2005
 by David A. Mellis
 modified 8 Feb 2010
 by Paul Stoffregen
 modified 8 May 2011
 by Steven Oxley
 
 This example code is in the public domain.
 */

const int ledPin =  13;      // the number of the LED pin
const int DIT = 1;
const int DIT_SPACING = 2;
const int DAH = 3;
const int DAH_SPACING = 4;
const int SPACE = 5;
const int NEXT_COMMAND = 6;

//State variables
int ledState = LOW;             // ledState used to set the LED
long previousMillis = 0;        // will store last time LED was updated
int codeState = NEXT_COMMAND;

//Configuration variables
int ditLength = 100;
int dahLength = 500;
int ditSpacingLength = 500;
int dahSpacingLength = 100;

int currentCommand = 0;

//make sure to set this to the length of your commands array
int commandsLength = 54;
int commands[] =
  {DIT, DIT, DIT, DIT, SPACE, DIT, SPACE, DIT, DAH, DIT, DIT, SPACE, DIT, DAH, DIT, DIT, SPACE, DAH, DAH, DAH, SPACE, DAH, DAH, DIT, DIT, DAH, DAH, SPACE, SPACE, //HELLO,
  DIT, DAH, DAH, SPACE, DAH, DAH, DAH, SPACE, DIT, DAH, DIT, SPACE, DIT, DAH, DIT, DIT, SPACE, DAH, DIT, DAH, DIT, DAH, DAH, SPACE, SPACE}; //WORLD!

boolean switchLedAfterInterval(int interval) {
  unsigned long currentMillis = millis();
 
  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;   

    // if the LED is off turn it on and vice-versa:
    if (ledState == LOW)
      changeLedState(HIGH);
    else
      changeLedState(LOW);
    
    return true;
  }
  
  return false;
}

boolean waitForInterval(int interval) {
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;
    return true;
  }
  return false;
}

void dit() {
  boolean isSwitched = false;
  if (codeState == NEXT_COMMAND) {
    changeCodeState(DIT);
    //turn on LED immediately
    switchLedAfterInterval(0);
  }
  else if (codeState == DIT) {
    isSwitched = switchLedAfterInterval(ditLength);
    if (isSwitched) {
      changeCodeState(DIT_SPACING);
    }
  }
  else if (codeState == DIT_SPACING) {
    isSwitched = waitForInterval(ditSpacingLength);
    if (isSwitched) {
      changeCodeState(NEXT_COMMAND);
    }
  }
}

void dah() {
  boolean isSwitched = false;
  if (codeState == NEXT_COMMAND) {
    changeCodeState(DAH);
    //turn on LED immediately
    switchLedAfterInterval(0);
  }
  
  if (codeState == DAH) {
    isSwitched = switchLedAfterInterval(dahLength);
    if (isSwitched) {
      changeCodeState(DAH_SPACING);
    }
  }
  else if (codeState == DAH_SPACING) {
    isSwitched = waitForInterval(dahSpacingLength);
    if (isSwitched) {
      changeCodeState(NEXT_COMMAND);
    }
  }
}

void space() {
  boolean isSwitched = false;
  if (codeState == NEXT_COMMAND) {
    changeCodeState(SPACE);  
  }
  
  isSwitched = waitForInterval(dahLength);
  if (isSwitched) {
    changeCodeState(NEXT_COMMAND);
  }
}

void changeLedState(int state) {
  ledState = state;
  Serial.print("New LED state: ");
  if (state == HIGH) {
    Serial.println("HIGH");
  }
  else if (state == LOW) {
    Serial.println("LOW"); 
  }
}

void changeCodeState(int state) {
  codeState = state;
  Serial.print("New code state: ");
  switch (state) {
    case DIT:
      Serial.println("DIT");
      break;
    case DIT_SPACING:
      Serial.println("DIT_SPACING");
      break;
    case DAH:
      Serial.println("DAH");
      break;
    case DAH_SPACING:
      Serial.println("DAH_SPACING");
      break;
    case SPACE:
      Serial.println("SPACE");
      break;
    case NEXT_COMMAND:
      Serial.println("NEXT_COMMAND");
      break;
  } 
}

void logNewCommand(int command) {
  Serial.print("New command: ");
  switch (command) {
     case DIT:
       Serial.println("DIT");
       break;
     case DAH:
       Serial.println("DAH");
       break;
     case SPACE:
       Serial.println("SPACE");
       break;
  }
}

void setup() {
  // set the digital pin as output:
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, ledState); 
  Serial.begin(9600);
}

void loop() {
  int commandToRun = commands[currentCommand];
  
  switch (commandToRun) {
    case DIT:
      dit();
      break;
    case DAH:
      dah();
      break;
    case SPACE:
      space();
      break;
  }
  
  if (codeState == NEXT_COMMAND) {
    currentCommand += 1;
    if (currentCommand >= commandsLength) {
      //restart from the beginning of the commands when we reach the end
      currentCommand = 0;
    }
    logNewCommand(commands[currentCommand]);
  }

  // set the LED with the ledState of the variable:
  digitalWrite(ledPin, ledState);
}

