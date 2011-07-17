#define pLatch 5
#define pClock 4
#define pData 3
#define pSync 2

// 5-meter rope has 30 modules (60 pixels)
// _numPixels is always twice _numModules.

#define _numModules 11
#define _numPixels _numModules * 2

unsigned char ropeCmd[_numPixels];

void setWholeRopeColor(unsigned char red, unsigned char green, unsigned char blue)
{
  unsigned char command = (red == 0 ? 0 : 0x04 ) | (green == 0 ? 0 : 0x01) | (blue == 0 ? 0 : 0x10) | 0x80;
  setWholeRopeCommand(command);
}

void setRopeColor(unsigned int index, unsigned char red, unsigned char green, unsigned char blue)
{
  setRopeCommand(index,getRopeCommand(red,green,blue));
}

unsigned char getRopeCommand(unsigned char red, unsigned char green, unsigned char blue)
{
  return  (red == 0 ? 0 : 0x04 ) | (green == 0 ? 0 : 0x01) | (blue == 0 ? 0 : 0x10) | 0x80;
}

void setRopeCommand(unsigned int index, unsigned char command)
{
  if (index < _numPixels) ropeCmd[index] = command;
}

void setRopelCommandUnsafe(unsigned int index, unsigned char command)
{
  ropeCmd[index] = command;
}

void setWholeRopeCommand(unsigned char command)
{
  for (int i=0;i<_numPixels;i++)
  {
    ropeCmd[i] = command;
  }
}

void initRope()
{
  setRopePins();
  setWholeRopeColor(0,0,0);
  initPatterns();
}

void ropeScan()
{
  for (int m=_numModules-1;m>=0;m--)
  {
    if (m % 6 == 0) LS_sync();
    for (int x=1;x>=0;x--)
    {
      LS_pushCMD(ropeCmd[(m << 1)+x]);
    }
  }
  LS_latch();
  ropeFrameAdvance();
}

// *********************************************************************************
//  HARDWARE
// *********************************************************************************

void setRopePins()
{
  pinMode(pLatch,OUTPUT);
  pinMode(pClock,OUTPUT);
  pinMode(pSync,OUTPUT);
  pinMode(pData,OUTPUT);
}

void LS_pushCMD(unsigned char cmd)
{
  shiftOut(pData, pClock, MSBFIRST, cmd);
}

void LS_sync()
{
  digitalWrite(pSync,HIGH);
  delayMicroseconds(1);
  digitalWrite(pSync,LOW);
  delayMicroseconds(1);
}

void LS_latch()
{
  digitalWrite(pLatch, HIGH);
  delayMicroseconds(1);
  digitalWrite(pLatch, LOW);
  delayMicroseconds(1);
}

