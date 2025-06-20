#ifndef __CRISKCALCULATOR__
#define __CRISKCALCULATOR__

#include <00_Common/CommonDefs.mqh>
#include <09_Calculator/RiskHelper.mqh>
#include <09_Calculator/CPriceCalculator.mqh>  // PipValuePerLot()

#define __CLASS__ "CRiskCalculator"

//+------------------------------------------------------------------+
//| CRiskCalculator                                                  |
//| ロット計算ロジック（SL距離とリスク％に基づく計算）              |
//| 固定Lotを基本とし、リスク超過時は許容Lotに自動補正             |
//+------------------------------------------------------------------+
class CRiskCalculator
{
private:
    double fixedLot;       ///< 指定ロット（基本ロット）
    double riskPercent;    ///< リスク許容率（%）

public:
    //--- コンストラクタ
    CRiskCalculator(double _fixedLot = 0.1, double _riskPercent = 2.0)
    {
        fixedLot = _fixedLot;
        riskPercent = _riskPercent;
    }

    /// @brief SL距離（pips）からロットを自動算出
    /// @param slPips 損切り距離（pips）
    /// @return 補正後ロット数
    double Calculate(double slPips)
    {
        double pipValue         = PipValuePerLot();                        // 1ロットあたりのpips価値
        double maxRiskMoney     = GetRiskMoney(riskPercent);              // リスク許容額（円）
        double slValueFixedLot  = slPips * pipValue * fixedLot;           // 指定ロットでの損失額

        double minLot  = GetMinLot();
        double lotStep = GetLotStep();
        double maxLot  = GetMaxLot();

        double riskLot = maxRiskMoney / (slPips * pipValue);              // リスク許容内ロット
        riskLot = MathFloor(riskLot / lotStep) * lotStep;
        riskLot = MathMax(minLot, MathMin(riskLot, maxLot));

        double usedLot = (slValueFixedLot <= maxRiskMoney) ? fixedLot : riskLot;

        //--- ログ出力（最新形式）
        string logMsg = StringFormat(
            "[ロット計算] FixedLot=%.2f | RiskLimitLot=%.2f | UsedLot=%.2f",
            fixedLot, riskLot, usedLot
        );

        if (slValueFixedLot > maxRiskMoney)
            LOG_ACTION_INFO_C("⚠️ 固定Lotではリスク超過 → 補正適用: " + logMsg);
        else
            LOG_ACTION_INFO_C("✔️ 固定Lotでリスク許容内: " + logMsg);

        return NormalizeDouble(usedLot, 2);
    }

    /// @brief エントリー価格とSL価格からSL距離を算出し、ロットを補正計算
    double CalcAdjustedLotByPrice(bool isBuy, double entryPrice, double slPrice)
    {
        double slPips = CalcSLPips(isBuy, entryPrice, slPrice);
        return Calculate(slPips);
    }

    //--- Setter
    void SetFixedLot(double lot)       { fixedLot = lot; }
    void SetRiskPercent(double risk)   { riskPercent = risk; }

    //--- Getter
    double GetFixedLot()     { return fixedLot; }
    double GetRiskPercent()  { return riskPercent; }
};

#endif // __CRISKCALCULATOR__
