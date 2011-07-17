#include "avr/pgmspace.h"
#include "avr/interrupt.h"
#include <SPI.h>
#include <Adb.h>
#define MAX_RESET 8

#define _toRope 300
#define _toWheel 30
#define _toAndroid 1000

volatile unsigned char semRopeScan = 0;
volatile unsigned char semWheelScan = 0;
volatile unsigned char semAndroidScan = 0;

long wheelTicks = 0;

unsigned int dtRope;
unsigned int dtWheel;
unsigned int dtAndroid;
unsigned int toRope = _toRope;

void setup()
{
  dtRope = 0;
  dtWheel = 0;
  dtAndroid = 0;
  initRope();
  initWheelSensor();
  initAndroid();
  initInterrupt();
}

void loop()
{
  if (semRopeScan)
  {
    semRopeScan = 0;
    ropeScan();
  }
  if (semWheelScan)
  {
    semWheelScan = 0;
    wheelScan();
  }
  if (semAndroidScan)
  {
    semAndroidScan = 0;
    androidScan();
  }
}


SIGNAL(TIMER1_COMPA_vect)
{
  // this happens 16,000,000 / 1024 = 16,625 times per second
  
  // ROPE
  if (dtRope == 0)
  {
      dtRope = toRope;
      semRopeScan = true;
  }
  else
  {
      dtRope--;
  }
  
  // WHEEL
  wheelTicks++;
  if (dtWheel == 0)
  {
      dtWheel = _toWheel;
      semWheelScan = true;
  }
  else
  {
      dtWheel--;
  }
  
  // ANDROID
  if (dtAndroid == 0)
  {
      dtAndroid = _toAndroid;
      semAndroidScan = true;
  }
  else
  {
      dtAndroid--;
  }


}

void initInterrupt()
{
  cli();
  TCCR1A= 0 ;
  TCCR1B = _BV(WGM12) | _BV(CS12) | _BV(CS10) ; // clock div 1024
  //  TCCR1B = _BV(WGM12) | _BV(CS12) ; // clock div 256
  //  TCCR1B = _BV(WGM12) | _BV(CS11) | _BV(CS10) ; // clock div 64
  TIMSK1 = _BV(OCIE1A);
  sei();
}


