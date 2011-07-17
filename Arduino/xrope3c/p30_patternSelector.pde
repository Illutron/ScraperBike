
Tpattern *CP; // current pattern

#define _patternSlots 8
int numPatterns = 3;
int patternIndex = 0;
unsigned char autoPatternCycle = false;
Tpattern *allPatterns[_patternSlots];

void patternRunner()
{
  CP->paint(CP->pos++);
  if (CP->pos >= CP->length)
  {
    // reached end of pattern.
    CP->pos = 0;
    CP->restart();
    if ((CP->repeats < 99) && (CP->count++ >= CP->repeats))
    {
      CP->count = 0;
      nextPattern();
    }
  }
}

void selectPattern(unsigned int index)
{
  patternIndex = index % numPatterns;
  CP = allPatterns[patternIndex];
  CP->restart();
  CP->pos = 0;
  CP->count = 0;
}

int getNumPatterns()
{
  return numPatterns;
}

void nextPattern()
{
  // pseudocode: if sequencer is running, go to next pattern
  if(autoPatternCycle)
  {
    selectPattern(patternIndex+1);
    if (patternIndex == 0)
    {
      selectMessage(random(numMessages));
    }
  }
}

void initSequencer()
{
  initPatText();
  initPatSolid();
  initPatCimg1();
  allPatterns[0] = &patText;
  allPatterns[1] = &patSolid;
  allPatterns[2] = &patCimg1;
  selectPattern(0);
}

void scanPattern()
{
  patternRunner();
  scanSlantBuf();
  scanRope();
}

void randomPattern()
{
  selectPattern(random(numPatterns));
  CP->randomize();
}

