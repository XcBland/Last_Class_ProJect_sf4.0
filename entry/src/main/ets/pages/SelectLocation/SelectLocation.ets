import { HmCard, HmCardItem, HMNavBar,APP_TOP_HEIGHT,permissionManager, WebSdkClass } from 'swift_common';
import { Permissions } from '@kit.AbilityKit';
import { promptAction, router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { AddressItem } from '../../models/location';


//normal system_basic system_core
@Entry
@Component
struct SelectLocation {
  permissions: Permissions[] = ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"]
  webSdk: WebSdkClass = new WebSdkClass()
  @State
  list: AddressItem[] = []

  aboutToAppear(): void {
    this.checkPermission()
    WebSdkClass.webController = new webview.WebviewController()
    WebSdkClass.Context = getContext(this)

    WebSdkClass.Context.eventHub.on("search_list", (json: string) => {
      this.list = JSON.parse(json) as AddressItem[]
    })
  }

  // 页面销毁
  aboutToDisappear(): void {
    WebSdkClass.Context!.eventHub.off("search_list") // 销毁时取消监听
    WebSdkClass.Context = null // 销毁时清空Context
    WebSdkClass.webController = null // 销毁时清空WebController
  }

  //获取当前位置
  // async getLocation() {
  //   try {
  //     let location = await geoLocationManager.getCurrentLocation();
  //     AlertDialog.show({ message: JSON.stringify(location) })
  //   } catch (err) {
  //     AlertDialog.show({ message: JSON.stringify(err) })
  //   }
  // }

  // //检查用户权限
  // async checkPermission() {
  //   //没有权限，需要去向用户申请权限，有的话就直接获取
  //   //1.获取用户权限
  //   const manager = abilityAccessCtrl.createAtManager()
  //   //获取应用信息
  //   const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
  //   const status = manager.checkAccessTokenSync(appInfo.appInfo.accessTokenId, "ohos.permission.LOCATION")
  //   //2.判断是否拥有
  //   if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
  //     //未授权:需要拉取授权窗口，让提示用户授权
  //     const result = await manager.requestPermissionsFromUser(getContext(),
  //       ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"])
  //     if (result.authResults[0] !== 0) {
  //       //用户不同意:跳转到一个能够设置权限的应用中
  //       const context = getContext() as common.UIAbilityContext
  //       context.startAbility({
  //         bundleName: "com.huawei.hmos.settings", //设置也的包名
  //         abilityName: "com.huawei.hmos.settings.MainAbility",
  //         uri: "application_info_entry", //参数名
  //         parameters: {
  //           pushParams: appInfo.name
  //         }
  //       })
  //     } else {
  //       //用户同意了
  //       this.getLocation()
  //     }
  //   } else {
  //     //已授权
  //     this.getLocation()
  //   }
  //
  // }

  async checkPermission() {
    try {
      //没有权限，需要去向用户申请权限，有的话就直接获取
      //1.获取用户权限
      if (permissionManager.checkPermissions(this.permissions)) {
        //已授权
        // this.getLocation()
        return
      } else {
        await permissionManager.requestPermissions(this.permissions)
      }
    } catch (error) {
      promptAction.showDialog({
        alignment: DialogAlignment.Center,
        title: "权限提示",
        message: "定位功能需要获取权限，请在系统设置中打开定位开关！",
        buttons: [
          { text: "取消", color: $r("app.color.primary_disabled") },
          { text: "立即开启", color: $r("app.color.primary") }
        ]
      }).then((res) => {
        //点击的是“立即开启”按钮
        if (res.index === 1) {
          permissionManager.openPermissionSettingsPage()
        }
      })
    }

  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r("app.color.white"))
      HMNavBar({ title: "当前位置" })
      Web({
        src: $rawfile("location.html"),
        controller: WebSdkClass.webController
      })
        .height('100%')
        .javaScriptProxy({
          name: "swift",
          object: this.webSdk,
          methodList: ["alert", "toast", "setCurrentLocation", "receiveData"],
          controller: WebSdkClass.webController
        })
      Column() {
        HmCard() {
          ForEach(this.list, (item: AddressItem) => {
            HmCardItem({ leftTitle: item.address, rightContent: item.distance + "m以内" })
              .onClick(() => {
                router.back({
                  url: "pages/ExceptionReport/ExceptionReport",
                  params: {
                    address: item.address
                  }
                })
              })
          })
        }
      }
      .position({
        y: '100%'
      })
      .translate({
        y: -280
      })
    }
    .height("100%")
    .backgroundColor($r("app.color.background_page"))
  }
}