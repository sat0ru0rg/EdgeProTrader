//+------------------------------------------------------------------+
//| RiskHelper.mqh                                                   |
//| ロジック：リスク補助計算ユーティリティ                          |
//| ・SL距離（pips）の計算                                          |
//| ・ロット／pips距離からリスク金額を算出                          |
//| ・口座残高とリスク％からリスク許容額を取得                      |
//| ※ PipValuePerLot() は CPriceConverter に統合済                |
//+------------------------------------------------------------------+
#ifndef __RISKHELPER_MQH__
#define __RISKHELPER_MQH__

#include <00_Common/CommonDefs.mqh>
#include <09_Calculator/CPriceConverter.mqh>  // PipValuePerLot使用

#define __CLASS__ "RiskHelper"

//+------------------------------------------------------------------+
//| SL距離pipsを算出                                                 |
//+------------------------------------------------------------------+
/**
 * @brief エントリー価格とSL価格からpips距離を算出する
 * @param isBuy BUYならtrue / SELLならfalse
 * @param entryPrice エントリー価格
 * @param slPrice SL価格
 * @param symbol 通貨ペア（省略可）
 * @return SL距離（pips）
 */
double CalcSLPips(bool isBuy, double entryPrice, double slPrice, string symbol = NULL)
{
    LOG_LOGIC_DEBUG_C("START: CalcSLPips");

    if (symbol == NULL || symbol == "")
        symbol = Symbol();

    double point    = MarketInfo(symbol, MODE_POINT);
    int digits      = MarketInfo(symbol, MODE_DIGITS);
    double pipSize  = (digits == 5 || digits == 3) ? 10.0 : 1.0;

    double diff = MathAbs(entryPrice - slPrice);
    double slPips = diff / point / pipSize;

    LOG_LOGIC_INFO_C(StringFormat("SL距離計算: entry=%.5f / SL=%.5f / pips=%.1f", entryPrice, slPrice, slPips));
    return slPips;
}

//+------------------------------------------------------------------+
//| リスク金額（pips×lot×価値）を算出                                |
//+------------------------------------------------------------------+
/**
 * @brief 指定ロット・pips距離から損失金額を算出する
 * @param slPips SL距離（pips）
 * @param lot ロット数
 * @param symbol 通貨ペア（省略可）
 * @return リスク金額（円建て）
 */
double CalcRiskAmount(double slPips, double lot, string symbol = NULL)
{
    LOG_LOGIC_DEBUG_C("START: CalcRiskAmount");

    if (symbol == NULL || symbol == "")
        symbol = Symbol();

    double pipValue = PipValuePerLot(symbol);
    double risk = slPips * pipValue * lot;

    LOG_LOGIC_INFO_C(StringFormat("リスク金額計算: slPips=%.1f / lot=%.2f / pipValue=%.2f → risk=%.2f", slPips, lot, pipValue, risk));
    return risk;
}

//+------------------------------------------------------------------+
//| リスク許容額（残高 × リスク％）                                  |
//+------------------------------------------------------------------+
/**
 * @brief 口座残高に対するリスク許容金額（%）を取得
 * @param riskPercent 許容リスク％（例：2.0）
 * @return リスク許容金額（円）
 */
double GetRiskMoney(double riskPercent)
{
    LOG_LOGIC_DEBUG_C("START: GetRiskMoney");

    double balance = GetAccountBalance();
    double money = balance * riskPercent / 100.0;

    LOG_LOGIC_INFO_C(StringFormat("リスク許容額: balance=%.0f × %.2f%% → %.2f円", balance, riskPercent, money));
    return money;
}

#endif // __RISKHELPER_MQH__
