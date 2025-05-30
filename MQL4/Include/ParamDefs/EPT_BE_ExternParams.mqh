//+------------------------------------------------------------------+
//| EPT_BE_ExternParams.mqh                                          |
//| EdgeProTrader - 建値移動（Break-Even）戦略用 外部変数定義       |
//+------------------------------------------------------------------+
//#pragma once

//==============================
// 建値移動戦略設定（Break-Even Settings）
//==============================
extern string _SectionBE = "【建値移動設定】-------------------------------";

// BEラインからのオフセット（単位：pips）
// 例：+5.0 → ±0円ラインより5pips有利な位置にSLを移動
extern double SL_BEOffsetPips = 5.0;

// BE移動時のスリッページ余裕幅（単位：pips）
// - サーバーのStopLevel制限や注文拒否回避のため、SLを建値より少しずらして設定
// - 通常は 0.3〜0.5pips 程度を推奨。0.0 にすると失敗する場合があります
extern double SL_BE_SlippagePips = 0.3;

//==============================
// 手数料・換算設定（Commission Settings）
//==============================
extern string _SectionCommission = "【手数料設定】-----------------------------";

// 手数料額（片道 / 1ロット単位）
// USD建てなら例：1.75（＝$3.5/lot 往復）
// JPY建てなら例：350（＝¥700/lot 往復）
extern double CommissionPerLot = 1.75;

// 手数料の通貨（例："USD", "JPY", "BTC"）
// 口座通貨と異なる場合のみ換算が行われます
extern string CommissionCurrency = "USD";

// 換算レート取得用の通貨ペア（例："USDJPY", "BTCJPY"）
// CommissionCurrency ≠ AccountCurrency の場合に使用されます
extern string AccountCurrencySymbol = "USDJPY";
