import dayjs from '@hview/dayjs'
/**
 * @Auhtor DLY
 *
 */

import {
  upLoadImage,
  HmSelectCard,
  APP_TOP_HEIGHT,
  HmCard,
  HmCardItem,
  HmLoading,
  HMNavBar,
  HmUpload,
  upLoadFile
} from 'swift_common'
import { reportExceptionParams, reportExceptionParamsModel } from '../../models/reportException'
import { reportException, } from '../../api'
import { promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams, ExceptionType } from '../../models'


@Entry
@Component
struct ExceptionReport {
  @State
  reportException: reportExceptionParamsModel = new reportExceptionParamsModel({} as reportExceptionParams)
  exceptionErrorList: string[] = Object.values(ExceptionType)
  @State selectIndex: number = -1
  typeDialog: CustomDialogController = new CustomDialogController({
    builder: HmSelectCard({
      cardContent: () => {
        this.getCardContent()
      },
      confirm: () => {
        if (this.selectIndex !== -1) {
          this.reportException.exceptionType = this.exceptionErrorList[this.selectIndex]
        }
      }
    }),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Bottom,

  })
  layer: CustomDialogController = new CustomDialogController({
    builder: HmLoading({ loadingText: "异常上报中,请稍后..." }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: true
  })

  // 获取异常类型列表
  @Builder
  getCardContent() {
    ForEach(this.exceptionErrorList, (item: ExceptionType, index) => {
      this.getSingLeItem(new ExceptionItemClass(item, index))
    })
  }

  @Builder
  getSingLeItem(item: ExceptionItemClass) {
    Row() {
      Text(item.name)
        .fontSize(14)
        .fontWeight(400)
        .fontColor($r('app.color.text_primary'))
      Image(this.selectIndex === item.index ? $r('app.media.ic_radio_true') : $r('app.media.ic_radio_false'))
        .width(20)
        .height(20)
        .border({ width: 1, style: BorderStyle.Dotted, color: $r('app.color.text_primary') })
        .onClick(() => {
          this.selectIndex = item.index
        })
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({ width: { bottom: 1 }, color: $r('app.color.background_divider') })
  }

  // 组件第一次创建的时候才会调用，而跳转页面是会将当前页面压栈
  // router.back()返回当前页面时会从栈中再拿出该页面
  aboutToAppear(): void {

  }

  // 页面销毁的时候才会调用，而跳转页面是会将当前页面压栈,所以应该用onPageShow()接收页面返回的参数或事件
  onPageShow(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.reportException.transportTaskId = params.id
    }
    if (params && params.address) {
      this.reportException.exceptionPlace = params.address
    }
  }

  // 按钮是否可用
  getBtnEnabled(): boolean {
    return !!(this.reportException.exceptionTime && this.reportException.exceptionDescribe &&
    this.reportException.exceptionType && this.reportException.exceptionPlace)
  }

  // 异常提交
  async ExceptionPickUp() {
    try {
      this.layer.open()
      if (this.reportException.exceptionImageList?.length) {
        this.reportException.exceptionImageList = await upLoadFile(this.reportException.exceptionImageList);
        await reportException(this.reportException)
        promptAction.showToast({ message: '上报成功', duration: 2000 })
        // router.back()
      }
    } catch (e) {
      promptAction.showToast({ message: '上报失败:' + e.message })
    } finally {
      this.layer.close()
      router.back({
        url: 'pages/TaskDetail/TaskDetail',
        params: {
          addException: true
        }
      })
    }
  }

  build() {
    Column() {
      Row().width('100%').height(AppStorage.get<number>(APP_TOP_HEIGHT)).backgroundColor($r('app.color.white'))
      HMNavBar({ title: '上报异常' })
      HmCard() {
        HmCardItem({
          leftTitle: '异常时间',
          rightContent: this.reportException.exceptionTime || "请选择",
          onRightClick: () => {
            DatePickerDialog.show({
              showTime: true,
              useMilitaryTime: true,
              alignment: DialogAlignment.Bottom,
              onDateAccept: (date: Date) => {
                this.reportException.exceptionTime = dayjs(date).format('YYYY-MM-DD HH:mm:ss')
                console.log(this.reportException.exceptionTime)
              }
            })
          }
        })
        HmCardItem({
          leftTitle: '上报位置', rightContent: this.reportException.exceptionPlace || "请选择", onRightClick: () => {
            router.pushUrl({ url: 'pages/SelectLocation/SelectLocation' })
          }
        })
        HmCardItem({
          leftTitle: '异常类型', rightContent: this.reportException.exceptionType || "请选择", onRightClick: () => {
            this.typeDialog.open()
          }
        })
        HmCardItem({
          leftTitle: '异常描述',
          rightContent: "",
          showRightIcon: false,
          showBorder: false,
        })
        TextArea({ placeholder: '请输入异常描述' })
          .maxLength(50)
          .backgroundColor($r('app.color.background_page'))
          .height(160)
          .fontSize(18)
          .margin({ top: 10, bottom: 10 })
          .onChange((value: string) => {
            this.reportException.exceptionDescribe = value
          })
          .showCounter(true) //显示字数统计
        Row().height(10).backgroundColor($r('app.color.white'))

      }

      HmCard() {
        HmUpload({
          title: '上传图片(最多六张)',
          maxSelected: 6,
          imgList: this.reportException.exceptionImageList || [],
          onListChange: (list) => {
            this.reportException.exceptionImageList = list
          }
        })
      }

      Row() {
        Button('提交')
          .onClick(() => {
            this.ExceptionPickUp()
          })
          .margin({ top: 10, bottom: 10 })
          .width('50%')
          .borderRadius(20)
          .backgroundColor(this.getBtnEnabled() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .type(ButtonType.Normal)
          .height(40)
          .enabled(this.getBtnEnabled())
      }
      .justifyContent(FlexAlign.Center)
      .padding({ top: 10, bottom: 10 })
      .width('100%')
      .position({ y: '100%' })
      .translate({ y: -70 })
      .height(70)

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))

  }
}

class ExceptionItemClass {
  name: string = ''
  index: number = -1

  constructor(name: string, index: number) {
    this.name = name
    this.index = index
  }
}