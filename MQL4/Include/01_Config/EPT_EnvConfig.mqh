#ifndef __EPT_ENV_CONFIG__
#define __EPT_ENV_CONFIG__

//==============================
// デバッグ動作制御（テスト中や環境切り替え用）
//==============================
#define DEBUG_MODE true  // モック動作や条件分岐のトリガーなどに使用

//==============================
// ログ出力制御（DEBUGログの有効化）
//==============================
#define DEBUG_LOG_ENABLED false  // ← DEBUGログだけ出力するかどうか

//==============================
// ログカテゴリ × レベル（12分類）
//==============================
// ※ 以下のログ出力マクロは非推奨です（今後廃止予定）
#define LOG_VIEW_DEBUG(msg)     if(DEBUG_LOG_ENABLED) Print("[VIEW][DEBUG] ", msg)
#define LOG_VIEW_INFO(msg)      Print("[VIEW][INFO] ", msg)
#define LOG_VIEW_ERROR(msg)     Print("[VIEW][ERROR] ", msg)

#define LOG_LOGIC_DEBUG(msg)    if(DEBUG_LOG_ENABLED) Print("[LOGIC][DEBUG] ", msg)
#define LOG_LOGIC_INFO(msg)     Print("[LOGIC][INFO] ", msg)
#define LOG_LOGIC_ERROR(msg)    Print("[LOGIC][ERROR] ", msg)

#define LOG_ACTION_DEBUG(msg)   if(DEBUG_LOG_ENABLED) Print("[ACTION][DEBUG] ", msg)
#define LOG_ACTION_INFO(msg)    Print("[ACTION][INFO] ", msg)
#define LOG_ACTION_ERROR(msg)   Print("[ACTION][ERROR] ", msg)

#define LOG_TEST_DEBUG(msg)     if(DEBUG_LOG_ENABLED) Print("[TEST][DEBUG] ", msg)
#define LOG_TEST_INFO(msg)      Print("[TEST][INFO] ", msg)
#define LOG_TEST_ERROR(msg)     Print("[TEST][ERROR] ", msg)

//==============================
// 拡張ログマクロ（推奨）: 関数名＋クラス名付きバージョン
// __FUNCTION__ベースの簡易ログマクロ定義
//==============================

// VIEWカテゴリ
#define LOG_VIEW_DEBUG_C(msg)  if(DEBUG_LOG_ENABLED) Print("[VIEW][DEBUG] ", __FUNCTION__, " ", msg)
#define LOG_VIEW_INFO_C(msg)   Print("[VIEW][INFO] ", __FUNCTION__, " ", msg)
#define LOG_VIEW_ERROR_C(msg)  Print("[VIEW][ERROR] ", __FUNCTION__, " ", msg)

// LOGICカテゴリ
#define LOG_LOGIC_DEBUG_C(msg) if(DEBUG_LOG_ENABLED) Print("[LOGIC][DEBUG] ", __FUNCTION__, " ", msg)
#define LOG_LOGIC_INFO_C(msg)  Print("[LOGIC][INFO] ", __FUNCTION__, " ", msg)
#define LOG_LOGIC_ERROR_C(msg) Print("[LOGIC][ERROR] ", __FUNCTION__, " ", msg)

// ACTIONカテゴリ
#define LOG_ACTION_DEBUG_C(msg) if(DEBUG_LOG_ENABLED) Print("[ACTION][DEBUG] ", __FUNCTION__, " ", msg)
#define LOG_ACTION_INFO_C(msg)  Print("[ACTION][INFO] ", __FUNCTION__, " ", msg)
#define LOG_ACTION_ERROR_C(msg) Print("[ACTION][ERROR] ", __FUNCTION__, " ", msg)

// TESTカテゴリ
#define LOG_TEST_DEBUG_C(msg)  if(DEBUG_LOG_ENABLED) Print("[TEST][DEBUG] ", __FUNCTION__, " ", msg)
#define LOG_TEST_INFO_C(msg)   Print("[TEST][INFO] ", __FUNCTION__, " ", msg)
#define LOG_TEST_ERROR_C(msg)  Print("[TEST][ERROR] ", __FUNCTION__, " ", msg)

// --- Assertマクロ定義（LOG出力規約準拠）
#define ASSERT_TRUE(cond, msg)   if (cond) LOG_TEST_INFO_C(msg + " → PASSED"); else LOG_TEST_ERROR_C(msg + " → FAILED")
#define ASSERT_FALSE(cond, msg)  if (!(cond)) LOG_TEST_INFO_C(msg + " → PASSED"); else LOG_TEST_ERROR_C(msg + " → FAILED")

#endif
