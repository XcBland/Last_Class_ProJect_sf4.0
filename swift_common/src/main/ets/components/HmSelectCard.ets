import { Font } from "@ohos.arkui.UIContext"

@CustomDialog
@Component
export struct HmSelectCard {
  controller: CustomDialogController
  @State title: string = '选择类型'
  @BuilderParam
  cardContent: () => void
  confirm: ()=>void = () => {}

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
        Image($r('app.media.ic_btn_close'))
          .width(13)
          .height(13)
          .backgroundColor($r('app.color.white'))
          .fillColor($r('app.color.black'))
          .onClick(() => {
            this.controller.close()
          })
      }
      .width('100%')
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)
      .border({ width: { bottom: 1 }, color: $r('app.color.background_divider') })

      // 卡片内容
      if (this.cardContent) {
        this.cardContent()
      }
      Row() {
        Button('确定')
          .width(200)
          .backgroundColor($r('app.color.primary'))
          .height(40)
          .onClick(() => {
            this.confirm()
            this.controller.close()
          })
      }
      .width('100%')
      .height(40)
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor($r('app.color.white'))
    .width('100%')
    .padding({ left: 20, right: 20 })
    .borderRadius({
      topLeft: 16, topRight: 16
    })
  }
}