import { TaskInfoItem, TaskInfoItemModel } from "../../../models/task"

@Preview
@Component
export struct TaskItemCard {
  taskItemData: TaskInfoItemModel = new TaskInfoItemModel({} as TaskInfoItem)

  // 判断是否能够提货
  getBtnEnable() {
    if (this.taskItemData.enablePickUp) {
      return true
    }
    return false
  }

  build() {
    Column() {
      Row() {
        Text(`任务编号: ${this.taskItemData.transportTaskId}`)
          .fontWeight(FontWeight.Bold)
          .lineHeight(22)
          .fontColor($r('app.color.text_primary'))
      }
      .width("100%")
      .height(40)
      .padding({
        left: 15,
        right: 15,
        top: 10,
        bottom: 10
      })

      Row() {
        Text("起")
          .width(22)
          .height(22)
          .fontColor($r('app.color.white'))
          .borderRadius(11)
          .backgroundColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
        Text(`${this.taskItemData.startAddress}`)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .margin({ left: 10 })
      }

      .padding({
        left: 15,
        right: 15,
        top: 10,
        bottom: 10
      })
      .width("100%")
      .width("100%")

      Row() {
        Text("止")
          .width(22)
          .height(22)
          .fontColor($r('app.color.white'))
          .borderRadius(11)
          .backgroundColor($r('app.color.primary'))
          .textAlign(TextAlign.Center)
        Text(`${this.taskItemData.endAddress}`)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .margin({ left: 10 })
      }

      .padding({
        left: 15,
        right: 15,
        top: 10,
        bottom: 10
      })
      .width("100%")
      .width("100%")

      Divider()
        .height(1)
        .color($r('app.color.background_divider'))
        .margin({
          top: 20,
          bottom: 4,
          right: 8,
          left: 8
        })

      Row() {
        Column() {
          Text("提货时间")
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text(`${this.taskItemData.planDepartureTime}`)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 5 })

        }
        .alignItems(HorizontalAlign.Start)
        .padding({
          left: 15,
          right: 15,
          top: 10,
          bottom: 10
        })

        Button("提交")
          .fontSize(14)
          .width(60)
          .height(30)
          .borderRadius(10)
          .fontColor($r('app.color.white'))
          .backgroundColor(this.getBtnEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .enabled(this.getBtnEnable())

      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)

    }
    .backgroundColor($r('app.color.white'))
    .borderRadius(10)
    .padding({
      left: 15,
      right: 15,
      top: 10,
      bottom: 10
    })
    .margin({
      top: 10,
      left: 15,
      right: 15
    })
  }
}