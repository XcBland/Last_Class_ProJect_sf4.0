/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmCardItem, HMNavBar } from '../../components'
import { APP_TOP_HEIGHT } from '../../constants'
import { geoLocationManager } from '@kit.LocationKit';

@Entry
@Component
struct SelectLocation {
  aboutToAppear(): void {
    this.getLocation()
  }

  // 获取位置
  getLocation() {
    try {
      let location = geoLocationManager.getCurrentLocation();
      AlertDialog.show({ message: '当前位置：' + JSON.stringify(location) })
    } catch (err) {
      console.error("errCode:" + JSON.stringify(err));
    }
  }

  build() {
    Column() {
      Row().width('100%').height(AppStorage.get<number>(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))
      HMNavBar({ title: '当前位置' })
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
      .height(70)
    }
    .width('100%')
    .height('100%')

  }
}