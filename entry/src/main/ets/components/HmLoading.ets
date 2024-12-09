@CustomDialog
@Component
export struct HmLoading {
  controller: CustomDialogController // 自定义弹窗控制器
  loadingText: string = 'Loading...' // 提示性文字
  @State num: number = 0;
  @State maxNumber: number = 100;
  timer: number = -1
  hWidth: number = 40 // 进度条的宽度

  aboutToAppear(): void {
    this.timer = setInterval(() => {
      if (this.num === this.maxNumber) {
        this.num = 0
      }
      this.num++
    }, 10)
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Column({ space: 10 }) {
      Progress({
        total: this.maxNumber, // 这是进度条的总数
        value: this.num, // 这是当前进度条的数值
        type: ProgressType.ScaleRing    // 这是进度条的类型: 圆环
      })
        .color($r('app.color.text_primary'))
        .width(this.hWidth)
        .style({ strokeWidth: 2 })
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
    .alignItems(HorizontalAlign.Center)

  }
}