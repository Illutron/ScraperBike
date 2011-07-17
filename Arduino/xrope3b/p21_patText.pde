// ========================================
// TEXT PATTERN
// ========================================

struct StringSide
{
  unsigned char charIndex;
  unsigned char charVal;
  unsigned char numCols;
  unsigned char colIndex;
};

Tpattern patText;
Tmessage *activeMessage;
unsigned char patTextFGcmd;
unsigned char patTextBGcmd;
unsigned char patTextNumChars;
StringSide patTextL;
StringSide patTextR;
Tmessage *patTextMessage;
String *patTextS;
int patTextMessageIndex = 0;
unsigned char doRandomizeTextColor = true;

void toggleTextColorRandomize()
{
  doRandomizeTextColor = 1-doRandomizeTextColor;
}

void setTextColorRandomize(unsigned char state)
{
  doRandomizeTextColor = state;
}

void selectMessage(int index)
{
  //patTextMessageIndex = index % numMessages;
  patTextMessageIndex = index % 4;
  //
  Tmessage *msg = &RopeMessages[patTextMessageIndex];
  patTextS = msg->message;
  patTextNumChars = patTextS->length();
  Tpattern *pat = &patText;
  pat->length = getStringWidth(patTextS);
  patTextFGcmd = msg->fgCmd;
  patTextBGcmd = msg->bgCmd;
  //
  patTextL.charIndex = patTextNumChars-1;
  patTextL.charVal = patTextS->charAt(patTextL.charIndex);
  patTextL.numCols = getCharWidth(patTextL.charVal);
  patTextL.colIndex = patTextL.numCols-1;
  patTextR.charIndex = 0;
  patTextR.charVal = patTextS->charAt(patTextR.charIndex);
  patTextR.numCols = getCharWidth(patTextR.charVal);
  patTextR.colIndex = 0;
}

void initPatText()
{
  selectMessage(0);
  Tpattern *pat = &patText;
  pat->length = getStringWidth(patTextS);
  pat->pos = 0;
  pat->repeats = 0;
  pat->count = 0;
  pat->restart = &patTextRestart;
  pat->paint = &patTextPaint;
  pat->randomize = &patTextRandomize;
}

int pcycle = 0;

void patTextRestart()
{
  selectMessage(pcycle);
  pcycle++;
  pcycle %= 4;
}

void patTextPaint(int index)
{
   // LEFT SIDE
   set2CpatternL(getCharColumn(patTextL.charVal,patTextL.colIndex),patTextBGcmd,patTextFGcmd);
   if(patTextL.colIndex > 0)
   {
     patTextL.colIndex--;
   }
   else
   {
     // reached leftmost side of character. go to next character
     if (patTextL.charIndex > 0)
     {
       patTextL.charIndex--;
     }
     else
     {
       // !!! now what? out of characters! wraparound.
       patTextL.charIndex = patTextNumChars-1;
     }
     patTextL.charVal = patTextS->charAt(patTextL.charIndex);
     patTextL.numCols = getCharWidth(patTextL.charVal);
     patTextL.colIndex = patTextL.numCols-1;
   }
   
   // RIGHT SIDE
   set2CpatternR(getCharColumn(patTextR.charVal,patTextR.colIndex),patTextBGcmd,patTextFGcmd);
   if (patTextR.colIndex < patTextR.numCols-1)
   {
     patTextR.colIndex++;
   }
   else
   {
     // reached rightmost side of character. go to next character.
     if (patTextR.charIndex < (patTextNumChars-1))
     {
       patTextR.charIndex++;
     }
     else
     {
       // !!! now what? out of characters! wraparound.
       patTextR.charIndex = 0;
     }
     patTextR.charVal = patTextS->charAt(patTextR.charIndex);
     patTextR.numCols = getCharWidth(patTextR.charVal);
     patTextR.colIndex = 0;
   }
 }

// ===================



// -------------------------------------------------------------------


void patText_setFGcolor(int red, int green, int blue)
{
   patTextFGcmd = getRopeCommand(red,green,blue);
}

void patText_setBGcolor(int red, int green, int blue)
{
  patTextBGcmd = getRopeCommand(red,green,blue);
}

void patTextRandomColor()
{
  patTextRandomFGcolor();
  patTextRandomBGcolor();
}

void patTextRandomFGcolor()
{
  unsigned char ok = false;
  while(!ok)
  {
    patTextFGcmd = getRopeCommand(random(2),random(2),random(2));
    ok = (patTextFGcmd != 0x80);
  }
}

void patTextRandomBGcolor()
{
  unsigned char ok = false;
  while(!ok)
  {
    patTextBGcmd = getRopeCommand(random(2),random(2),random(2));
    ok = (patTextBGcmd != 0x80);
  }
}

void patText_restart()
{
//  if (doRandomizeTextColor)
//  {
//    patTextRandomColor();
//  }
  // patTextRandomize();
}

void cycleMessage()
{
    selectMessage(patTextMessageIndex++);
}

void patTextRandomize()
{
  selectMessage(random(numMessages));
  patTextRandomColor();
}
