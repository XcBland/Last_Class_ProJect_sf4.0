import dayjs from "@hview/dayjs"
import { MessageInfo, MessageInfoModel } from "../../../../models"

@Component
export struct TaskInfo {
  taskInfo: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
  @State isFlushed: boolean = false
  onRecord: () => void = () => {
  }
  onReadOnly: () => void = () => {
  }

  build() {
    Column() {
      Row({ space: 5 }) {
        Text(this.taskInfo.title)
          .font({ size: 20, weight: 'bold' })
        if (!this.taskInfo.isRead) {
          Circle()
            .width(10)
            .height(10)
            .stroke(Color.Red)
            .fill(Color.Red)
        }
      }

      .width('100%')

      Row() {
        Text(this.taskInfo.content)
          .fontColor($r('app.color.text_secondary'))
      }
      .margin({ top: 30 })
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Start)

      Row() {
        Text(dayjs(this.taskInfo.updated).format('YYYY-MM-DD HH:mm:ss'))
          .fontColor($r('app.color.text_secondary'))
          .font({ size: 12 })
        Button('查看详情')
          .backgroundColor($r('app.color.white'))
          .fontColor($r('app.color.primary'))
          .border({ width: 1, color: $r('app.color.primary') })
          .width(100)
          .fontSize(12)
          .height(30)
          .onClick(() => {
          })
      }
      .margin({ top: 20 })
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .onClick(() => {
      this.onReadOnly()
    })
    .padding({
      left: 15,
      right: 15,
      top: 10,
      bottom: 10
    })
    .margin({ top: 10 })
    .backgroundColor($r('app.color.white'))
    .width('100%')
    .borderRadius(10)
  }
}