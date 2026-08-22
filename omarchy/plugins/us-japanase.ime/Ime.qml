import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui
import qs.Commons

BarWidget {
  id: root
  moduleName: "us-japanese.ime"

  // fcitx5 input method name reported by fcitx5-remote -n:
  //   "mozc"        -> Japanese (あ)
  //   "keyboard-us" -> English (Ａ)
  property string imName: ""
  readonly property string label: imName === "mozc" ? "あ"
                                 : imName === "keyboard-us" ? "Ａ" : ""

  function refresh() {
    if (queryProc.running) return
    queryProc.running = true
  }

  Process {
    id: queryProc
    command: ["fcitx5-remote", "-n"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        root.imName = String(text || "").trim()
      }
    }
  }

  Timer {
    interval: 5000
    repeat: true
    running: true
    onTriggered: root.refresh()
  }

  Component.onCompleted: root.refresh()

  visible: label !== ""
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.label
    fontSize: Style.font.caption
    horizontalMargin: 6
    tooltipText: root.imName
  }
}
