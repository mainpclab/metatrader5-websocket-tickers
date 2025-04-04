//+------------------------------------------------------------------+
//|                                                TickerMonitor.mqh |
//|                                    Copyright 2025, Solid Signals |
//|                                         https://solidsignals.xyz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Solid Signals"
#property link      "https://solidsignals.xyz"
#property version   "1.00"
#property strict

#include "WebSocketService.mqh"
#include "Include/JAson.mqh"

//+------------------------------------------------------------------+
//| Class to monitor market symbols and publish price changes         |
//+------------------------------------------------------------------+
class TickerMonitor
{
private:
  // WebSocket service reference
  WebSocketService* m_wsService;

  // Array of symbols to monitor
  string m_symbols[];

  // Last known prices for each symbol
  double m_lastPrices[];

  // Structure to hold changed price data
  struct PriceUpdate
  {
    string symbol;
    double price;
    int digits;
  };

public:
  //+------------------------------------------------------------------+
  //| Constructor                                                      |
  //+------------------------------------------------------------------+
  TickerMonitor(WebSocketService* wsService, const string &symbols[])
  {
    m_wsService = wsService;

    // Copy symbols to monitor
    int symbolCount = ArraySize(symbols);
    ArrayResize(m_symbols, symbolCount);
    ArrayResize(m_lastPrices, symbolCount);

    for(int i = 0; i < symbolCount; i++)
    {
      m_symbols[i] = symbols[i];
      m_lastPrices[i] = 0.0; // Initialize with zero
    }

    // Initial price capture
    UpdateLastPrices();
  }

  //+------------------------------------------------------------------+
  //| Update all price data                                            |
  //+------------------------------------------------------------------+
  void CheckPriceUpdates()
  {
    // Array to collect changed prices
    PriceUpdate changes[];
    int changeCount = 0;

    // Check each symbol for price changes
    for(int i = 0; i < ArraySize(m_symbols); i++)
    {
      // Get current price
      double currentPrice = SymbolInfoDouble(m_symbols[i], SYMBOL_BID);

      // If price has changed, add to changes array
      if(currentPrice != m_lastPrices[i] && currentPrice > 0.0)
      {
        // Resize the changes array
        ArrayResize(changes, changeCount + 1);

        // Store the change
        changes[changeCount].symbol = m_symbols[i];
        changes[changeCount].price = currentPrice;
        changes[changeCount].digits = (int)SymbolInfoInteger(m_symbols[i], SYMBOL_DIGITS);

        // Update the last price
        m_lastPrices[i] = currentPrice;

        // Increment the counter
        changeCount++;
      }
    }

    // If we have changes, publish them
    if(changeCount > 0)
    {
      PublishPriceUpdates(changes);
    }
  }

private:
  //+------------------------------------------------------------------+
  //| Initialize last prices for all symbols                           |
  //+------------------------------------------------------------------+
  void UpdateLastPrices()
  {
    for(int i = 0; i < ArraySize(m_symbols); i++)
    {
      m_lastPrices[i] = SymbolInfoDouble(m_symbols[i], SYMBOL_BID);
    }
  }

  //+------------------------------------------------------------------+
  //| Publish price updates as a JSON array using JAson lib            |
  //+------------------------------------------------------------------+
  void PublishPriceUpdates(const PriceUpdate &changes[])
  {
    // Create a JSON array
    CJAVal jsonArray(jtARRAY, "");

    for(int i = 0; i < ArraySize(changes); i++)
    {
      // Create new JSON object for each update
      CJAVal updateObj(jtOBJ, "");

      // Set properties
      updateObj["symbol"] = changes[i].symbol;
      updateObj["last"] = DoubleToString(changes[i].price, changes[i].digits);

      // Add to array
      jsonArray.Add(updateObj);
    }

    // Serialize to string
    string msg = jsonArray.Serialize();

    // Send the updates through WebSocket service
    if(m_wsService != NULL)
    {
      m_wsService.SendMessage(msg);
    }
  }
};
//+------------------------------------------------------------------+