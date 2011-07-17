struct Tscheduler
{
  unsigned int cycle;
  unsigned int pos;
  unsigned char sem;
  void (*handler)();
};

#define _numSchedulers 5
#define _numActiveSchedulers 5

Tscheduler Schedulers[_numSchedulers];

void setScheduleCycle(struct Tscheduler *S, unsigned int cycle)
{
  S->cycle = cycle;
}

void initScheduler()
{
  // status LED
  Schedulers[0].cycle = _toLED;
  Schedulers[0].handler = &toggleLED;
  Schedulers[0].pos = 0;
  Schedulers[0].sem = false;

  // rope sync
  Schedulers[1].cycle = _toRopeSync;
  Schedulers[1].handler = &ropeSync;
  Schedulers[1].pos = 0;
  Schedulers[1].sem = false;
  
  // wheel sensor
  Schedulers[2].cycle = _toWheel;
  Schedulers[2].handler = &wheelScan;
  Schedulers[2].pos = 0;
  Schedulers[2].sem = false;
  
  // android
  Schedulers[3].cycle = _toAndroid;
  Schedulers[3].handler = &androidScan;
  Schedulers[3].pos = 0;
  Schedulers[3].sem = false;
    
  // pattern
  Schedulers[4].cycle = _toPattern;
  Schedulers[4].handler = &scanPattern;
  Schedulers[4].pos = 0;
  Schedulers[4].sem = false;
  
}

void scheduleScan()
{
  Tscheduler *sch;
  for (int i=0;i<_numActiveSchedulers;i++)
  {
    sch = &Schedulers[i];
    sch->pos++;
    if (sch->pos >= sch->cycle)
    {
      sch->pos = 0;
      sch->sem = true;
    }
  }
}

void scheduler()
{
  Tscheduler *sch;
  for (int i=0;i<_numActiveSchedulers;i++)
  {
    sch = &Schedulers[i];
    if (sch->sem)
    {
      sch->sem = false;
      sch->handler();
    }
  }
}

void setRopeSpeed(unsigned int cycle)
{
  Schedulers[0].cycle = cycle;
}
