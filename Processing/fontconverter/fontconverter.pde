class Qsym
{
  int px;
  int ofs;
  int w;
  Qsym(int px,int ofs,int w)
  {
    this.px = px;
    this.ofs = ofs;
    this.w = w;
    print(".");
//    print("Px: " + px + " W: " + w + "\n");
  }
}

class Qfont
{
  int tCols;
  int numSymbols;
  Qsym[] symbols;
  PImage img;
  Qfont(PImage img)
  {
    this.img = img;
    this.process();
  }

  int scan(boolean commit)
  {
    int x = 0;
    int x0 = 0;
    int ns = 0;
    int w = 0;
    int a = 0;
    int ofs = 0;
    while(x<img.width)
    {
      if (a == 0)
      {
        // looking for symbol start
        for (int y=0;y<img.height;y++)
        {
          color Z = img.get(x,y);
          if (red(Z) > 128)
          {
            a=1;
            w=1;
            x0=x;
          }
        }
      }
      else
      {
        // looking for symbol finish
        a=0;
        for (int y=0;y<img.height;y++)
        {
          color Z = img.get(x,y);
          if (red(Z) > 128)
          {
            a=1;
          }
        }
        if (a == 0) 
        {
          if (commit)
          {
            symbols[ns] = new Qsym(x0,ofs,w);
            ofs+=w;
            this.tCols = ofs;
          }
          ns++;
        }
        else
        {
          w++;
        }
      }
      x++;
    }
    return ns;
  }
    
  void process()
  {
    int n = scan(false);
    this.numSymbols = n;
    print("Number of symbols found:" + n + "\n");
    symbols = new Qsym[n];
    print("Scanning..." + "\n");
    scan(true); // commit 
    print("done." + "\n");
  }
  
  void dump()
  {
    print("\n");
    print("PROGMEM prog_uint16_t symOffsets[] = {" + "\n");
    for (int i=0;i<this.numSymbols;i++)
    {
      print (this.symbols[i].ofs);
      if (i < this.numSymbols-1) print (", ");
      if (i % 16 == 15)
      {
        print("\n");
      }  
    }
    print("\n" + "};" + "\n");

    print("\n");
    print("PROGMEM prog_uint8_t symWidths[] = {" + "\n");
    for (int i=0;i<this.numSymbols;i++)
    {
      print ("0x"+hex(this.symbols[i].w,2));
      if (i < this.numSymbols-1) print (", ");
      if (i % 10 == 9)
      {
        print("\n");
      }  
    }
    print("\n" + "};" + "\n");

    print("\n");
    print("PROGMEM prog_uint16_t symPatterns[] = {" + "\n");
    
    int i = 0;
    for (int c=0;c<this.numSymbols;c++)
    {
      int px = this.symbols[c].px;
      for (int x=px;x<(px+this.symbols[c].w);x++)
      {
        if (x == px) 
        {
          println();
        }
        int pat = 0;
        for (int y=0;y<16;y++)
        {
          color q = img.get(x,15-y);
          if (green(q) > 128) pat += 1<<y;
        }
        print("0x" + hex(pat,4));
        if (i < tCols-1)
        {
          print(", ");
        }
        else
        {
          print("  ");
        }
        print(" // 0x");
        print( hex(i,4));
        print(" : ");
        print (binary(pat,16));
        if (x == px)
        {
          print(" #" + c + " (0x" + hex(32+c,2) + ")" );
        }
        println();
        i++;
      } 
    }
    print("\n" + "};" + "\n");
    
  }
 
}

Qfont QQ;

void setup()
{
  size(200,200);
  PImage f = loadImage("font.png");
  QQ = new Qfont(f);
  QQ.dump();
}

void loop()
{
}
