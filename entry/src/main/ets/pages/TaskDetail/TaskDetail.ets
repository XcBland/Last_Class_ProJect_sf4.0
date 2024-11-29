/**
 * @Auhtor DLY
 *
 */
import { HMNavBar, HmToggleCard } from '../../components'
import { router } from '@kit.ArkUI'
import { CommonRouterParams } from '../../models/router'
import { TaskDetailInfo, TaskDetailInfoModel } from '../../models/task_detail'
import { getTaskDetail } from '../../api'
import { JSON } from '@kit.ArkTS'

@Entry
@Component
struct TaskDetail {
  @State title: string = '任务详情'
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  scroller: Scroller = new Scroller()

  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  // 可以通过路由传值获取提货作业的id
  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.getTaskDetail(params.id)
    }
    console.log("TaskDetail aboutToAppear " + JSON.stringify(params.id))
  }

  build() {
    Column() {
      HMNavBar({ title: this.title })
      Scroll(this.scroller) {
        Column() {
          HmToggleCard({ title: "基本信息" }) {
            Text(JSON.stringify(this.taskDetailData))
          }

          HmToggleCard({ title: "车辆司机信息" }) {
            Text(JSON.stringify(this.taskDetailData))
          }

          HmToggleCard({ title: "运输路线" }) {
            Text(JSON.stringify(this.taskDetailData))
          }
        }
      }
      .padding({ bottom: 120 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))

  }
}

// 获取后端接口数据的标准流程
/*
 * 1.分析接口，接收什么参数，返回什么数据
 * 2.定义相关的数据类型
 * 3.封装api接口调用
 * 4.获取数据
 * 5.显示
 *
 * */
