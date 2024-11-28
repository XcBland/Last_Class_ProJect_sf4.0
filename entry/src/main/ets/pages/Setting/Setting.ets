import { HmCard, HmCardItem, HmConfirm, HMNavBar } from '../../components'
import { promptAction, router } from '@kit.ArkUI'
import { TOKEN_KEY } from '../../constants'
import { UserSettingClass } from '../../utils'

PersistentStorage.persistProp(TOKEN_KEY, '')

@Entry
@Component
struct Setting {
  confimDialog: CustomDialogController = new CustomDialogController({
    builder: HmConfirm({
      message: '确定要退出吗？',
      buttonList: [
        { title: "取消", fontColor: $r('app.color.text_secondary') },
        {
          title: "确定", fontColor: $r('app.color.primary'), action: () => {
          //   实现退出功能
          this.logout()
        }
        }
      ]
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: false
  })

  // 退出功能
  logout() {
    // 清空Token
    AppStorage.set<string>(TOKEN_KEY, '')
    new UserSettingClass(getContext(this)).setUserToken('')
    // 跳转页面
    router.replaceUrl({ url: 'pages/Login/Login' })
  }

  build() {
    Column() {
      HMNavBar({ title: '系统设置' })
      HmCard() {
        HmCardItem({ leftTitle: '换绑手机', rightContent: "" })
        HmCardItem({ leftTitle: '修改密码', rightContent: "" })
        HmCardItem({ leftTitle: '消息通知设置', rightContent: "" })
        HmCardItem({ leftTitle: '清理缓存', rightContent: "" })
      }

      Row() {
        Button('退出', { type: ButtonType.Normal })
          .backgroundColor($r('app.color.white'))
          .borderRadius(10)
          .margin({ top: 20 })
          .onClick(() => {
            this.confimDialog.open()
          })
          .fontColor($r('app.color.text_primary'))
          .width('90%')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

    }

    .backgroundColor($r('app.color.background_page'))
    .width('100%')
    .height('100%')

  }
}