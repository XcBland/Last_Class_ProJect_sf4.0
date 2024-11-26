import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AdvertClass } from '../models/advert';
import { UserSettingClass } from '../utils/setting';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    //判断是否需要加载广告
    //1.从后台服务中获取广告数据
    //模拟从后台服务读取广告数据，一般后台中会存在一个运行配置来管理广告数据，我们这里模拟一下
    // const result = await new Promise<AdvertClass>((resolve, reject) => {
    //   setTimeout(() => {
    //     resolve({
    //       showAd: true,
    //       adTime: 10,
    //       adImg: $r("app.media.start")
    //     } as AdvertClass)
    //   }, 500)
    // })

    //2.存储首选项
    const userSetting = new UserSettingClass(this.context)
    const result = await userSetting.getUserAd()
    //userSetting.setUserAd(result)

    //3.判断是否需要展示广告
    if (result.showAd) {
      windowStage.loadContent('pages/Start/Start'); //展示广告页
    } else {
      //判断用户是否已经登录过了，如果没有登录则需要跳转到登录页
      const token = await userSetting.getUserToken()
      if (token) {
        //已经登录过了
        windowStage.loadContent('pages/Index');
      } else {
        //还没有登录
        windowStage.loadContent('pages/Login/Login');
      }
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
