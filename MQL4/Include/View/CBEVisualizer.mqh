#ifndef __CBEVISUALIZER__
#define __CBEVISUALIZER__

#include <Common/CommonDefs.mqh>  // ← ログ出力に必要

class CBEVisualizer {
private:
    bool shown;

public:
    CBEVisualizer() { shown = false; }

    bool ShowLine() {
        shown = true;
        LOG_VIEW_INFO("[BEVisualizer] BEラインを表示しました");
        return true;
    }

    void HideLine() {
        shown = false;
        LOG_VIEW_INFO("[BEVisualizer] BEラインを非表示にしました");
    }

    bool IsShown() {
        LOG_VIEW_DEBUG("[BEVisualizer] BEライン表示状態: " + (string)shown);
        return shown;
    }
};

#endif // __CBEVISUALIZER__
