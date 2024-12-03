@Component
export struct HmCheckBox {
  @State title: string = '标题'
  @Prop value: boolean = true
  confirmText: string = '是'
  cancelText: string = '否'
  checkChange: (value: boolean) => void = () => {
  }

  build() {
    Row() {
      Row() {
        Text(this.title)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
        Row({ space: 20 }) {
          Row() {
            Image(this.value ? $r('app.media.ic_radio_true') : $r('app.media.ic_radio_false'))
              .width(20)
              .height(20)
            Text(this.confirmText)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
          }
          .onClick(() => {
            this.value = true
            this.checkChange(this.value)
          })

          Row() {
            Image(!this.value ? $r('app.media.ic_radio_true') : $r('app.media.ic_radio_false'))
              .width(20)
              .height(20)
            Text(this.cancelText)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
          }
        }

      }
      .backgroundColor($r('app.color.white'))
      .width('100%')
      .padding({ left: 15, right: 15 })
      .height(50)
      .borderRadius(10)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding({ left: 15, right: 15 })
    .margin({ top: 15 })
  }
}