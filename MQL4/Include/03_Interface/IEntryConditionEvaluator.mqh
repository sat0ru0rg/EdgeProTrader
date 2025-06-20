//+------------------------------------------------------------------+
//| IEntryConditionEvaluator                                         |
//| エントリー可否を事前検証するインターフェース                    |
//+------------------------------------------------------------------+
class IEntryConditionEvaluator
{
public:
    virtual bool IsSpreadAcceptable(double spread) = 0;
    virtual bool IsTradableTime(datetime now) = 0;
};
