//+------------------------------------------------------------------+
//| CPriceConverter.mqh                                              |
//| 共通ユーティリティ：価格↔pips換算、Pip価値関連                  |
//| ・PipsToPrice / PriceToPips                                      |
//| ・PipValuePerLot / PipValuePerLotJPY                             |
//| ※ MQL4/5 両対応、すべての変換処理を統一                         |
//+------------------------------------------------------------------+
#ifndef __CPRICECONVERTER_MQH__
#define __CPRICECONVERTER_MQH__

#include <00_Common/CommonDefs.mqh>

#define __CLASS__ "CPriceConverter"

class CPriceConverter
{
public:

    /**
     * @brief pips → price 変換
     */
    double PipsToPrice(double pips, string symbol = NULL)
    {
        LOG_LOGIC_DEBUG_C("START: PipsToPrice");

        if (symbol == NULL || symbol == "")
            symbol = Symbol();

        double point   = MarketInfo(symbol, MODE_POINT);
        int digits     = (int)MarketInfo(symbol, MODE_DIGITS);
        double pipSize = (digits == 3 || digits == 5) ? 10.0 : 1.0;

        double result = pips * point * pipSize;
        LOG_LOGIC_INFO_C(StringFormat("PipsToPrice: pips=%.1f → price=%.5f", pips, result));
        return result;
    }

    /**
     * @brief price差 → pips換算
     */
    double PriceToPips(double price1, double price2, string symbol = NULL)
    {
        LOG_LOGIC_DEBUG_C("START: PriceToPips");

        if (symbol == NULL || symbol == "")
            symbol = Symbol();

        double point   = MarketInfo(symbol, MODE_POINT);
        int digits     = (int)MarketInfo(symbol, MODE_DIGITS);
        double pipSize = (digits == 3 || digits == 5) ? 10.0 : 1.0;

        double diff = MathAbs(price1 - price2);
        double result = diff / point / pipSize;
        LOG_LOGIC_INFO_C(StringFormat("PriceToPips: %.5f ⇔ %.5f → %.1f pips", price1, price2, result));
        return result;
    }

    /**
     * @brief 1ロットあたりの1pipsの価値（円建て）
     */
    double PipValuePerLot(string symbol = NULL)
    {
        LOG_LOGIC_DEBUG_C("START: PipValuePerLot");

        if (symbol == NULL || symbol == "")
            symbol = Symbol();

        double tickValue = MarketInfo(symbol, MODE_TICKVALUE);
        double tickSize  = MarketInfo(symbol, MODE_TICKSIZE);
        double point     = MarketInfo(symbol, MODE_POINT);
        int digits       = (int)MarketInfo(symbol, MODE_DIGITS);

        double pipFactor = (digits == 3 || digits == 5) ? 10.0 : 1.0;
        double pipValue  = (tickValue / tickSize) * point * pipFactor;

        LOG_LOGIC_INFO_C(StringFormat("PipValuePerLot: %.2f", pipValue));
        return pipValue;
    }

    /**
     * @brief PipValuePerLotをJPY換算して返す
     */
    double PipValuePerLotJPY(string symbol = NULL)
    {
        LOG_LOGIC_DEBUG_C("START: PipValuePerLotJPY");

        if (symbol == NULL || symbol == "")
            symbol = Symbol();

        double pipValue = PipValuePerLot(symbol);
        string quoteCurrency = StringSubstr(symbol, 3, 3);

        if (quoteCurrency != "JPY")
        {
            string convSymbol = quoteCurrency + "JPY";
            double convRate   = MarketInfo(convSymbol, MODE_ASK);

            if (convRate <= 0.0)
            {
                LOG_LOGIC_ERROR_C(StringFormat("[PipValuePerLotJPY] 換算失敗: %s → fallback=150.0", convSymbol));
                convRate = 150.0;
            }

            pipValue *= convRate;
        }

        LOG_LOGIC_INFO_C(StringFormat("PipValuePerLotJPY: %.2f", pipValue));
        return pipValue;
    }
};

#endif // __CPRICECONVERTER_MQH__
