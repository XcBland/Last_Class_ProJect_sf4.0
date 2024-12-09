/**
 * @Auhtor DLY
 *
 */
import { promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams } from '../../models/router'
import { ExceptionList, ImageList, TaskDetailInfo, TaskDetailInfoModel, TaskTypeEnum } from '../../models'
import { deliver, getTaskDetail, pickUp } from '../../api'
import { JSON, MessageEvent, MessageEvents, worker } from '@kit.ArkTS'
import { call } from '@kit.TelephonyKit'
import { APP_TOP_HEIGHT , HmLoading, HMNavBar, HmSkeleton, HmToggleCard, HmUpload, upLoadFile } from 'swift_common'
import { PickUpParamsModel } from '../../models/pick_up'
import { DeliverParamsModel } from '../../models/deliver'
import { PostParams } from '../../workers/UploadWorker'

@Entry
@Component
struct TaskDetail {
  @State title: string = '任务详情'
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  scroller: Scroller = new Scroller()
  layer: CustomDialogController = new CustomDialogController({
    builder: HmLoading({ loadingText: "数据处理中,请耐心等待" }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: true
  })

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

  async onPageShow(): Promise<void> {
    this.scroller.scrollTo({
      yOffset: APP_TOP_HEIGHT.toString(),
      xOffset: ''
    })
    const params = router.getParams() as CommonRouterParams
    if (params && params.addException) {
      const result = await getTaskDetail(this.taskDetailData.id)
      this.taskDetailData.exceptionList = result.exceptionList
    }
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

        // 在途的情况下显示
        if (this.taskDetailData.status === TaskTypeEnum.LINE) {
          Column({ space: 10 }) {
            Image($r('app.media.ic_navigation'))
              .width(20)
              .height(20)
              .margin({ right: 10 })
            Text('开始导航')
              .textAlign(TextAlign.Center)
              .fontSize(14)
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Navigation/NavigationPage',
              params: {
                startAddress: this.taskDetailData.startAddress,
                endAddress: this.taskDetailData.endAddress
              }
            })
          })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
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
    HmUpload({
      title: "请拍照上传回单凭证",
      imgList: this.taskDetailData.cargoPickUpPictureList || [],
      onListChange: (list: ImageList[]) => {
        // 用来接收子组件传递的值
        this.taskDetailData.cargoPickUpPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.WAITING
        ? true
        : false
    })
    HmUpload({
      title: "请拍照上传货品照片",
      imgList: this.taskDetailData.cargoPictureList || [],
      onListChange: (list: ImageList[]) => {
        // 用来接收子组件传递的值
        this.taskDetailData.cargoPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.WAITING
        ? true
        : false

    })
  }

  /* 交货信息 */
  @Builder
  getDeliverInfo() {
    HmUpload({
      title: "请拍照上传回单凭证",
      imgList: this.taskDetailData.certificatePictureList || [],
      onListChange: (list: ImageList[]) => {
        // 用来接收子组件传递的值
        this.taskDetailData.certificatePictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.LINE
        ? true
        : false
    })
    HmUpload({
      title: "请拍照上传交货货品照片",
      imgList: this.taskDetailData.deliverPictureList || [],
      onListChange: (list: ImageList[]) => {
        // 用来接收子组件传递的值
        this.taskDetailData.deliverPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.LINE
        ? true
        : false
    })
  }

  /*底部按钮*/
  @Builder
  getBottomButton() {
    Row() {
      if (this.taskDetailData.status === TaskTypeEnum.WAITING) {
        Button("延迟提货")
          .type(ButtonType.Normal)
          .width(125)
          .height(40)
          .borderRadius(15)
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Delay/Delay',
              params: {
                id: this.taskDetailData.id
              }
            })
          })

        Button("提货")
          .type(ButtonType.Normal)
          .height(40)
          .borderRadius(15)
          .layoutWeight(1)
          .fontColor($r('app.color.white'))
          .backgroundColor(this.getPickupStatus() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .margin({ left: 20 })
          .enabled(this.getPickupStatus())
          .onClick(async () => {
            // 1.图片上传，将本地相册中的图片上传至服务器
            await this.btnPickUp()
          })
      } else if (this.taskDetailData.status === TaskTypeEnum.LINE) {
        Button("上报异常")
          .type(ButtonType.Normal)
          .width(125)
          .height(40)
          .borderRadius(15)
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/ExceptionReport/ExceptionReport', params: { id: this.taskDetailData.id } })
          })

        Button("交货")
          .type(ButtonType.Normal)
          .height(40)
          .borderRadius(15)
          .layoutWeight(1)
          .fontColor($r('app.color.white'))
          .backgroundColor(this.getDeliverStatus() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .margin({ left: 20 })
          .enabled(this.getDeliverStatus())
          .onClick(async () => {
            // 1.图片上传，将本地相册中的图片上传至服务器
            await this.btnDeliver()
          })
      } else if (this.taskDetailData.status === TaskTypeEnum.DELIVERED) {
        Column() {
          Row() {
            Button("回车登记")
              .type(ButtonType.Normal)
              .height(40)
              .borderRadius(15)
              .width('80%')
              .backgroundColor($r('app.color.primary'))
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/CarRecord/CarRecord',
                  params: {
                    id: this.taskDetailData.id
                  }
                })
              })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
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

