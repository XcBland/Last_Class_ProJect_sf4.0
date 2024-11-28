@Component
export struct HmLoading {
  @State num: number = 0;
  @State maxNumber: number = 100;
  timer: number = -1
  hWidth:number = 40
  aboutToAppear(): void {
    setInterval(() => {
      if (this.num === this.maxNumber) {
        this.num = 0
      }
      this.num += 10;

    }, 100)
  }

  build() {
    Progress({
      total: this.maxNumber, // 这是进度条的总数
      value: this.num, // 这是当前进度条的数值
      type: ProgressType.ScaleRing    // 这是进度条的类型: 圆环
    })
      .color($r('app.color.text_primary'))
      .width(this.hWidth)
      .height(this.hWidth)
      .margin({ top: 10, bottom: 10, left: 10, right: 10 })
  }
}