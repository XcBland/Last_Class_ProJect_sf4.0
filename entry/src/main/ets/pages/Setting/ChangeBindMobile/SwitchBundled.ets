import { HMNavBar,APP_TOP_HEIGHT } from 'swift_common';


// 输入框通用样式
@Extend(TextInput)
function inputStyle() {
  .backgroundColor('#fff').height(36).borderRadius(0)
}

// 线通用样式
@Extend(Line)
function lineStyle() {
  .width('100%').height(1).backgroundColor('#fbfbfb').margin({ top: 8, bottom: 8 })
}


@Entry
@Component
struct SwitchBundled {
  // 倒计时秒数
  @State timeSeconds: number = 60

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r("app.color.white"))
      // 导航条
      HMNavBar({ title: '换绑手机' })

      Column() {

        // 手机号
        TextInput({ placeholder: '请输入已绑定手机号' }).inputStyle().width('100%').margin({ top: 15 })
        Line().lineStyle()

        Row() {
          // 验证码
          TextInput({ placeholder: '请输入验证码' }).inputStyle().layoutWeight(1).border({
            width: { right: 1 }, color: '#fbfbfb'
          })

          // 倒计时容器
          Column() {
            if (this.timeSeconds === 60) {
              Button('获取验证码').backgroundColor(Color.Transparent).fontColor('#818181')
            } else {
              Text(`${this.timeSeconds}s后重新获取`).fontColor('#818181')
            }
          }.width(130)
        }

        Line().lineStyle()

        // 下一步按钮
        Button('下一步')
          .height(50)
          .width('100%')
          .backgroundColor('#ee4f3e')
          .fontColor('#fff')
          .margin({ top: 50 })

      }.padding({ left: 28, right: 28 })

    }.width('100%').height('100%').backgroundColor("#fff")
  }
}