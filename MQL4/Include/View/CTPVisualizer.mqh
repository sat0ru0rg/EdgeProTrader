#ifndef __CTPVISUALIZER__
#define __CTPVISUALIZER__

#include <Common/CommonDefs.mqh>  // ← ログ出力に必要

class CTPVisualizer {
private:
    bool shown;

public:
    CTPVisualizer() { shown = false; }

    bool ShowLine() {
        shown = true;
        LOG_VIEW_INFO("[TPVisualizer] TPラインを表示しました");
        return true;
    }

    void HideLine() {
        shown = false;
        LOG_VIEW_INFO("[TPVisualizer] TPラインを非表示にしました");
    }

    bool IsShown() {
        LOG_VIEW_DEBUG("[TPVisualizer] TPライン表示状態: " + (string)shown);
        return shown;
    }
};

#endif // __CTPVISUALIZER__
