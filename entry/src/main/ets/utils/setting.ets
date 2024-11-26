import { preferences } from "@kit.ArkData";
import { Context } from "@kit.AbilityKit";
import { USER_SETTING, USER_SETTING_AD } from "../constants";
import { AdvertClass } from "../models";
const defaultAd = {
  showAd: true,
  adTime: 10,
  adImg: $r('app.media.start'),
} as AdvertClass
export class UserSettingClass {
  // 功能一：实现广告数据的存储
  context:Context
  constructor(context:Context){
    this.context = context
  }
  // 1、获取首选项对象
  getStore(){
    return preferences.getPreferences(this.context,USER_SETTING)
  }
  // 2、读取首选项
  async getUserAd(){
    const adStore = await this.getStore()
    const adString = await adStore.get(USER_SETTING_AD,JSON.stringify(defaultAd)) as string
    return JSON.parse(adString) as AdvertClass

  }
  // 3、存储首选项
  async setUserAd(ad:AdvertClass){
    const adStore = await this.getStore()
    // 存储广告数据
    await adStore.put(USER_SETTING_AD,JSON.stringify(ad))
    // 刷新存储
    await adStore.flush()
  }
}