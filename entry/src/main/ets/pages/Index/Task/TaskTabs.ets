import { TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import { TabClass } from '../../../models/tab'
import { TaskList } from './TaskList'

@Component
struct TaskTabs {
  @State currentIndex: number = 0
  @State
  tabsData: TabClass[] = [
    {
      title: "待提货",
      name: "waiting"
    },
    {
      title: "在途",
      name: "line"
    },
    {
      title: "已完成",
      name: "completed"
    }
  ]
  @State
  currentName: string = "waiting"

  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Text(item.title)
        .fontWeight(FontWeight.Bold)// .margin({ top: 5 })
        .fontColor(item.name === this.tabsData[this.currentIndex].name ? $r('app.color.primary') :
        $r('app.color.text_secondary'))
        .lineHeight(50)
        .height(50)
        .animation({ duration: 300, curve: Curve.EaseInOut })
      Divider()
        .strokeWidth(4)// 线条宽度
        .color($r('app.color.primary'))// 线条颜色
        .lineCap(LineCapStyle.Round)// 线条端点样式
        .width(item.name === this.tabsData[this.currentIndex].name ? 30 : 0)
        .animation({ duration: 300, curve: Curve.EaseInOut })

    }

    .onClick(() => {
      // 利用findIndex方法，通过name属性找到当前点击的Tab的index
      const index = this.tabsData.findIndex(obj => obj.name === item.name)
      this.currentIndex = index
    })
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // $$this.currentIndex:currentIndex状态变量和当前Tabs组件的index进行双向关联
      Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex }) {
        ForEach(this.tabsData, (item: TabClass, index: number) => {
          TabContent() {
            if (item.name === "waiting") {
              //   待提货Tab内容
              TaskList()
            } else if (item.name === "line") {
              //   在途Tab内容

              TaskList({
                queryParams: new TaskListParamsModel({
                  status: TaskTypeEnum.LINE,
                  page: 1,
                  pageSize: 5
                } as TaskListParams)
              })


            } else {
              TaskList({
                queryParams: new TaskListParamsModel({
                  status: TaskTypeEnum.FINISH,
                  page: 1,
                  pageSize: 5
                } as TaskListParams)
              })
            }

          }.tabBar(item.title).key(index.toString())
        })
      }

      .barWidth(200)
      .backgroundColor($r('app.color.background_page'))
      .animationDuration(300)

      Row({ space: 30 }) {
        ForEach(this.tabsData, (item: TabClass, index: number) => {
          this.getTabBar(item)
        })
      }
      .width('100%')
      .height(50)
      .backgroundColor($r('app.color.white'))
      .padding({ left: 40, right: 40 })
    }
  }
}

export { TaskTabs }