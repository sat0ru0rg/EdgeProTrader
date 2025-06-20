#ifndef __COMMON_MQH__
#define __COMMON_MQH__

#ifdef __MQL5__
#include <Trade\SymbolInfo.mqh>
#include <AccountInfo.mqh>
#endif

#include <01_Config/EPT_EnvConfig.mqh>
#include <02_ParamDefs/EPT_BE_ExternParams.mqh>

// ============================
// OrderType 定数（MQL4定義の安全補完）
// ============================
#ifndef OP_BUY
#define OP_BUY  0
#define OP_SELL 1
#endif

// ============================
// テスト用のコメント定義
// ユースケース識別コメント定義（最大8ユースケース）
// ============================
#define UC_COMMENT_UC01 "UC01"
#define UC_COMMENT_UC02 "UC02"
#define UC_COMMENT_UC03 "UC03"
#define UC_COMMENT_UC04 "UC04"
#define UC_COMMENT_UC05 "UC05"
#define UC_COMMENT_UC06 "UC06"
#define UC_COMMENT_UC07 "UC07"
#define UC_COMMENT_UC08 "UC08"


//+------------------------------------------------------------------+
//| パネル状態コード（CPanelStateManagerによる状態遷移管理に対応）      |
//| - 状態は5種（正常4 + 異常1以上）                                 |
//| - ログ／テスト／UI制御で共通に参照される                         |
//+------------------------------------------------------------------+
enum PanelStateCode
{
    // --- 正常系状態コード ---
    
    STATE_Idle = 0,  
    // SLラインが非表示状態。
    // 初期状態または全操作リセット後に遷移。UIはボタンすべて無効。

    STATE_ReadyToEntry = 1,  
    // SLライン表示済・ポジション未保有の状態。
    // エントリー準備段階。UIは発注ボタン有効、BE無効。

    STATE_PositionOpen = 2,  
    // SL表示・ポジションあり・BE条件未成立。
    // ポジ保有中だが建値到達前。BEボタンは無効。

    STATE_BEAvailable = 3,  
    // SL表示・ポジションあり・BE条件成立済。
    // BEラインに到達した状態。UI上でBEボタンが有効化される。

    // --- 異常系（Invalid）状態コード ---
    
    STATE_Invalid_DependencyNull = 100,  
    // PositionModel / EntryValidator / BECalculator のいずれかがnull。
    // テストミスまたはOnInit不備。致命的例外として扱う。

    STATE_Invalid_MissingSL = 101,  
    // ポジション保有中にも関わらずSLが表示されていない。
    // ユーザー操作ミス、またはSLラインの描画漏れ。

    STATE_Invalid_BEWithNoPosition = 102  
    // ポジション未保有なのにBE条件がtrue。
    // 状態フラグ不整合または実装バグの可能性。BE成立はポジありが前提。
};

enum EntryMode
{
    ENTRY_1 = 0,
    ENTRY_2 = 1,
    ENTRY_3 = 2,
    ALL     = 3
};

//==============================
// 損益カラー取得（チャート表示）
//==============================
color GetPipsColor(double rawPips, double netPips)
{
    if (rawPips < 0)
        return clrRed;
    else if (netPips > 0)
        return clrLimeGreen;
    else
        return clrOrange;
}

//==============================
// ロット情報取得（MQL5対応済）
//==============================
double GetMinLot(string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();
    #ifdef __MQL5__
    double value;
    SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN, value);
    return value;
    #else
    return MarketInfo(symbol, MODE_MINLOT);
    #endif
}

double GetLotStep(string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();
    #ifdef __MQL5__
    double value;
    SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP, value);
    return value;
    #else
    return MarketInfo(symbol, MODE_LOTSTEP);
    #endif
}

double GetMaxLot(string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();
    #ifdef __MQL5__
    double value;
    SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX, value);
    return value;
    #else
    return MarketInfo(symbol, MODE_MAXLOT);
    #endif
}

double GetAccountBalance()
{
    #ifdef __MQL5__
    return AccountInfoDouble(ACCOUNT_BALANCE);
    #else
    return AccountBalance();
    #endif
}

