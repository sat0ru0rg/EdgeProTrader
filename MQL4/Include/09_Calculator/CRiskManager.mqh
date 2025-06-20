//===========================
// RiskManager.mqh
//===========================
// - 固定ロットとリスク許容率を管理し、pips距離や価格に基づきロットを自動算出
// - MQL4/5共通ロジックで構築（発注はTradeExecutor側で）
// - SL距離に基づくリスク調整済ロットを返す
#ifndef __RISKMANAGER_MQH__
#define __RISKMANAGER_MQH__

#include <00_Common/CommonDefs.mqh>
#include <09_Calculator/RiskHelper.mqh>
#include <09_Calculator/CPriceCalculator.mqh>  // PipValuePerLot()

class CRiskManager
{
private:
    double fixedLot;       // 指定ロット（基本ロット）
    double riskPercent;    // リスク許容率（%）

public:
    // --- コンストラクタ（固定ロット＆リスク％を初期化） ---
    CRiskManager(double _fixedLot = 0.1, double _riskPercent = 2.0)
    {
        fixedLot = _fixedLot;
        riskPercent = _riskPercent;
    }

    // --- SLpips指定からロットを自動算出 ---
    double Calculate(double slPips)
    {
        double pipValue         = PipValuePerLot();                        // 1ロットあたりの1pips価値
        double maxRiskMoney     = GetRiskMoney(riskPercent);              // リスク許容額
        double slValueFixedLot  = slPips * pipValue * fixedLot;           // 指定ロットでの損失額

        double minLot  = GetMinLot();
        double lotStep = GetLotStep();
        double maxLot  = GetMaxLot();

        double riskLot = maxRiskMoney / (slPips * pipValue);              // リスク許容内のロット
        riskLot = MathFloor(riskLot / lotStep) * lotStep;                // ロット刻みに合わせて丸め
        riskLot = MathMax(minLot, MathMin(riskLot, maxLot));             // 最小〜最大範囲に制限

        double usedLot = (slValueFixedLot <= maxRiskMoney) ? fixedLot : riskLot;

        // --- ログ出力 ---
        string msg;
        if (slValueFixedLot <= maxRiskMoney)
            msg = StringFormat("[ロット計算] FixedLot: %.2f | RiskLimitLot: %.2f | UsedLot: %.2f", fixedLot, riskLot, usedLot);
        else
            msg = StringFormat("[ロット計算] FixedLot: %.2f \xE2\x9D\x8Cリスク超過 \xE2\x86\x92 RiskLimitLot: %.2f \xE2\x86\x92 UsedLot: %.2f", fixedLot, riskLot, usedLot);

        DebugPrint(msg);
        return NormalizeDouble(usedLot, 2);
    }

    // --- エントリー価格とSL価格から自動でpipsを算出してロット計算 ---
    double CalcAdjustedLotByPrice(bool isBuy, double entryPrice, double slPrice)
    {
        double slPips = CalcSLPips(isBuy, entryPrice, slPrice);
        return Calculate(slPips);
    }

    // --- 固定ロット・リスク％の変更 ---
    void SetFixedLot(double lot)       { fixedLot = lot; }
    void SetRiskPercent(double risk)   { riskPercent = risk; }

    // --- 現在の設定値を取得 ---
    double GetFixedLot()     { return fixedLot; }
    double GetRiskPercent()  { return riskPercent; }
};

#endif
