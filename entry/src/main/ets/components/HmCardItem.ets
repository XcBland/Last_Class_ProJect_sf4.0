import { UserTaskInfo, UserTaskInfoModel } from "../models"

@Component
export struct HmCardItem {
  leftTitle: string = '左边标题' // 左侧标题
  @Prop
  rightContent: string = '' // 右侧内容
  showRightIcon: boolean = true // 是否显示右侧图标
  onRightClick: () => void = () => {
  } // 右侧点击事件
  showBorder: boolean = true // 是否显示底部边框

  build() {
    Row() {
      Text(this.leftTitle)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .margin({ left: 10 })
      Row() {
        if (this.rightContent) {
          Text(this.rightContent)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ right: 5 })
        }
        if (this.showRightIcon) {
          Image($r('app.media.ic_btn_more'))
            .width(24)
            .height(24)
            .margin({ right: 10 })
        }

      }
      .onClick(() => {
        this.onRightClick()
      })
    }
    .border(this.showBorder ? { width: { bottom: 1 }, color: $r('app.color.background_divider') } : {})
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(60)
  }
}