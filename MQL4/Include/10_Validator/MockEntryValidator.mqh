#ifndef __MOCKENTRYVALIDATOR__
#define __MOCKENTRYVALIDATOR__

#include <00_Common/CommonDefs.mqh>
#include <03_Interface/IEntryConditionEvaluator.mqh>

//+------------------------------------------------------------------+
//| MockEntryValidator                                               |
//| 単体テスト用：任意の判定結果を返すモック実装                    |
//+------------------------------------------------------------------+
class MockEntryValidator : public IEntryConditionEvaluator
{
private:
    bool mockSpreadOK;
    bool mockTimeOK;

public:
    MockEntryValidator()
    {
        mockSpreadOK = true;
        mockTimeOK   = true;
    }

    void SetMock_IsSpreadAcceptable(bool val) { mockSpreadOK = val; }
    void SetMock_IsTradableTime(bool val)     { mockTimeOK   = val; }
    
    void SetMockResults(bool spread, bool time) {
       mockSpreadOK = spread;
       mockTimeOK = time;
    }

    bool IsSpreadAcceptable(double spread)
    {
        LOG_TEST_DEBUG_C(StringFormat("Mock Spread → return %s", mockSpreadOK ? "TRUE" : "FALSE"));
        return mockSpreadOK;
    }

    bool IsTradableTime(datetime now)
    {
        LOG_TEST_DEBUG_C(StringFormat("Mock Time → return %s", mockTimeOK ? "TRUE" : "FALSE"));
        return mockTimeOK;
    }
};

#endif // __MOCKENTRYVALIDATOR__