//==============================
// Pips ↔ Price 換算ユーティリティ
//==============================
double GetPipSize(string symbol)
{
    int digits;
    double point;

    #ifdef __MQL5__
        SymbolInfoInteger(symbol, SYMBOL_DIGITS, digits);
        SymbolInfoDouble(symbol, SYMBOL_POINT, point);
    #else
        digits = (int)MarketInfo(symbol, MODE_DIGITS);
        point  = MarketInfo(symbol, MODE_POINT);
    #endif

    return (digits == 3 || digits == 5) ? point * 10.0 : point;
}
/*
double PipsToPrice(double pips, string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();
    return pips * GetPipSize(symbol);
}

double PriceToPips(double priceDiff, string symbol = NULL)
{
    if (symbol == NULL || symbol == "") symbol = Symbol();
    return priceDiff / GetPipSize(symbol);
}
*/
//+------------------------------------------------------------+
//| 指定したpipsを価格差に変換するユーティリティ関数         |
//| symbol: 通貨ペア名                                         |
//| pips: ユーザー指定のpips値（例：30 = 30.0pips）           |
//+------------------------------------------------------------+
double PipToPrice(string symbol, double pips)
{
    int digits = (int)MarketInfo(symbol, MODE_DIGITS);
    int pipDivisor = (digits == 3 || digits == 5) ? 10 : 1;
    return pips * MarketInfo(symbol, MODE_POINT) * pipDivisor;
}

double PriceToPips(string symbol, double priceDiff)
{
    int digits = (int)MarketInfo(symbol, MODE_DIGITS);
    int pipDivisor = (digits == 3 || digits == 5) ? 10 : 1;
    return priceDiff / (MarketInfo(symbol, MODE_POINT) * pipDivisor);
}


//+------------------------------------------------------------------+
//| 指定ロット数に対する手数料（口座通貨建て）を取得               |
//+------------------------------------------------------------------+
double GetCommissionInAccountCurrency(double lot)
{
    LOG_LOGIC_DEBUG("[ENTER] GetCommissionInAccountCurrency(): lot = " + DoubleToString(lot, 2));

    double commission = CommissionPerLot;
    string accountCurrency = AccountCurrency();

    LOG_LOGIC_DEBUG("  CommissionPerLot = " + DoubleToString(commission, 2));
    LOG_LOGIC_DEBUG("  CommissionCurrency = " + CommissionCurrency + ", AccountCurrency = " + accountCurrency);

    if (CommissionCurrency != accountCurrency)
    {
            bool selected = SymbolSelect(AccountCurrencySymbol, true);
             LOG_LOGIC_DEBUG("SymbolSelect(" + AccountCurrencySymbol + ") = " + (selected ? "true" : "false"));
         
             double rate = MarketInfo(AccountCurrencySymbol, MODE_ASK);
             LOG_LOGIC_DEBUG("Raw MarketInfo(" + AccountCurrencySymbol + ", MODE_ASK) = " + DoubleToString(rate, 5));

        if (rate <= 0.0)
        {
            rate = 150.0;  // フォールバック
            LOG_LOGIC_ERROR("MarketInfo failed: fallback rate = 150.0 used.");
        }

        LOG_LOGIC_DEBUG("  Conversion rate = " + DoubleToString(rate, 3));

        if (StringSubstr(AccountCurrencySymbol, 0, 3) == CommissionCurrency)
        {
            commission *= rate;
            LOG_LOGIC_DEBUG("  Converted: commission *= rate → " + DoubleToString(commission, 2));
        }
        else if (StringSubstr(AccountCurrencySymbol, 3, 3) == CommissionCurrency)
        {
            commission /= rate;
            LOG_LOGIC_DEBUG("  Converted: commission /= rate → " + DoubleToString(commission, 2));
        }
        else
        {
            LOG_LOGIC_ERROR("通貨換算ペア不一致: " + AccountCurrencySymbol);
        }
    }

    double result = commission * lot;
    LOG_LOGIC_DEBUG("  Final commission = " + DoubleToString(result, 2));
    LOG_LOGIC_DEBUG("[EXIT] GetCommissionInAccountCurrency(): result = " + DoubleToString(result, 2));
    return result;
}

double TestExportFunction() {
   return 1.234;
}



#endif
