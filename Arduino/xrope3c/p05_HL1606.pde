#define pLatch 5
#define pClock 4
#define pData 3
#define pSync 2

// 5-meter rope has 30 modules (60 pixels)
// _numPixels is always twice _numModules.

#define _numModules 10
#define _numPixels _numModules * 2

#define useSlant

unsigned char ropeCmd[_numPixels];

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

// *********************************************************************************
//  CYCLIC SLANT COMPENSATION BUFFER
// *********************************************************************************
// Compensates for diagonally mounted LED bar

unsigned char ropeSlantBufL[10][10];
unsigned char ropeSlantBufR[10][10];
unsigned char slantBufIndex = 0;

// *********************************************************************************

void scanSlantBuf()
{
  slantBufIndex++;
  slantBufIndex %= 10;
  for (int i=0;i<10;i++)
  { 
  
    ropeCmd[i] =ropeSlantBufR[(slantBufIndex+9-i)%10][i]; // right side. slant backward
    ropeCmd[19-i] = ropeSlantBufL[(slantBufIndex+9-i)%10][i];  // left side. slant forward
  }
}

// *********************************************************************************

void setSlantBufL(int index, unsigned char cmd)
{
  ropeSlantBufL[slantBufIndex][index] = cmd;
}

void setSlantBufR(int index, unsigned char cmd)
{
  ropeSlantBufR[slantBufIndex][index] = cmd;
}


// *********************************************************************************
//  PRIVATE METHODS BYPASSING SLANT COMPENSATION
// *********************************************************************************

void setWholeRopeColor(unsigned char red, unsigned char green, unsigned char blue)
{
  unsigned char command = (red == 0 ? 0 : 0x04 ) | (green == 0 ? 0 : 0x01) | (blue == 0 ? 0 : 0x10) | 0x80;
  setWholeRopeCommand(command);
}

void setRopeColor(unsigned int index, unsigned char red, unsigned char green, unsigned char blue)
{
  setRopeCommand(index,getRopeCommand(red,green,blue));
}

void setRopeCommand(unsigned int index, unsigned char command)
{
  if (index < _numPixels) ropeCmd[index] = command;
}

void setRopelCommandUnsafe(unsigned int index, unsigned char command)
{
  ropeCmd[index] = command;
}

// =================================================
// PUBLIC ROPE METHODS
// =================================================

void initRope()
{
  setRopePins();
  setWholeRopeColor(0,0,0);
}

void scanRope()
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
}

void ropeSync()
{
  LS_sync();
}

void setWholeRopeCommand(unsigned char command)
{
  for (int i=0;i<_numPixels;i++)
  {
    ropeCmd[i] = command;
  }
}

unsigned char getRopeCommand(unsigned char red, unsigned char green, unsigned char blue)
{
  return  (red == 0 ? 0 : 0x04 ) | (green == 0 ? 0 : 0x01) | (blue == 0 ? 0 : 0x10) | 0x80;
}

// *********************************************************************************
// ACCESSOR METHODS USED BY PATTERNS
// *********************************************************************************


void set2CpatternL(unsigned int pattern, unsigned char command0, unsigned char command1)
{
  for (int i=0;i<10;i++)
  {
    unsigned char cmd = (pattern >> i) & 0x01 ? command1 : command0;
#ifdef useSlant
    setSlantBufL(i,cmd);
#else
    ropeCmd[i] = cmd;
#endif
  }
}

void set2CpatternR(unsigned int pattern, unsigned char command0, unsigned char command1)
{
  for (int i=0;i<10;i++)
  {
    unsigned char cmd = (pattern >> i) & 0x01 ? command1 : command0;
    //setRopeCommand(i,cmd);
#ifdef useSlant
    setSlantBufR(i,cmd);
#else
    ropeCmd[19-i] = cmd;
#endif
  }
}

void setColPatternL(unsigned char *cmds)
{
  for (int i=0;i<10;i++)
  {
#ifdef useSlant
    setSlantBufL(i,cmds[i]);
#else
    ropeCmd[i] = cmds[i];
#endif
  }
}

void setColPatternR(unsigned char *cmds)
{
  for (int i=0;i<10;i++)
  {
#ifdef useSlant
    setSlantBufR(i,cmds[i]);
#else
    ropeCmd[19-i] = cmds[i];
#endif
  }
}
