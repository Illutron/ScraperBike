Connection * connection;

volatile unsigned char androidConnected = false;

void initAndroid()
{
  ADB::init();
  connectAndroid();
}

void connectAndroid()
{
  connection = ADB::addConnection("tcp:4567", true, adbEventHandler);
  androidConnected = true;
}

void tellAndroid(unsigned int length, uint8_t * data)
{
  if (androidConnected)
  {
    connection->write(length, data);
  }
}

void adbEventHandler(Connection * connection, adb_eventType event, uint16_t length, uint8_t * data)
{
  if (event == ADB_CONNECTION_RECEIVE)
  {
    int messageType = data[0];
    switch(messageType)
    {
      case 0:
      {
        // set pattern
        randomPattern();
      }
      break;
      case 1:
      {
        // set pattern
        selectPattern(data[1]);
      }
      break;
      case 2:
      {
        // set message
        selectPattern(0); // text pattern
        selectMessage(data[1]);
        setTextColorRandomize(false);
      }
      break;
      case 3:
      {
        // set color
        selectPattern(1); // solid pattern
        setSolidColor(data[1],data[2],data[3]);
      }
      break;
      case 4:
      {
        toggleWheelRevAutoColor();        
      }
      break;
    }
  }
}

// =================================================
// ANDROID SEQUENCER
// =================================================

void androidScan()
{
  if (androidConnected)
  {
    ADB::poll();
  }
}


