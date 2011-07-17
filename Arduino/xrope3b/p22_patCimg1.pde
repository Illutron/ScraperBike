Tpattern patCimg1;

void initPatCimg1()
{
  Tpattern *pat = &patCimg1;
  pat->restart = &patSolidRestart;
  pat->paint = &patSolidPaint;
  pat->randomize = &patSolidRandomize;
  pat->length = cimg1_width;
  pat->repeats = 0;
  pat->count = 0;
  pat->restart();
}

void patCimg1Paint(int index)
{
  unsigned char cmdBuf[10];

  int co = 0;
  int z = index;
  int dx = 0;
  unsigned char c;
  unsigned char d;
  // left side
  co = z*5;
  for (int y=0;y<5;y++)
  {
    dx = y << 1;
    for (int x=0;x<2;x++)
    {
      d = pgm_read_byte_near(cimg1 + co + y) >> ((1-x) << 2);
      c = ((d & 0x01) == 0 ? 0 : 0x04 ) | ((d & 0x02) == 0 ? 0 : 0x01) | ((d & 0x04) == 0 ? 0 : 0x10) | 0x80;
      cmdBuf[dx+x] = c;
    }
  }
  setColPatternL(&cmdBuf[0]);
  
  z = cimg1_width - (1 + index);
  co = z*5;
  for (int y=0;y<5;y++)
  {
    dx = y << 1;
    for (int x=0;x<2;x++)
    {
      d = pgm_read_byte_near(cimg1 + co + y) >> ((1-x) << 2);
      c = ((d & 0x01) == 0 ? 0 : 0x04 ) | ((d & 0x02) == 0 ? 0 : 0x01) | ((d & 0x04) == 0 ? 0 : 0x10) | 0x80;
      cmdBuf[dx+x] = c;
    }
  }
  setColPatternR(&cmdBuf[0]);
  
}

void patCimg1Restart()
{
  Tpattern *pat = &patCimg1;
  pat->pos = 0;
}

void patCimg1Randomize()
{
  
}
