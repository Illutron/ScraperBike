#define wheelScanPin 54
#define wheelSupplyPin 55

float wheelAvg = 500;

void initWheelSensor()
{
  pinMode(wheelScanPin,INPUT);
  digitalWrite(wheelScanPin,HIGH);
  pinMode(wheelSupplyPin,OUTPUT);
  digitalWrite(wheelSupplyPin,LOW);
}

unsigned char wheelRevAutoColor = true;

void toggleWheelRevAutoColor()
{
  wheelRevAutoColor = 1-wheelRevAutoColor;
}

void setWheelRevAutoColor(unsigned char state)
{
  wheelRevAutoColor = state;
}

volatile unsigned char magState = 0;
volatile unsigned char magDelay = 0;

void wheelRevolution()
{
  // 
  if (wheelRevAutoColor)
  {
     patTextRandomFGcolor();
  }
}

void wheelScan()
{
  unsigned char magScan = 1-digitalRead(wheelScanPin);
  if (magScan == magState)
  {
    magDelay = 0;
  }
  else
  {
    magDelay++;
    if (magDelay > 5)
    {
      magState = magScan;
      magDelay = 0;
      if (magState == 1)
      {
        wheelRevolution();
      }
    }
  }
}
