#include <Test/TestEntryExecutor.mqh>

int OnInit()
{
    RunEntryExecutorTest(); // ← 単体テスト実行
    return INIT_SUCCEEDED;
}
