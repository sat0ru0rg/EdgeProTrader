#ifndef __CENTRYVALIDATOR__
#define __CENTRYVALIDATOR__

#include <00_Common/CommonDefs.mqh>
#include <03_Interface/IEntryConditionEvaluator.mqh>

//+------------------------------------------------------------------+
//| CEntryValidator                                                  |
//| スプレッド／取引時間の事前検証を行う本番用クラス                 |
//+------------------------------------------------------------------+
class CEntryValidator : public IEntryConditionEvaluator
{
public:
    bool IsSpreadAcceptable(double spread)
    {
        string symbol = Symbol();
        double maxSpread = GetMaxSpread(symbol);

        LOG_LOGIC_DEBUG_C(StringFormat("Spread check: %s = %.1f / limit = %.1f", symbol, spread, maxSpread));

        if (maxSpread < 0)
        {
            LOG_LOGIC_ERROR_C("Unsupported symbol: " + symbol);
            return false;
        }

        bool result = (spread <= maxSpread);
        LOG_LOGIC_INFO_C(StringFormat("Spread acceptable: %s → %s", symbol, result ? "TRUE" : "FALSE"));
        return result;
    }

    bool IsTradableTime(datetime now)
    {
        int hour = TimeHour(now);
        bool result = (hour >= 1 && hour <= 22);

        LOG_LOGIC_DEBUG_C(StringFormat("Time check: hour = %d → %s", hour, result ? "OK" : "NG"));
        return result;
    }

private:
    double GetMaxSpread(string symbol)
    {
        if (symbol == "USDJPY")  return 20;
        if (symbol == "GBPJPY")  return 30;
        if (symbol == "XAUUSD")  return 50;
        if (symbol == "EURUSD")  return 15;
        if (symbol == "GBPUSD")  return 25;
        return -1;
    }
};

#endif // __CENTRYVALIDATOR__
