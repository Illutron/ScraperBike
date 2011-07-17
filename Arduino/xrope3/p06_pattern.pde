
// ------------------------------------------------------------
//  STRUCTS
// ------------------------------------------------------------

struct Tpattern
{
  int length;
  int pos;
  int repeats;
  int count;
  void (*restart) ();
  void (*paint) (int index); 
  void (*randomize) ();
};


// =================================================
// PATTERN SEQUENCER
// =================================================



