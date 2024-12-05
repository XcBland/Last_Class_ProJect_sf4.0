/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmCardItem, HMNavBar } from '../../components';
import { APP_TOP_HEIGHT } from '../../constants';
import { geoLocationManager } from '@kit.LocationKit';
import { Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { permissionManager, PermissionManager, WebSdkClass } from '../../utils';
import { promptAction } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct SelectLocation {
  permissions: Permissions[] = ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"]
  permissionsManager: PermissionManager = new PermissionManager()
  webSdk: WebSdkClass = new WebSdkClass()
  aboutToAppear() {
    this.checkPermission()
    WebSdkClass.webController = new webview.WebviewController()
  }

  // 获取位置
  getLocation() {
    try {
      // let location = await geoLocationManager.getCurrentLocation();
      geoLocationManager.getCurrentLocation().then((location) => {
        AlertDialog.show({ message: JSON.stringify(location) })
      }).catch((err: BusinessError) => {
        console.log(JSON.stringify(err))
      })
    } catch (err) {
      AlertDialog.show({ message: JSON.stringify(err) })
    }
  }

  // 检查权限
  /*async checkPermission() {
    // 没有权限,向用户申请权限,有的话直接获取
    // 1. 检查是否有权限
    let manager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    const status = manager.checkAccessTokenSync(appInfo.appInfo.accessTokenId, "ohos.permission.LOCATION")
    // 2.判断是否有权限
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      // 未授权:需要拉起授权窗口,提示用户授权
      const result = await manager.requestPermissionsFromUser(getContext(),
        ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"])
      if (result.authResults[0] !== 0) {
        // 用户不同意
        const context = getContext() as common.UIAbilityContext
        context.startAbility({
          abilityName: "com.huawei.hmos.settings.MainAbility",
          bundleName: "com.huawei.hmos.settings",
          uri: "application_info_entry",
          parameters: {
            pushParams: appInfo.name
          }
        })
      } else {
        // 用户同意,获取位置
        this.getLocation()
      }
    } else {
      // 已授权
      this.getLocation()
    }

  }*/

  async checkPermission() {
    try {
      // 1. 检查是否有权限
      if (permissionManager.checkPermissions(this.permissions)) {
        this.getLocation()
      } else {
        await permissionManager.requestPermissions(this.permissions)
      }
    } catch (err) {
      promptAction.showDialog({
        alignment: DialogAlignment.Center,
        title: "权限提示",
        message: "获取位置失败,请检查权限",
        buttons: [{ text: "确定", primary: true, color: "#007AFF" },
          { text: "取消", color: $r('app.color.text_secondary') }]
      }).then((res) => {
        // 点击的是"立即开启按钮"
        if (res.index === 0) {
          permissionManager.openPermissionSettingsPage()
        }
      }).catch(() => {
      })
        .finally(() => {
          this.getLocation()
        })
    }
  }

  build() {
    Column() {
      Row().width('100%').height(AppStorage.get<number>(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))
      HMNavBar({ title: '当前位置' })
      Web({
        src: $rawfile('location.html'),
        controller: WebSdkClass.webController
      })
        .height('100%')
        .javaScriptProxy({
          name: 'swift',
          object: this.webSdk,
          methodList: ['alert','toast'],
          controller: WebSdkClass.webController
        })
      Text('地图')
      Column() {
        HmCard() {
          HmCardItem({ leftTitle: '人民广场', rightContent: '100m以内' })
          HmCardItem({ leftTitle: '金色大厅', rightContent: '100m以内' })
          HmCardItem({ leftTitle: '维也纳', rightContent: '100m以内' })
          HmCardItem({ leftTitle: '中山公园', rightContent: '100m以内' })
        }
      }

      .borderRadius(10)
      .position({
        y: '100%'
      })
      .translate({
        y: -260
      })
      .height(270)
    }
    .backgroundColor($r('app.color.background_page'))
    .width('100%')
    .height('100%')

  }
}