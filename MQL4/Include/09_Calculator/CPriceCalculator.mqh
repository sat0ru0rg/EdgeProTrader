//===========================
// PriceCalculator.mqh
//===========================
// このモジュールはSL/TPなど価格計算やpips換算をまとめます。
// - PipToPrice()/PriceToPips()を基礎に換算を統一
// - SL/TP価格をBUY/SELLの方向に応じて自動算出
// - BE（建値）やTP分割などの追加も将来的に想定
#ifndef __PRICECALCULATOR_MQH__
#define __PRICECALCULATOR_MQH__

#include <00_Common/CommonDefs.mqh>  // PipToPrice(), PriceToPips() を使用

//----------------------------------------
// SL価格を計算する関数
//----------------------------------------

/*
  CalculateSL()
  - 指定pips距離からSL価格を算出
  - isBuy=true：エントリー価格から下にSL（entry - pips）
  - isBuy=false：エントリー価格から上にSL（entry + pips）
*/
double CalculateSL(double entryPrice, double slPips, bool isBuy, string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();
    double offset = PipsToPrice(slPips, symbol);
    double slPrice = isBuy ? entryPrice - offset : entryPrice + offset;

    #ifdef __MQL5__
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    #else
    int digits = (int)MarketInfo(symbol, MODE_DIGITS);
    #endif

    return NormalizeDouble(slPrice, digits);
}

//----------------------------------------
// TP価格を計算する関数
//----------------------------------------

/*
  CalculateTP()
  - 指定pips距離からTP価格を算出
  - isBuy=true：エントリー価格から上にTP（entry + pips）
  - isBuy=false：エントリー価格から下にTP（entry - pips）
*/
double CalculateTP(double entryPrice, double tpPips, bool isBuy, string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();
    double offset = PipsToPrice(tpPips, symbol);
    double tpPrice = isBuy ? entryPrice + offset : entryPrice - offset;

    #ifdef __MQL5__
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    #else
    int digits = (int)MarketInfo(symbol, MODE_DIGITS);
    #endif

    return NormalizeDouble(tpPrice, digits);
}

//----------------------------------------
// PipValuePerLot を取得（pips価値 × 1ロット）
//----------------------------------------

/*
  PipValuePerLot()
  - 1ロットあたりの1pipsの金額（口座通貨建て）を返す
  - MQL4: MarketInfo(symbol, MODE_TICKVALUE / TICKSIZE)
  - MQL5: SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE / SYMBOL_TRADE_TICK_SIZE)
  - 通貨桁による補正付き（3桁/5桁の場合はpips換算）
*/
double PipValuePerLot(string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();

    #ifdef __MQL5__
    double tickValue, tickSize, point;
    SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE, tickValue);
    SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE, tickSize);
    SymbolInfoDouble(symbol, SYMBOL_POINT, point);
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    #else
    double tickValue = MarketInfo(symbol, MODE_TICKVALUE);
    double tickSize  = MarketInfo(symbol, MODE_TICKSIZE);
    double point     = MarketInfo(symbol, MODE_POINT);
    int digits = (int)MarketInfo(symbol, MODE_DIGITS);
    #endif

    double pipFactor = (digits == 3 || digits == 5) ? 10.0 : 1.0;
    return (tickValue / tickSize) * point * pipFactor;
}

/*
  PipValuePerLotJPY()
  - PipValuePerLot() を元に、日本円（JPY）ベースの価値に換算して返す
  - quoteCurrency ≠ JPY の場合は JPYレートで乗算
*/
double PipValuePerLotJPY(string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();

    double pipValue = PipValuePerLot(symbol);

    string quoteCurrency = StringSubstr(symbol, 3, 3);
    if (quoteCurrency != "JPY")
    {
        string conversionSymbol = quoteCurrency + "JPY";
        double conversionRate = MarketInfo(conversionSymbol, MODE_ASK);

        if (conversionRate <= 0.0)
        {
            LOG_LOGIC_ERROR("[PipValuePerLotJPY] fallback換算: %s → 150.0", conversionSymbol);
            conversionRate = 150.0;
        }

        pipValue *= conversionRate;
    }

    return pipValue;
}

//----------------------------------------
// PriceCalculatorクラス（ラッピング版）
//----------------------------------------

class CPriceCalculator
  {
public:
   // --- SELL/BUYに応じたSL価格計算
   double CalculateSLPrice(int type, double entryPrice, double slPips, string symbol = NULL)
     {
      bool isBuy = (type == OP_BUY);
      return CalculateSL(entryPrice, slPips, isBuy, symbol);
     }

   // --- SELL/BUYに応じたTP価格計算
   double CalculateTPPrice(int type, double entryPrice, double tpPips, string symbol = NULL)
     {
      bool isBuy = (type == OP_BUY);
      return CalculateTP(entryPrice, tpPips, isBuy, symbol);
     }
  };


#endif
