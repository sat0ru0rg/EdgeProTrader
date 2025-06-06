#ifndef __CSLVISUALIZER__
#define __CSLVISUALIZER__

#include <Common/CommonDefs.mqh>  // ← ログ出力に必要

class CSLVisualizer {
private:
    bool shown;

public:
    CSLVisualizer() { shown = false; }

    bool ShowLine() {
        shown = true;
        LOG_VIEW_INFO("[SLVisualizer] SLラインを表示しました");
        return true;
    }

    void HideLine() {
        shown = false;
        LOG_VIEW_INFO("[SLVisualizer] SLラインを非表示にしました");
    }

    bool IsShown() {
        LOG_VIEW_DEBUG("[SLVisualizer] SLライン表示状態: " + (string)shown);
        return shown;
    }
};

#endif // __CSLVISUALIZER__
