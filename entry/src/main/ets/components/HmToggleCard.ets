@Component
export struct HmToggleCard {
  title: string = "详情测试标题"
  @State toggleCard: boolean = false // 控制内容的显示和隐藏
  @BuilderParam
  cardContent: () => void

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontWeight('bold')
          .fontColor($r('app.color.text_primary'))
        Image(!this.toggleCard ? $r('app.media.ic_add_img') : $r('app.media.ic_btn_cut'))
          .width(24)
          .height(24)
          .margin({ right: 10 })
          .aspectRatio(1)
          .onClick(() => {
            animateTo({ duration: 200 }, () => {
              this.toggleCard = !this.toggleCard
            })
          })
      }
      .width('100%')
      .height(48)
      .padding({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.toggleCard) {
        if (this.cardContent) {
          this.cardContent()
        }
      }


    }
    .margin({ top: 15, left: 15, right: 15 })
    .padding({ left: 20, right: 20, bottom: 18 })
    .borderRadius(8)
    .backgroundColor($r('app.color.white'))
  }
}