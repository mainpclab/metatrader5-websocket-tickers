//+------------------------------------------------------------------+
//|                                             WebSocketService.mqh |
//|                                    Copyright 2025, Solid Signals |
//|                                         https://solidsignals.xyz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Solid Signals / polyclick"
#property link      "https://solidsignals.xyz"
#property version   "1.00"
#property strict

#include <MQL5Book/ws/wsclient.mqh>

//+------------------------------------------------------------------+
//| Class to handle WebSocket communications                         |
//+------------------------------------------------------------------+
class WebSocketService
{
private:
  WebSocketClient<WebSocketConnectionHybi>* m_client;  // WebSocket client instance
  string m_serverUrl;                                  // Server URL
  bool m_isConnected;                                  // Connection state
  int m_timeout;                                       // Connection timeout in ms

  // Message callback function pointer type
  typedef void (*MessageCallback)(string message);

  // Callback for received messages
  MessageCallback m_onMessageReceived;

public:
  //+------------------------------------------------------------------+
  //| Constructor                                                      |
  //+------------------------------------------------------------------+
  WebSocketService(string serverUrl, int timeout = 5000)
  {
    m_serverUrl = serverUrl;
    m_timeout = timeout;
    m_isConnected = false;
    m_client = NULL;
    m_onMessageReceived = NULL;
  }

  //+------------------------------------------------------------------+
  //| Destructor                                                       |
  //+------------------------------------------------------------------+
  ~WebSocketService()
  {
    Disconnect();
  }

  //+------------------------------------------------------------------+
  //| Connect to the WebSocket server                                  |
  //+------------------------------------------------------------------+
  bool Connect()
  {
    // If already connected, return true
    if(m_isConnected && m_client != NULL && m_client.isConnected())
      return true;

    // Clean up existing client if any
    if(m_client != NULL)
    {
      m_client.close();
      delete m_client;
      m_client = NULL;
    }

    // Create a new WebSocket client
    bool useCompression = true;
    m_client = new WebSocketClient<WebSocketConnectionHybi>(m_serverUrl, useCompression);

    // Set timeout
    m_client.setTimeOut(m_timeout);

    // Try to connect
    m_isConnected = m_client.open();

    if(m_isConnected)
      Print("WebSocketService: Successfully connected to ", m_serverUrl);
    else
      Print("WebSocketService: Failed to connect to ", m_serverUrl);

    return m_isConnected;
  }

  //+------------------------------------------------------------------+
  //| Disconnect from the WebSocket server                             |
  //+------------------------------------------------------------------+
  void Disconnect()
  {
    if(m_client != NULL)
    {
      m_client.close();
      delete m_client;
      m_client = NULL;
    }

    m_isConnected = false;
    Print("WebSocketService: Disconnected from server");
  }

  //+------------------------------------------------------------------+
  //| Check if connected to the WebSocket server                       |
  //+------------------------------------------------------------------+
  bool IsConnected()
  {
    if(m_client == NULL)
      return false;

    m_isConnected = m_client.isConnected();
    return m_isConnected;
  }

  //+------------------------------------------------------------------+
  //| Send a string message to the server                                |
  //+------------------------------------------------------------------+
  bool SendMessage(string msg)
  {
    if(!EnsureConnected())
      return false;

    if(m_client.send(msg))
    {
      // Print("WebSocketService: message sent: ", msg);
      return true;
    }
    else
    {
      Print("WebSocketService: Failed to send message");
      return false;
    }
  }

  //+------------------------------------------------------------------+
  //| Set callback for message reception                               |
  //+------------------------------------------------------------------+
  void SetMessageCallback(MessageCallback callback)
  {
    m_onMessageReceived = callback;
  }

  //+------------------------------------------------------------------+
  //| Process incoming messages (should be called regularly)           |
  //+------------------------------------------------------------------+
  void ProcessMessages()
  {
    if(!IsConnected())
      return;

    // Non-blocking check for messages
    m_client.checkMessages(false);

    // Process all available messages
    IWebSocketMessage* msg = m_client.readMessage(false);
    while(msg != NULL)
    {
      string message = msg.getString();

      // Call the callback if set
      if(m_onMessageReceived != NULL)
        m_onMessageReceived(message);
      else
        Print("WebSocketService: Received message: ", message);

      // Clean up
      delete msg;

      // Check for more messages
      msg = m_client.readMessage(false);
    }
  }

private:
  //+------------------------------------------------------------------+
  //| Ensure connection is active, attempt to reconnect if not         |
  //+------------------------------------------------------------------+
  bool EnsureConnected()
  {
    if(!IsConnected())
    {
      Print("WebSocketService: Connection lost, attempting to reconnect...");
      return Connect();
    }

    return true;
  }
};
//+------------------------------------------------------------------+