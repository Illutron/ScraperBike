unsigned int getCharWidth(unsigned char ascii)
{
  int index = ascii - 0x20;
  unsigned int w =  pgm_read_byte_near(symWidths + index);
  return w;
}

unsigned int getStringWidth(String *string)
{
  int L = 0;
  int NC = string->length();
  for (int i=0;i<NC;i++)
  {
    int Q = string->charAt(i);
    int N = getCharWidth(Q);
    L += N;
  }
  return L;
}

unsigned int getCharColumn(unsigned char ascii, unsigned int x)
{
  int index = ascii - 0x20;
  unsigned int ofs = (unsigned int) pgm_read_word_near(symOffsets + index) + x;
  unsigned int pat = (unsigned int) pgm_read_word_near(symPatterns + ofs);
  //return pat;
  return pat;
}


