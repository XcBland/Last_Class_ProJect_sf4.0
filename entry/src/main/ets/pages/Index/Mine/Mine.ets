import { HmCard, HmCardItem, HmSkeleton } from "swift_common"
import { promptAction, router } from "@kit.ArkUI"
import { getUserInfo, getUserTaskInfo } from "../../../api"
import {
  UserInfo,
  UserInfoModel,
  UserTaskInfo,
  UserTaskInfoModel,
  UserTaskInfoParams,
  UserTaskInfoParamsModel
} from "../../../models"

@Preview
@Component
export struct Mine {
  @State
  userInfo: UserInfoModel = new UserInfoModel({} as UserInfo)
  // 本月查询数据
  queryTaskParams: UserTaskInfoParamsModel = new UserTaskInfoParamsModel({
    year: new Date().getFullYear().toString(),
    month: (new Date().getMonth() + 1).toString()
  })
  // 本月用户数据
  @State
  userTaskInfo: UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)

  aboutToAppear() {
    // 页面显示时，获取用户信息
    this.getUserData()
    this.getUserTaskData()
  }

  // 获取用户数据
  async getUserData() {
    // 将获取到的用户信息赋值给userInfo对象
    this.userInfo = await getUserInfo()
  }

  // 获取本月数据类型
  async getUserTaskData() {
    this.userTaskInfo = await getUserTaskInfo(this.queryTaskParams)
  }

  build() {
    Column() {
      if (!this.userInfo.name) {
        //   显示骨架屏
        HmSkeleton()
      } else {
        //1.基本信息
        Column({ space: 10 }) {
          Image(this.userInfo.avatar || $r('app.media.ic_avatar_driver'))
            .width(70)
            .height(70)
            .borderRadius(35)
            .backgroundColor($r('app.color.white'))
          Text(this.userInfo.name || '司机')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.white'))
            .lineHeight(25)
            .textAlign(TextAlign.Center)
          Text("司机编号:" + this.userInfo.number || "司机编号:1111111")
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .lineHeight(20)
            .fontColor($r('app.color.white'))
            .textAlign(TextAlign.Center)
          Text("联系电话:" + this.userInfo.phone || "联系电话:13811111111")
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .lineHeight(20)
            .fontColor($r('app.color.white'))
            .textAlign(TextAlign.Center)

        }
        .backgroundImage($r('app.media.bg_page_my'))
        .width('100%')
        .height(255)
        .backgroundImageSize(ImageSize.Cover)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)

        //2.本月任务
        Column({ space: 10 }) {
          Text(`${this.queryTaskParams.year}年${this.queryTaskParams.month}月任务数据`)
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .lineHeight(20)
            .textAlign(TextAlign.Center)
          Row() {
            Column({ space: 18 }) {
              Text(this.userTaskInfo.taskAmounts?.toString() || '0')
                .fontSize(18)
                .fontColor($r('app.color.text_primary'))
                .lineHeight(20)
                .textAlign(TextAlign.Center)

              Text("任务总量")
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .lineHeight(20)
                .textAlign(TextAlign.Center)
            }

            Column({ space: 20 }) {
              Text(this.userTaskInfo.completedAmounts?.toString() || '0')
                .fontSize(18)
                .fontColor($r('app.color.text_primary'))
                .lineHeight(20)
                .textAlign(TextAlign.Center)

              Text("完成任务量")
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .lineHeight(20)
                .textAlign(TextAlign.Center)
            }

            Column({ space: 20 }) {
              Text(this.userTaskInfo.transportMileage?.toString() || '0')
                .fontSize(18)
                .fontColor($r('app.color.text_primary'))
                .lineHeight(20)
                .textAlign(TextAlign.Center)

              Text("运输里程(km)")
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .lineHeight(20)
                .textAlign(TextAlign.Center)
            }

          }
          .margin({ top: 10 })
          .justifyContent(FlexAlign.SpaceAround)
          .width('100%')
          .layoutWeight(1)
        }
        .backgroundColor($r('app.color.white'))
        .height(140)
        .width('96%')
        .borderRadius(10)
        .margin({
          top: -25,
          bottom: 10,
          left: 20,
          right: 20
        })
        .padding({ top: 15, bottom: 15 })

        //3.综合信息
        HmCard() {
          HmCardItem({
            leftTitle: "车辆数据", rightContent: "", onRightClick: () => {
              router.pushUrl({ url: 'pages/Car/CarInfo' })
            }
          })
          HmCardItem({ leftTitle: "任务数据", rightContent: "20/150", showRightIcon: false })
          HmCardItem({
            leftTitle: "系统数据", onRightClick: () => {
              router.pushUrl({ url: 'pages/Setting/Setting' })
            }, showBorder: false
          })
        }

      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}