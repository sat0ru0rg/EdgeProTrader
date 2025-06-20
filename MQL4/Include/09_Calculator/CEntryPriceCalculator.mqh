//+------------------------------------------------------------------+
//| CEntryPriceCalculator.mqh                                        |
//| ロジック：エントリー時の価格計算（SL/TP）                       |
//| ・pips距離を基に、発注方向に応じたSL/TP価格を計算               |
//| ・内部で CPriceConverter に依存                                 |
//+------------------------------------------------------------------+
#ifndef __CENTRYPRICECALCULATOR_MQH__
#define __CENTRYPRICECALCULATOR_MQH__

#include <00_Common/CommonDefs.mqh>
#include <09_Calculator/CPriceConverter.mqh>

#define __CLASS__ "CEntryPriceCalculator"

class CEntryPriceCalculator
{
private:
    CPriceConverter m_converter;

public:
    /**
     * @brief SL価格を計算する（エントリー方向に基づく）
     * @param symbol 通貨ペア（省略時はチャートのSymbol）
     * @param entryPrice エントリー価格
     * @param slPips SL距離（pips）
     * @param orderType OP_BUY or OP_SELL
     * @return SL価格（価格形式）
     */
    double CalculateSL(string symbol, double entryPrice, double slPips, int orderType)
    {
        LOG_LOGIC_DEBUG_C("START: CalculateSL");

        if (symbol == NULL || symbol == "")
            symbol = Symbol();

        bool isBuy = (orderType == OP_BUY);
        double offset = m_converter.PipsToPrice(slPips, symbol);
        double slPrice = isBuy ? entryPrice - offset : entryPrice + offset;

        int digits = (int)MarketInfo(symbol, MODE_DIGITS);
        double result = NormalizeDouble(slPrice, digits);

        LOG_LOGIC_INFO_C(StringFormat(
            "SL価格計算: entry=%.5f / pips=%.1f / type=%s → SL=%.5f",
            entryPrice, slPips, isBuy ? "BUY" : "SELL", result
        ));

        return result;
    }

    /**
     * @brief TP価格を計算する（エントリー方向に基づく）
     * @param symbol 通貨ペア（省略時はチャートのSymbol）
     * @param entryPrice エントリー価格
     * @param tpPips TP距離（pips）
     * @param orderType OP_BUY or OP_SELL
     * @return TP価格（価格形式）
     */
    double CalculateTP(string symbol, double entryPrice, double tpPips, int orderType)
    {
        LOG_LOGIC_DEBUG_C("START: CalculateTP");

        if (symbol == NULL || symbol == "")
            symbol = Symbol();

        bool isBuy = (orderType == OP_BUY);
        double offset = m_converter.PipsToPrice(tpPips, symbol);
        double tpPrice = isBuy ? entryPrice + offset : entryPrice - offset;

        int digits = (int)MarketInfo(symbol, MODE_DIGITS);
        double result = NormalizeDouble(tpPrice, digits);

        LOG_LOGIC_INFO_C(StringFormat(
            "TP価格計算: entry=%.5f / pips=%.1f / type=%s → TP=%.5f",
            entryPrice, tpPips, isBuy ? "BUY" : "SELL", result
        ));

        return result;
    }
};

#endif // __CENTRYPRICECALCULATOR_MQH__
