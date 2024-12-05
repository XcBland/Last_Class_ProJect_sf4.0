import { webview } from '@kit.ArkWeb'
import { promptAction } from '@kit.ArkUI'

export class WebSdkClass {
  static webController?: webview.WebviewController

  alert(message: string) {
    AlertDialog.show({ message: message })
  }

  toast(message: string) {
    promptAction.showToast({ message: message })
  }
}