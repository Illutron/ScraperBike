Connection * connection;

volatile unsigned char androidConnected = false;

void initAndroid()
{
  ADB::init();
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

void androidScan()
{
  if (androidConnected)
  {
    ADB::poll();
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
        // set mode
      }
      break;
      case 1:
      {
        // set message
      }
      break;
      case 2:
      {
        // set background color
      }
      break;
      case 3:
      {
        // set foreground color
      }
      break;
      case 4:
      {
        // set speed
      }
      break;
    }
  }
}

