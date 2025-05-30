//===========================
// RiskHelper.mqh
//===========================
// リスク補助計算ユーティリティ（SL距離・リスク金額算出など）
// - エントリー価格とSL価格からpips距離を計算
// - ロットとpips距離からリスク金額を計算
// - リスク許容額（口座残高 × リスク％）を取得
// - MQL5移行を考慮してSymbol関連は明示的に取得
// - PipValuePerLot は PriceCalculator.mqh に統合しました
//   リスク金額などの計算にはそちらを使用してください
#ifndef __RISKHELPER_MQH__
#define __RISKHELPER_MQH__

#include <Common/CommonDefs.mqh>
#include <Trade/CPriceCalculator.mqh>

//----------------------------------------
// pips換算（価格差 → pips）
//----------------------------------------

/*
  CalcSLPips(isBuy, entryPrice, slPrice)
  - エントリー価格とSL価格からpips距離を計算する関数
  - BUY時：SLがエントリーより下（SL = entry - pips）
  - SELL時：SLがエントリーより上（SL = entry + pips）
  - 絶対値で距離を取得
*/
double CalcSLPips(bool isBuy, double entryPrice, double slPrice, string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();

    double point    = MarketInfo(symbol, MODE_POINT);
    int digits      = MarketInfo(symbol, MODE_DIGITS);
    double pipSize  = (digits == 5 || digits == 3) ? 10.0 : 1.0;

    double diff = MathAbs(entryPrice - slPrice);
    return diff / point / pipSize;
}

//----------------------------------------
// リスク額計算（SL×lot×1pipsの価値）
//----------------------------------------

/*
  CalcRiskAmount(slPips, lot)
  - 指定ロット・SL距離に対して発生する損失額を算出
  - pipValue は 1ロットあたりの1pipsの金額（PriceCalculatorに依存）
*/
double CalcRiskAmount(double slPips, double lot, string symbol = NULL)
{
    double pipValue = PipValuePerLot(symbol);
    return slPips * pipValue * lot;
}

//----------------------------------------
// リスク許容額（口座残高 × リスク％）
//----------------------------------------

/*
  GetRiskMoney(riskPercent)
  - 現在の口座残高に対してリスク％分の金額を返す
*/
double GetRiskMoney(double riskPercent)
{
    return GetAccountBalance() * riskPercent / 100.0;
}



//----------------------------------------
// PipValuePerLot は PriceCalculator.mqh に統合しました
// リスク金額などの計算にはそちらを使用してください
//----------------------------------------

/*
  PipValuePerLot(symbol)
  - 通貨ペアの決済通貨がJPYでない場合、自動でJPYに換算
  - デフォルトは現在のチャートシンボル
*/
/*{
    if (symbol == NULL || symbol == "") symbol = Symbol();

    double pipValue = MarketInfo(symbol, MODE_TICKVALUE);

    string quoteCurrency = StringSubstr(symbol, 3, 3);  // 通貨ペアの右側通貨（決済通貨）

    if (quoteCurrency != "JPY")
    {
        string conversionSymbol = quoteCurrency + "JPY";
        double conversionRate = MarketInfo(conversionSymbol, MODE_ASK);

        if (conversionRate <= 0.0)
        {
            DebugPrint("[PipValuePerLot] 換算レート取得失敗 fallback使用: ", conversionSymbol);
            conversionRate = 150.0;
        }

        pipValue *= conversionRate;
    }

    return pipValue;
}*/

#endif
