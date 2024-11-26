import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AdvertClass } from '../models';
import { UserSettingClass } from '../utils';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage){
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // 判断是否需要加载广告

    // 1.从后台服务中获取广告数据
    // 模拟从后台服务获取广告数据,一般从后台中会存在一个运行配置,来
    // 管理广告数据,此处仅作模拟
    // const result = await new Promise<AdvertClass>((resolve, reject) => {
    //   setTimeout(()=>{
    //     resolve({
    //       showAd: true,
    //       adTime: 10,
    //       adImg:$r("app.media.start")
    //     } as AdvertClass)
    //   }, 1000)
    // })

    // 2.存储首选项
    const userSetting = new UserSettingClass(this.context)
    // userSetting.setUserAd(result)
    const result = await userSetting.getUserAd()
    // 3.判断是否需要展示广告
    if(result.showAd){
      // 展示广告
      windowStage.loadContent('pages/Start/Start')
    }else{
      // 判断用户是否登录,如果登录,进入首页,否则进入登录页
      // 直接进入首页
      const token = await userSetting.getUserToken()
      if(token){
      //   已经登陆了,进入首页
        windowStage.loadContent('pages/Index')
      }else{
      // 未登录,进入登录页
        windowStage.loadContent('pages/Login/Login')
      }
    }
    // windowStage.loadContent('pages/Index');
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
