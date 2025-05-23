//+------------------------------------------------------------------+
//| EPT_EnvConfig.mqh                                                |
//| EdgeProTrader - 環境設定用定義ファイル                          |
//+------------------------------------------------------------------+
#ifndef __EPT_ENV_CONFIG__
#define __EPT_ENV_CONFIG__

//==============================
// デバッグモード制御
//==============================
// true：DebugPrint 有効
// false：DebugPrint 無効（本番リリース用）
#define DEBUG_MODE true

// ────────────────
// 🔧 ログカテゴリ × レベル（12分類）
// ────────────────
#define LOG_VIEW_DEBUG(msg)     if(DEBUG_MODE) Print("[VIEW][DEBUG] ", msg)
#define LOG_VIEW_INFO(msg)      if(DEBUG_MODE) Print("[VIEW][INFO] ", msg)
#define LOG_VIEW_ERROR(msg)     if(DEBUG_MODE) Print("[VIEW][ERROR] ", msg)

#define LOG_LOGIC_DEBUG(msg)    if(DEBUG_MODE) Print("[LOGIC][DEBUG] ", msg)
#define LOG_LOGIC_INFO(msg)     if(DEBUG_MODE) Print("[LOGIC][INFO] ", msg)
#define LOG_LOGIC_ERROR(msg)    if(DEBUG_MODE) Print("[LOGIC][ERROR] ", msg)

#define LOG_ACTION_DEBUG(msg)   if(DEBUG_MODE) Print("[ACTION][DEBUG] ", msg)
#define LOG_ACTION_INFO(msg)    if(DEBUG_MODE) Print("[ACTION][INFO] ", msg)
#define LOG_ACTION_ERROR(msg)   if(DEBUG_MODE) Print("[ACTION][ERROR] ", msg)

#define LOG_TEST_DEBUG(msg)     if(DEBUG_MODE) Print("[TEST][DEBUG] ", msg)
#define LOG_TEST_INFO(msg)      if(DEBUG_MODE) Print("[TEST][INFO] ", msg)
#define LOG_TEST_ERROR(msg)     if(DEBUG_MODE) Print("[TEST][ERROR] ", msg)


#endif
