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

// ────────────────
// ログカテゴリ × レベル（12分類）
// ────────────────
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

#endif
