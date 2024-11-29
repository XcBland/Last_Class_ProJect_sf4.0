@Component
export struct HmUpload {
  title: string = ""

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 10, bottom: 10 })

      Row() {
        Image($r('app.media.ic_add_img'))
          .width(24)
          .height(24)
          .border({ style: BorderStyle.Dotted, width: 1, color: $r('app.color.text_secondary') })
      }
      .width(95)
      .height(95)
      // .padding({})
      .backgroundColor($r('app.color.background_page'))
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}