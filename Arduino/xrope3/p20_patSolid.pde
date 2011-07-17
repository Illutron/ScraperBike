// ========================================
// SOLID PATTERN
// ========================================

Tpattern patSolid;
unsigned char patSolidCmdL;
unsigned char patSolidCmdR;

unsigned char patSolidAutoRandomize = true;

void setSolidAutoRandomize(unsigned char state)
{
  patSolidAutoRandomize = state;
}

void initPatSolid()
{
  Tpattern *pat = &patSolid;
  pat->length = 10;
  pat->pos = 0;
  pat->repeats = 0;
  pat->count = 0;
  pat->restart = &patSolidRestart;
  pat->paint = &patSolidPaint;
  pat->randomize = &patSolidRandomize;
  // 
  setSolidColor(1,0,0);  
}

void setSolidColor(int red, int green, int blue)
{
  setSolidColorL(red,green,blue);
  setSolidColorR(red,green,blue);
}

void setSolidColorL(int red, int green, int blue)
{
  patSolidCmdL = getRopeCommand(red,green,blue);
}

void setSolidColorR(int red, int green, int blue)
{
  patSolidCmdR = getRopeCommand(red,green,blue);
}

void patSolidRandomize()
{
    patSolidCmdL = 0x80;
    patSolidCmdR = 0x80;
    while((patSolidCmdL != 0x80) && (patSolidCmdR != 0x80))
    {
      setSolidColorL(random(2),random(2),random(2));
      setSolidColorR(random(2),random(2),random(2));
    }
}

void patSolidRestart()
{
  if (patSolidAutoRandomize)
  {
    patSolidRandomize();
  }
}

void patSolidPaint(int index)
{
  set2CpatternL(0x7FFF, 0x80, patSolidCmdL);
  set2CpatternR(0x7FFF, 0x80, patSolidCmdR);
}

