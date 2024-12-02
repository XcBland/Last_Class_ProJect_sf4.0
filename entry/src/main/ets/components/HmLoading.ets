@CustomDialog
@Component
export struct HmLoading {
  controller: CustomDialogController // 自定义弹窗控制器
  loadingText: string = 'Loading...' // 提示性文字
  @State num: number = 0;
  @State maxNumber: number = 100;
  timer: number = -1
  hWidth: number = 40

  aboutToAppear(): void {
    setInterval(() => {
      if (this.num === this.maxNumber) {
        this.num = 0
      }
      this.num += 10;

    }, 100)
  }

  build() {
    Column() {
      Progress({
        total: this.maxNumber, // 这是进度条的总数
        value: this.num, // 这是当前进度条的数值
        type: ProgressType.ScaleRing    // 这是进度条的类型: 圆环
      })
        .color($r('app.color.text_primary'))
        .width(this.hWidth)
        .height(this.hWidth)
        .margin({
          top: 10,
          bottom: 10,
          left: 10,
          right: 10
        })
      if (this.loadingText) {
        Text(this.loadingText)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
      }
    }
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('rgba(0, 0, 0, 0.5)')

  }
}