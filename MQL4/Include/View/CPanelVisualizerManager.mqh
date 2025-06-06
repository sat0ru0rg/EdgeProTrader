#ifndef __CPANELVISUALIZERMANAGER__
#define __CPANELVISUALIZERMANAGER__

#include <Common/CommonDefs.mqh>  // ← ログ出力に必要
#include "CSLVisualizer.mqh"
#include "CTPVisualizer.mqh"
#include "CBEVisualizer.mqh"

class CPanelVisualizerManager {
private:
    CSLVisualizer sl;
    CTPVisualizer tp;
    CBEVisualizer be;

public:
    CSLVisualizer* SL() { return &sl; }
    CTPVisualizer* TP() { return &tp; }
    CBEVisualizer* BE() { return &be; }

    void HideAll() {
        LOG_VIEW_INFO("[VisualizerManager] 全ラインを非表示にします");
        sl.HideLine();
        tp.HideLine();
        be.HideLine();
    }

    void DumpStatus() {
        LOG_VIEW_DEBUG("[VisualizerManager] ▼各ラインの表示状態▼");
        sl.IsShown();
        tp.IsShown();
        be.IsShown();
        LOG_VIEW_DEBUG("[VisualizerManager] ▲Dump完了▲");
    }
};

#endif // __CPANELVISUALIZERMANAGER__
