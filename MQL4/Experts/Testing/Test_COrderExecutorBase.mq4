#include <Common/CommonDefs.mqh>
#include <Trade/COrderExecutorBase.mqh>

COrderExecutorBase base;

int OnInit() {
    base.SetSymbol("USDJPY");
    base.SetVolume(0.1);
    base.SetEntryPrice(150.123);
    base.SetStopLoss(149.900);
    base.SetTakeProfit(150.500);
    base.SetSlippage(3);
    base.SetMagic(12345);
    base.SetComment("TEST");
    base.SetExpiration(TimeCurrent() + 3600);

    DebugPrint("Symbol = " + base.GetSymbol());
    DebugPrint("Volume = " + DoubleToString(base.GetVolume(), 2));
    DebugPrint("EntryPrice = " + DoubleToString(base.GetEntryPrice(), 3));
    DebugPrint("StopLoss = " + DoubleToString(base.GetStopLoss(), 3));
    DebugPrint("TakeProfit = " + DoubleToString(base.GetTakeProfit(), 3));
    DebugPrint("Slippage = " + IntegerToString(base.GetSlippage()));
    DebugPrint("Magic = " + IntegerToString(base.GetMagic()));
    DebugPrint("Comment = " + base.GetComment());
    DebugPrint("Expiration = " + TimeToString(base.GetExpiration(), TIME_DATE|TIME_MINUTES));

    return(INIT_SUCCEEDED);
}
