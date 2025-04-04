//+------------------------------------------------------------------+
//|                                                  PriceUtils.mqh   |
//+------------------------------------------------------------------+
class PriceUtils
{
public:
    // Format price with symbol's precision and remove trailing zeros
    static string FormatSymbolPrice(string symbol, double price);
};

//+------------------------------------------------------------------+
//| Static method implementation                                      |
//+------------------------------------------------------------------+
string PriceUtils::FormatSymbolPrice(string symbol, double price)
{
    // Get symbol digits (decimal places)
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

    // Convert to string with symbol's precision
    string priceStr = DoubleToString(price, digits);

    // Remove trailing zeros
    while(StringLen(priceStr) > 0 && StringGetCharacter(priceStr, StringLen(priceStr)-1) == '0')
        priceStr = StringSubstr(priceStr, 0, StringLen(priceStr)-1);

    // Remove decimal point if it's the last character
    if(StringLen(priceStr) > 0 && StringGetCharacter(priceStr, StringLen(priceStr)-1) == '.')
        priceStr = StringSubstr(priceStr, 0, StringLen(priceStr)-1);

    return priceStr;
}