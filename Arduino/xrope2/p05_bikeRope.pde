void ropeFrameAdvance()
{
  patternRunner();
}

// cyclic slant buffer - to compensate for diagonal bar

unsigned char ropeSlantBufL[10][10];
unsigned char ropeSlantBufR[10][10];
unsigned char slantBufIndex = 0;

void scanSlantBuf()
{
  // left side. slant forward
  for (int i=0;i<10;i++)
  { 
    ropeCmd[i] =ropeSlantBufR[(slantBufIndex+9-i)%10][i]; // right
//    ropeCmd[19-i] = ropeSlantBufL[(slantBufIndex+i)%10][i]; // left -- wrong?
    ropeCmd[19-i] = ropeSlantBufL[(slantBufIndex+9-i)%10][i]; // left (corrected ?)
  }
  slantBufIndex++;
  slantBufIndex %= 10;
}

void setSlantBufL(int index, unsigned char cmd)
{
  ropeSlantBufL[slantBufIndex][index] = cmd;
}

void setSlantBufR(int index, unsigned char cmd)
{
  ropeSlantBufR[slantBufIndex][index] = cmd;
}

// ------------------------------------------------------------
//  STRUCTS
// ------------------------------------------------------------

struct TP
{
  int length;
  int pos;
  int repeats;
  int count;
  void (*restart) ();
  void (*paint) (int index); 
};

struct StringSide
{
  unsigned char charIndex;
  unsigned char charVal;
  unsigned char numCols;
  unsigned char colIndex;
};

// ------------------------------------------------------------

TP *CP; // current pattern

void setBikeRopeColumnR(unsigned int pattern, unsigned char command0, unsigned char command1)
{
  for (int i=0;i<10;i++)
  {
    unsigned char cmd = (pattern >> i) & 0x01 ? command1 : command0;
    //setRopeCommand(i,cmd);
    setSlantBufR(i,cmd);
  }
}

void setBikeRopeColumnL(unsigned int pattern, unsigned char command0, unsigned char command1)
{
  for (int i=0;i<10;i++)
  {
    unsigned char cmd = (pattern >> i) & 0x01 ? command1 : command0;
    //setRopeCommand(21-i,cmd);
    setSlantBufL(i,cmd);
  }
}


// =================================================
// PATTERN 1
// =================================================

TP pt1;
unsigned char pt1FGcmd;
unsigned char pt1BGcmd;
unsigned char pt1NumChars;
StringSide pt1L;
StringSide pt1R;
String pt1S;

void pt1_init (String newString, unsigned char cmd0, unsigned char cmd1)
{
    pt1S = newString;
    pt1.paint = &pt1_paint;
    pt1.restart = &pt1_restart;
    //pt1S = newString;
    pt1BGcmd = cmd0;
    pt1FGcmd = cmd1;
    pt1NumChars = pt1S.length();
    pt1.length = getStringWidth(&pt1S);
    Serial.print("Num Chars: ");
    Serial.println((int) pt1NumChars);
    Serial.print("Num Cols: ");
    Serial.println((int) pt1.length);
    for (int i=0;i<pt1NumChars;i++)
    {
      int Q = pt1S.charAt(i);
      //pt1S.charAt(i);
      Serial.print("Ascii: ");
      Serial.println(Q);
    }
    pt1.pos = 0;
    pt1.repeats = 1;
    pt1.count = 0;
    pt1_restart();
    // Serial.print("Pt1_init");
}

void pt1_setFGcolor(int red, int green, int blue)
{
   pt1FGcmd = getRopeCommand(red,green,blue);
}

void pt1_setBGcolor(int red, int green, int blue)
{
  pt1BGcmd = getRopeCommand(red,green,blue);
}

void pt1randomColor()
{
  pt1randomFGcolor();
  pt1randomBGcolor();
}

void pt1randomFGcolor()
{
  unsigned char ok = false;
  while(!ok)
  {
    pt1FGcmd = getRopeCommand(random(2),random(2),random(2));
    ok = (pt1FGcmd != 0x80);
  }
}

void pt1randomBGcolor()
{
  unsigned char ok = false;
  while(!ok)
  {
    pt1BGcmd = getRopeCommand(random(2),random(2),random(2));
    ok = (pt1BGcmd != 0x80);
  }
}

void pt1_restart()
{
    pt1L.charIndex = pt1NumChars-1;
    pt1L.charVal = pt1S.charAt(pt1L.charIndex);
    pt1L.numCols = getCharWidth(pt1L.charVal);
    pt1L.colIndex = pt1L.numCols-1;
    pt1R.charIndex = 0;
    pt1R.charVal = pt1S.charAt(pt1R.charIndex);
    pt1R.numCols = getCharWidth(pt1R.charVal);
    pt1R.colIndex = 0;
    // Serial.print("Pt1_restart");
}

void pt1_paint(int index)
{
   // LEFT SIDE
   setBikeRopeColumnL(getCharColumn(pt1L.charVal,pt1L.colIndex),pt1BGcmd,pt1FGcmd);
   if(pt1L.colIndex > 0)
   {
     pt1L.colIndex--;
   }
   else
   {
     // reached leftmost side of character. go to next character
     if (pt1L.charIndex > 0)
     {
       pt1L.charIndex--;
     }
     else
     {
       // !!! now what? out of characters! wraparound.
       pt1L.charIndex = pt1NumChars-1;
     }
     pt1L.charVal = pt1S.charAt(pt1L.charIndex);
     pt1L.numCols = getCharWidth(pt1L.charVal);
     pt1L.colIndex = pt1L.numCols-1;
   }
   
   // RIGHT SIDE
   setBikeRopeColumnR(getCharColumn(pt1R.charVal,pt1R.colIndex),pt1BGcmd,pt1FGcmd);
   if (pt1R.colIndex < pt1R.numCols-1)
   {
     pt1R.colIndex++;
   }
   else
   {
     // reached rightmost side of character. go to next character.
     if (pt1R.charIndex < (pt1NumChars-1))
     {
       pt1R.charIndex++;
     }
     else
     {
       // !!! now what? out of characters! wraparound.
       pt1R.charIndex = 0;
     }
     pt1R.charVal = pt1S.charAt(pt1R.charIndex);
     pt1R.numCols = getCharWidth(pt1R.charVal);
     pt1R.colIndex = 0;
   }
}

// =================================================
// PATTERN SEQUENCER
// =================================================


void nextPattern()
{
  pt1randomFGcolor();
}

void initPatterns()
{
  Serial.begin(38400);
//  String K = "+ ILLUTRON 2011 ";
  String K = char(0x8F);
  pt1_init(K,getRopeCommand(0,0,0),getRopeCommand(1,0,0));
//  pt1_init(" Hello, world ",getRopeCommand(0,0,0),getRopeCommand(1,0,0));
  CP = &pt1;
//    pt1_init("Hello world",getRopeCommand(0,0,0),getRopeCommand(0,1,0));
}


void patternRunner()
{
  CP->paint(CP->pos++);
  scanSlantBuf();
  if (CP->pos >= CP->length)
  {
    // reached end of pattern.
    CP->pos = 0;
    CP->restart();
    if (CP->count++ >= CP->repeats)
    {
      CP->count = 0;
      nextPattern();
    }
  }
}



