import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';

export class PermissionManager {
  // 检查是否有权限
  checkPermissions(permission: Permissions[]) {
    let manager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    const tokenId = appInfo.appInfo.accessTokenId;
    //校验每个权限是否有权限,并返回校验类型
    const authResults = permission.map((per) => {
      return manager.checkAccessTokenSync(tokenId, per)
    })
    //处理授权结果
    return authResults.every((status) => {
      status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
  }

  // 动态权限申请
  async requestPermissions(permissions: Permissions[]): Promise<boolean> {
    const manager = abilityAccessCtrl.createAtManager()
    const result = await manager.requestPermissionsFromUser(getContext(), permissions)
    const isAuth = result.authResults.every((status) => {
      status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
    return isAuth === true ? Promise.resolve(true) : Promise.reject(false)
  }

  // 打开系统管理页,让用户自己去设置
  openPermissionSettingsPage() {
    // 用户不同意
    const context = getContext() as common.UIAbilityContext
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    context.startAbility({
      abilityName: "com.huawei.hmos.settings.MainAbility",
      bundleName: "com.huawei.hmos.settings",
      uri: "application_info_entry",
      parameters: {
        pushParams: appInfo.name
      }
    })
  }
}

export const permissionManager = new PermissionManager();