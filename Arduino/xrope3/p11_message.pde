struct Tmessage
{
  unsigned char bgCmd;
  unsigned char fgCmd;
  int length;
  String *message;
};

int numMessages = 4;

int getNumMessages()
{
  return numMessages;
}

Tmessage RopeMessages[4];

String message0 = char(0x8F);
String message1 = " ILLUTRON.DK + ";
String message2 = " Hello, world ";
// String message3 = "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF";
String message3 = char(0x8E) ;
void initRopeMessages()
{
  Tmessage *msg;

  msg = &RopeMessages[0];
  msg->bgCmd = getRopeCommand(0,0,0);
  msg->fgCmd = getRopeCommand(1,1,0);
  msg->message = &message0;
  msg->length = msg->message->length();
  
  msg = &RopeMessages[1];
  msg->bgCmd = getRopeCommand(0,0,0);
  msg->fgCmd = getRopeCommand(1,0,0);
  msg->message = &message1;
  msg->length = msg->message->length();
  
  msg = &RopeMessages[2];
  msg->bgCmd = getRopeCommand(0,0,0);
  msg->fgCmd = getRopeCommand(0,1,0);
  msg->message = &message2;
  msg->length = msg->message->length();
  
  msg = &RopeMessages[3];
  msg->bgCmd = getRopeCommand(1,0,1);
  msg->fgCmd = getRopeCommand(0,0,0);
  msg->message = &message3;
  msg->length = msg->message->length();
  
}
