import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants';
import { TabClass } from '../../models';
import { Mine } from './Mine/Mine';
import { TaskTabs } from './Task/TaskTabs';

@Entry
@Component
struct Index {
  @State tabsData: TabClass[] = [
    { title: '任务', name: 'task', icon: $r('app.media.ic_tab_btn_task') },
    { title: '消息', name: 'message', icon: $r('app.media.ic_tab_btn_mess_nor') },
    { title: '我的', name: 'mine', icon: $r('app.media.ic_tab_btn_mine_nor') }
  ];
  @State currentName: string = "task"

  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon)
        .width(24)
        .height(24)
        .margin({ top: 5, bottom: 5 })
        .borderRadius(12)
        .objectFit(ImageFit.Cover)
        .fillColor(item.name === this.currentName ? $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .fontColor(item.name === this.currentName ? $r('app.color.primary') : $r('app.color.text_secondary'))
    }

  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      ForEach(this.tabsData, (item: TabClass, index) => {
        TabContent() {
          if (item.name === 'task') {
            TaskTabs()
          } else if (item.name === 'message') {
            Text("消息组件")
          } else if (item.name === 'mine') {
            Mine()
          }
        }
        .tabBar(this.getTabBar(item))
      })
    }
    .onChange((index: number) => {
      this.currentName = this.tabsData[index].name
    })
    .animation({ duration: 300, curve: Curve.EaseIn })
    .backgroundColor("#fcfb")
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })

  }
}