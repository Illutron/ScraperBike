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

volatile unsigned char magState = 0;
volatile unsigned char magDelay = 0;

void wheelRevolution()
{
  wheelAvg = 0.6 * wheelAvg + wheelTicks / 120.64; // works with 72cm wheel diameter
  toRope = (int) wheelAvg;
  wheelTicks = 0;
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
