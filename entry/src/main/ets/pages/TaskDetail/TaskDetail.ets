/**
 * @Auhtor DLY
 *
 */
import { HMNavBar, HmToggleCard, HmUpload } from '../../components'
import { promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams } from '../../models/router'
import { TaskDetailInfo, TaskDetailInfoModel } from '../../models/task_detail'
import { getTaskDetail } from '../../api'
import { JSON } from '@kit.ArkTS'
import { call } from '@kit.TelephonyKit'

@Entry
@Component
struct TaskDetail {
  @State title: string = '任务详情'
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  scroller: Scroller = new Scroller()

  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  // 可以通过路由传值获取提货作业的id
  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.getTaskDetail(params.id)
    }
    console.log("TaskDetail aboutToAppear " + JSON.stringify(params.id))
  }

  /*基本信息*/
  @Builder
  getBaseContent() {
    Column() {
      Row() {
        Column({ space: 10 }) {
          Row({ space: 10 }) {
            Text('起')
              .fontSize(12)
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.text_primary'))
              .borderRadius(10)
              .width(20)
              .height(20)
              .textAlign(TextAlign.Center)
            Text(this.taskDetailData.startAddress)
              .TextStyleName()
          }


          Row({ space: 10 }) {
            Text('止')
              .fontSize(14)
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.primary'))
              .borderRadius(10)
              .width(20)
              .height(20)
              .textAlign(TextAlign.Center)
            Text(this.taskDetailData.endAddress)
              .TextStyleName()
          }

        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Column({ space: 10 }) {
          Image($r('app.media.ic_navigation'))
            .width(20)
            .height(20)
            .margin({ right: 10 })
          Text('开始导航')
            .textAlign(TextAlign.Center)
            .fontSize(14)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height(80)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Divider()
        .height(1)
        .color($r('app.color.background_divider'))
        .margin({ top: 10, left: 8, right: 8 })

      this.getBaseContentItem({ title: "任务编号", value: this.taskDetailData.transportTaskId })
      this.getBaseContentItem({ title: "联系人", value: this.taskDetailData.startHandoverName })
      this.getBaseContentItem({
        title: "联系电话",
        value: this.taskDetailData.startHandoverPhone,
        icon: $r('app.media.ic_phone'),
        iconClick: () => {
          promptAction.showToast({ message: "电话拨通中" })

          call.formatPhoneNumber(this.taskDetailData.startHandoverPhone)// 格式化电话号码
            .then(() => {
              call.makeCall(this.taskDetailData.startHandoverPhone) // 调用电话
            })
        }
      })
      this.getBaseContentItem({ title: "提货时间", value: this.taskDetailData.planDepartureTime + '' })
      this.getBaseContentItem({ title: "预计送到时间", value: this.taskDetailData.planArrivalTime + '' })
    }
  }

  /*基本信息底部*/
  @Builder
  getBaseContentItem(item: BaseContentItemBuilderClass) {
    Row() {
      Row() {
        Text(item.title)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(20)
      }

      Row() {
        Text(item.value)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
        if (item.icon) {
          Image(item.icon)
            .width(20)
            .height(20)
            .onClick(() => {
              item.iconClick?.() // 传入的事件，有就执行，没有就不执行
            })
        }

      }
    }
    .margin({ top: 10 })
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  /* 车辆司机信息 */
  @Builder
  getCarDriverInfo() {
    Column() {
      Row() {
        Text('车牌号')
          .TextStyleName()
        Text(this.taskDetailData.licensePlate)
          .TextStyleName()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('司机姓名')
          .TextStyleName()
        Text(this.taskDetailData.driverName)
          .TextStyleName()
      }
      .margin({ top: 15 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

    }
    .margin({ top: 15 })
  }

  /* 运输路线 */
  @Builder
  getTransportRoute() {
    Row() {
      Column({ space: 10 }) {
        Text(this.taskDetailData.startProvince)
          .fontSize(16)
          .fontWeight('bold')
          .fontColor($r('app.color.text_primary'))
        Text(this.taskDetailData.startCity)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
      }
      .width(60)

      Image($r('app.media.ic_right_arrow'))
        .width(40)
        .height(40)
        .aspectRatio(1)
        .margin({ left: 10, right: 10 })
      Column({ space: 10 }) {
        Text(this.taskDetailData.endProvince)
          .fontSize(16)
          .fontWeight('bold')
          .fontColor($r('app.color.text_primary'))
        Text(this.taskDetailData.endCity)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
      }
      .width(60)
    }
    .padding({
      top: 10,
      bottom: 10,
      left: 60,
      right: 60
    })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  /* 提货信息 */
  @Builder
  getPikUpInfo() {
    HmUpload({ title: "请拍照上传回单凭证" })
    HmUpload({ title: "请拍照上传货品照片" })
  }

  /*底部按钮*/
  @Builder
  getBottomButton() {
    Row() {
      Button("延迟提货")
        .type(ButtonType.Normal)
        
        .width(125)
        .height(40)
        .borderRadius(15)
        .backgroundColor($r('app.color.btn_gray'))
        .fontColor($r('app.color.text_primary'))
      Button("提货")
        .type(ButtonType.Normal)
        .height(40)
        .borderRadius(15)
        .layoutWeight(1)
        .fontColor($r('app.color.white'))
        .backgroundColor($r('app.color.primary_disabled'))
        .margin({ left: 20 })
    }
    .padding({
      top: 10,
      bottom: 10,
      left: 20,
      right: 20
    })
    .height(70)
    .justifyContent(FlexAlign.SpaceAround)
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .translate({ y: -70 })
    .position({ y: "100%" })

  }

  build() {
    Column() {
      HMNavBar({ title: this.title })
      Scroll(this.scroller) {
        Column() {
          HmToggleCard({ title: "基本信息" }) {
            this.getBaseContent()
          }

          HmToggleCard({ title: "车辆司机信息" }) {
            this.getCarDriverInfo()
          }

          HmToggleCard({ title: "运输路线" }) {
            this.getTransportRoute()
          }

          HmToggleCard({ title: "提货信息" }) {
            this.getPikUpInfo()
          }

        }
      }
      .padding({ bottom: 120 })

      this.getBottomButton()

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))

  }
}

// 获取后端接口数据的标准流程
/*
 * 1.分析接口，接收什么参数，返回什么数据
 * 2.定义相关的数据类型
 * 3.封装api接口调用
 * 4.获取数据
 * 5.显示
 *
 * */

@Extend(Text)
function TextStyleName() {
  .fontSize(14)
  .fontColor($r('app.color.text_secondary'))
  .backgroundColor($r('app.color.white'))

}

class BaseContentItemBuilderClass {
  title: string = ""
  value: string = ""
  icon?: ResourceStr = ""
  iconClick?: () => void = () => {
  }
}