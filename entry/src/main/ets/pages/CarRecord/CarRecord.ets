/**
 * @Auhtor DLY
 *
 */
import { carRecord, getTaskDetail } from '../../api'
import { HmCard, HmCardItem, HmCheckBox, HmLoading, HMNavBar } from '../../components'
import { APP_TOP_HEIGHT } from '../../constants'
import {
  CarRecordParams,
  CarRecordParamsModel,
  CommonRouterParams,
  TaskDetailInfo,
  TaskDetailInfoModel
} from '../../models'
import { promptAction, router } from '@kit.ArkUI'
import dayjs from '@hview/dayjs'

@Entry
@Component
struct CarRecord {
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State carRecord: CarRecordParamsModel = new CarRecordParamsModel({} as CarRecordParams)
  layer: CustomDialogController = new CustomDialogController({
    builder: HmLoading({ loadingText: "回车处理中..." }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: true
  })

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.getTaskDetail(params.id)
    }
  }

  // 获取任务详情数据
  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  async btnRecord() {
    try {
      this.layer.open()
      // 1.数据准备
      this.carRecord.id = this.taskDetailData.transportTaskId //运输的任务id
      this.carRecord.startTime = this.taskDetailData.actualDepartureTime // 出车时间
      // 2. 调用后端接口实现具体交车任务
      if (!this.carRecord.endTime) {
        promptAction.showToast({ message: "回车时间不能为空！" })
        return
      }
      await carRecord(this.carRecord)
      promptAction.showToast({ message: "回车登记成功！" })
      router.clear() // 清除所有的路由栈
      router.replaceUrl({ url: 'pages/Index/Index' })
    } catch (e) {
      promptAction.showToast({ message: "回车登记失败！" })
    } finally {
      this.layer.close()
    }


  }

  build() {
    Column() {
      Row()
        .height(AppStorage.get<number>(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))
        .width('100%')
      HMNavBar({ title: '回车记录' })
      HmCard() {
        HmCardItem({
          leftTitle: '出车时间',
          rightContent: this.taskDetailData.actualDepartureTime || "",
          showRightIcon: false
        })
        HmCardItem({
          leftTitle: '回车时间',
          rightContent: this.carRecord.endTime || "请选择",
          showBorder: false,
          onRightClick: () => {
            DatePickerDialog.show({
              showTime: true,
              useMilitaryTime: true,
              alignment: DialogAlignment.Bottom,
              onDateAccept: (date: Date) => {
                // 推荐：第三方工具：axios/dayjs：时间格式化
                this.carRecord.endTime =
                  // YYYY-MM-DD HH:mm:ss
                  dayjs(date).format('YYYY-MM-DD HH:mm:ss') // 获取回车事件，如何将Date转换string类型
              },

            })
          }
        })
        HmCheckBox({ title: '车辆违章', value: false })
        HmCheckBox({ title: '车辆故障', value: false })
        HmCheckBox({ title: '车辆事故', value: false })
      }

      Row() {
        Button("交车")
          .backgroundColor($r('app.color.primary'))
          .width(200)
          .height(40)
          .onClick(async () => {
            await this.btnRecord()
          })
      }
      .position({
        y: '100%'
      })
      .translate({ y: -70 })
      .backgroundColor($r("app.color.white"))
      .height(70)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

    }
    .backgroundColor($r('app.color.background_page'))
    .width('100%')
    .height('100%')

  }
}