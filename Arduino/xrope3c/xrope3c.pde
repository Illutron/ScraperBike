#include "avr/pgmspace.h"
#include "avr/interrupt.h"
#include <SPI.h>
#include <Adb.h>
#define MAX_RESET 8

#define _toPattern 250
#define _toRopeSync 2000
#define _toWheel 50
#define _toAndroid 1000
#define _toLED 5000

long wheelTicks = 0;

void setup()
{
  initRopeMessages();
  initRope();
  initWheelSensor();
  initAndroid();
  initSequencer();
  initScheduler();
  initStatusLED();
  initInterrupt();
}

void nullFunction()
{
}

void initStatusLED()
{
  pinMode(13,OUTPUT);
}

void toggleLED()
{
  digitalWrite(13,1-digitalRead(13));
}

void loop()
{
  scheduler(); // see p99 for details
}


SIGNAL(TIMER1_COMPA_vect)
{
  // this happens 16,000,000 / 1024 = 16,625 times per second
  scheduleScan();  
  wheelTicks++;
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


