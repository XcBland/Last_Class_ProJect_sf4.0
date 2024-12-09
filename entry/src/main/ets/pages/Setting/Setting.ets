import { UserSettingClass ,HmCard, HmCardItem, HmConfirm, HMNavBar,APP_TOP_HEIGHT, TOKEN_KEY } from 'swift_common'
import { promptAction, router } from '@kit.ArkUI'
import { fileIo as fs, ListFileOptions } from '@kit.CoreFileKit'

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
  // 清理缓存弹窗
  clearCacheDialog: CustomDialogController = new CustomDialogController({
    builder: HmConfirm({
      message: '确定要清除缓存吗？',
      buttonList: [
        { title: "取消", fontColor: $r('app.color.text_secondary') },
        {
          title: "确定", fontColor: $r('app.color.primary'), action: () => {
          //   实现清理缓存功能
          this.clearCache()
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

  // 清理缓存功能
  clearCache() {
    //先获取缓存目录
    let listFileOptions: ListFileOptions = {
      recursion: true, //递归遍历
      listNum: 0, //不限制文件数量
    }
    let filenames = fs.listFileSync(getContext().cacheDir, listFileOptions)
    console.info("filenames: %s", filenames);
    //删除缓存文件
    for (let i = 0; i < filenames.length; i++) {
      if (filenames.length > 0) {
        console.info("filename: %s", filenames[i]);
      }
    }
    let filePaths = getContext().cacheDir //删除缓存目录下的所有文件
    fs.rmdirSync(filePaths)

    // this.clearCacheDialog.close()
    promptAction.showToast({ message: '缓存清理成功' })

  }

  build() {
    Column() {
      Row()
        .height(AppStorage.get<number>(APP_TOP_HEIGHT))
        .width('100%')
        .backgroundColor($r('app.color.white'))
      HMNavBar({ title: '系统设置' })
      HmCard() {
        HmCardItem({
          leftTitle: '换绑手机', rightContent: "", onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/ChangeBindMobile/SwitchBundled' })
          }
        })
        HmCardItem({
          leftTitle: '修改密码', rightContent: "", onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/ChangePassword/ChangePassword' })
          }
        })
        HmCardItem({
          leftTitle: '消息通知设置', rightContent: "", onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/MessageSetting/MessageSetting' })
          }
        })
        HmCardItem({
          leftTitle: '清理缓存', rightContent: "", onRightClick: () => {
            // 实现清理缓存功能(自定义弹窗)、
            // this.clearCacheDialog.open()
            router.pushUrl({ url: 'pages/Setting/ClearCache/ClearCache' })
          }
        })
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