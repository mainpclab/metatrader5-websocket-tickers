//+------------------------------------------------------------------+
//|                                              TickerPublisher.mqh |
//|                                    Copyright 2025, Solid Signals |
//|                                         https://solidsignals.xyz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Solid Signals / polyclick"
#property link      "https://solidsignals.xyz"
#property version   "1.00"
#property strict

#include "WebSocketService.mqh"
#include "TickerMonitor.mqh"

// Input parameters
input string   WebSocketServer = "http://hostname.domain";  // WebSocket server address

// Hardcoded array of symbols to monitor from the Market Watch
string g_SymbolsToMonitor[] = {
  "EURUSD.pro",
  "GBPUSD.pro",
  "USDJPY.pro",
  "AUDUSD.pro",
  "USDCAD.pro",
  "NZDUSD.pro",
  "USDCHF.pro",
  "EURGBP.pro",
  "EURJPY.pro",
  "GBPJPY.pro"
};

// Global variables
WebSocketService* wsService = NULL;
TickerMonitor* tickerMonitor = NULL;

//+------------------------------------------------------------------+
//| Message handler callback function                                |
//+------------------------------------------------------------------+
void OnMessageReceived(string message)
{
  // Print("Received: ", message);
  // Process any incoming messages here
}



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  Print("Ticker Publisher EA initialized");

  // Create the WebSocket service
  wsService = new WebSocketService(WebSocketServer);

  // Set message callback
  wsService.SetMessageCallback(OnMessageReceived);

  // Connect to the server
  if(!wsService.Connect())
  {
    Print("Failed to connect to WebSocket server");
    return INIT_FAILED;
  }

  // Create the ticker monitor with hardcoded symbols
  tickerMonitor = new TickerMonitor(wsService, g_SymbolsToMonitor);

  // Initialize timer with 1ms for high-frequency operations
  EventSetMillisecondTimer(1);

  return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  // Stop the timer
  EventKillTimer();

  // Clean up ticker monitor
  if(tickerMonitor != NULL)
  {
    delete tickerMonitor;
    tickerMonitor = NULL;
  }

  // Clean up WebSocket service
  if(wsService != NULL)
  {
    delete wsService;
    wsService = NULL;
  }

  Print("Ticker Publisher EA deinitialized");
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
  // Process any incoming messages
  if(wsService != NULL)
  {
    wsService.ProcessMessages();
  }

  // Check for price updates and publish on changes
  if(tickerMonitor != NULL)
  {
    tickerMonitor.CheckPriceUpdates();
  }
}
//+------------------------------------------------------------------+