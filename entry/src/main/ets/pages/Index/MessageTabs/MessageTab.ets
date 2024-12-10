import { APP_TOP_HEIGHT } from 'swift_common'
import { MessageClass } from '../../../models/messagetab'
import { Bulletin } from './BulletinComp/Bullentin'
import { TaskNotify } from './TaskNotifyComp/TaskNotify'

@Component
export struct MessageTab {
  @State currentIndex: number = 0
  @State messageTabs: MessageClass[] = [
    { title: '公告', name: 'Bulletin' },
    { title: '任务通知', name: 'TaskNotify' }
  ]
  @State
  currentName: string = "Bulletin"

  @Builder
  getTabBar(item: MessageClass) {
    Column() {
      Text(item.title)
        .fontWeight(item.name === this.messageTabs[this.currentIndex].name ? FontWeight.Bold :
        FontWeight.Normal)// .margin({ top: 5 })
        .fontColor(item.name === this.messageTabs[this.currentIndex].name ? $r('app.color.text_primary') :
        $r('app.color.text_secondary'))
        .lineHeight(50)
        .fontSize(18)
        .height(50)
        .animation({ duration: 300, curve: Curve.EaseInOut })
      Divider()
        .strokeWidth(4)// 线条宽度
        .color($r('app.color.primary'))// 线条颜色
        .lineCap(LineCapStyle.Round)// 线条端点样式
        .width(item.name === this.messageTabs[this.currentIndex].name ? 30 : 0)
        .animation({ duration: 300, curve: Curve.EaseInOut })

    }
    .onClick(() => {
      // 利用findIndex方法，通过name属性找到当前点击的Tab的index
      const index = this.messageTabs.findIndex(obj => obj.name === item.name)
      this.currentIndex = index
    })
  }

  build() {
    Column() {
      Row() {
        Text("消息")
          .fontSize(20)
          .fontWeight("bold")
      }
      .backgroundColor($r('app.color.white'))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width("100%")
      .height(40)

      Stack({ alignContent: Alignment.Top }) {
        Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex }) {
          ForEach(this.messageTabs, (item: MessageClass, index: number) => {
            TabContent() {
              if (item.name === "Bulletin") {
                Bulletin()
              } else {
                TaskNotify()
              }
            }.tabBar(item.title).key(index.toString())
          })
        }

        Row({ space: 30 }) {
          ForEach(this.messageTabs, (item: MessageClass, index: number) => {
            this.getTabBar(item)
          })
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        .height(50)
        .backgroundColor($r('app.color.white'))
        .padding({ left: 40, right: 40 })
      }
      .width("100%")
      .height("100%")

    }
    .width("100%")
    .height("100%")
    .backgroundColor($r('app.color.background_page'))

  }
}