  // 显示异常信息
  @Builder
  async getExceptionInfo() {
    ForEach(this.taskDetailData.exceptionList, (item: ExceptionList) => {
      Row() {
        Column() {
          Row() {
            Text('上报时间')
              .fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionTime)
              .fontSize(14).fontColor($r('app.color.text_primary'))
          }
          .width('100%')
          .height(40)

          Row() {
            Text('异常类型')
              .fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionType)
              .fontSize(14).fontColor($r('app.color.text_primary'))
          }
          .width('100%')
          .height(40)

          Row() {
            Text('处理结果')
              .fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.handleResult)
              .fontSize(14).fontColor($r('app.color.text_primary'))
          }
          .width('100%')
          .height(40)
        }

        Image($r('app.media.ic_btn_more'))
          .width(20)
          .aspectRatio(1)
          .onClick(() => {
            // 显示当前异常的详细内容，但缺少后端接口，我们就直接吧当前异常数据传到详情页
            router.pushUrl({
              url: 'pages/ExceptionReport/ExceptionDetail',
              params: {
                exceptionDetail: item
              }
            })
          })
      }
      .width('100%')
      .padding({
        top: 10,
        bottom: 10,
        left: 20,
        right: 20
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .border({ width: { bottom: 1 }, color: $r('app.color.background_divider') })
    })

  }

  // 获取按钮的提货状态
  getPickupStatus() {
    if (
      this.taskDetailData.cargoPickUpPictureList?.length > 0
        && this.taskDetailData.cargoPictureList?.length > 0
        && this.taskDetailData.cargoPickUpPictureList.every((item) =>!!item.url)
        && this.taskDetailData.cargoPictureList.every((item) =>!!item.url)) {
      return true
    }
    return false

  }

  // 获取按钮的交货状态
  getDeliverStatus() {
    if (
      this.taskDetailData.deliverPictureList?.length > 0
        && this.taskDetailData.certificatePictureList?.length > 0
        && this.taskDetailData.deliverPictureList.every((item) =>!!item.url)
        && this.taskDetailData.certificatePictureList.every((item) =>!!item.url)) {
      return true
    }
    return false

  }

  /* 提货按钮 */
  async btnPickUp() {
    try {
      this.layer.open()
      // 上传图片,获取永久的图片地址
      const cargoPickUpPictureListUrl =
        await upLoadFile(this.taskDetailData.cargoPickUpPictureList) // 上传凭证图片,获取永久的提货图片地址
      const cargoPictureListUrl = await upLoadFile(this.taskDetailData.cargoPictureList) // 上传货品图片,获取永久的货品图片地址
      // 实现提货功能
      await pickUp(new PickUpParamsModel({
        id: this.taskDetailData.id,
        cargoPickUpPictureList: cargoPickUpPictureListUrl,
        cargoPictureList: cargoPictureListUrl
      }))

      this.getTaskDetail(this.taskDetailData.id)

      this.scroller.scrollEdge(Edge.Top) // 回到顶部

      promptAction.showToast({ message: "提货成功", duration: 2000 })
      this.layer.close()
    } catch (error) {
      promptAction.showToast({ message: "提货失败" + error.message, duration: 2000 })
    } finally {
      this.layer.close()
    }

  }

  /* 交货按钮 */
  async btnDeliver() {
    try {
      this.layer.open()

      // 创建子线程
      const worker1 = new worker.ThreadWorker("entry/ets/workers/UploadWorker.ts")
      const worker2 = new worker.ThreadWorker("entry/ets/workers/UploadWorker.ts")

      // 发送消息给子线程
      worker1.postMessage({
        file: [...this.taskDetailData.cargoPickUpPictureList],
        filePath: getContext().cacheDir
      })
      worker2.postMessage({
        file: [...this.taskDetailData.cargoPictureList],
        filePath: getContext().cacheDir
      })
      //子线程进行图片压缩


      // 主线程接收子线程回传的内容
      let cargoPickUpPictureList: ImageList[] = []
      let cargoPictureList: ImageList[] = []
      worker1.onmessage = (e: MessageEvents) => {
        const params = e.data as PostParams
        cargoPickUpPictureList = params.files
        checkFile()
      }
      worker2.onmessage = (e: MessageEvents) => {
        const params = e.data as PostParams
        cargoPictureList = params.files
        checkFile()
      }

      // 主线程继续进行图片上传

      const checkFile = async () => {
        if (cargoPickUpPictureList.length && cargoPictureList.length) {
          const result = await Promise.all([
            upLoadFile(cargoPickUpPictureList),
            upLoadFile(cargoPictureList)
          ])
          await pickUp(new PickUpParamsModel({
            id: this.taskDetailData.id,
            cargoPickUpPictureList: result[0],
            cargoPictureList: result[1]
          }))
          this.getTaskDetail(this.taskDetailData.id)
          this.scroller.scrollEdge(Edge.Top) // 回到顶部
          promptAction.showToast({ message: "提货成功", duration: 2000 })
        }
      }

      /*      // 上传图片,获取永久的图片地址
            const certificatePictureListUrl =
              await upLoadFile(this.taskDetailData.certificatePictureList)
            const deliverPictureListUrl = await upLoadFile(this.taskDetailData.deliverPictureList)
            // 实现提货功能
            await deliver(new DeliverParamsModel({
              id: this.taskDetailData.id,
              certificatePictureList: certificatePictureListUrl,
              deliverPictureList: deliverPictureListUrl,
            }))
            this.getTaskDetail(this.taskDetailData.id)
            this.scroller.scrollEdge(Edge.Top) // 回到顶部
            promptAction.showToast({ message: "交货成功", duration: 2000 })
            this.layer.close()*/
    } catch (error) {
      promptAction.showToast({ message: "交货失败" + error.message, duration: 2000 })
    } finally {
      this.layer.close()
    }

  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get<number>(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.background_page'))
      HMNavBar({ title: this.title })
      if (this.taskDetailData.id) {
        //   显示详情
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

            if (this.taskDetailData.exceptionList && this.taskDetailData.exceptionList.length > 0) {
              HmToggleCard({ title: '异常信息' }) {
                this.getExceptionInfo()
              }
            }

            if (this.taskDetailData.status === TaskTypeEnum.WAITING ||
              this.taskDetailData.status === TaskTypeEnum.DELIVERED ||
              this.taskDetailData.status === TaskTypeEnum.FINISH) {
              HmToggleCard({ title: "提货信息" }) {
                this.getPikUpInfo()
              }
            }
            if (this.taskDetailData.status === TaskTypeEnum.LINE ||
              this.taskDetailData.status === TaskTypeEnum.DELIVERED ||
              this.taskDetailData.status === TaskTypeEnum.FINISH) {
              HmToggleCard({ title: "交货信息" }) {
                this.getDeliverInfo()
              }
            }

          }
        }
        .padding({ bottom: 120 })

      } else {
        HmSkeleton()
      }
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