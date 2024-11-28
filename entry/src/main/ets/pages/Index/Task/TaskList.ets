import { getTaskList } from '../../../api'
import { HmSkeleton } from '../../../components'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import { TaskItemCard } from './TaskItemCard'
import { promptAction } from '@kit.ArkUI'

@Component
export struct TaskList {
  @State taskListData: TaskInfoItem[] = [] //返回的数据类型
  @State queryParams: TaskListParams = new TaskListParamsModel({
    status: TaskTypeEnum.WAITING,
    page: 1,
    pageSize: 5
  } as TaskListParams) //查询的参数
  allPage: number = 1 //总页数
  currentPage: number = 1 //当前页数
  loading: boolean = false //是否正在加载数据

  //获取任务列表数据
  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    this.taskListData = this.taskListData.concat(result.items) //合并数据
    this.queryParams.page++
    this.allPage = result.pages //总页数
    this.currentPage = this.queryParams.page //当前页数

  }

  // aboutToAppear(): void {
  //   this.getTaskList()
  // }

  build() {
    List() {
      if (this.taskListData.length === 0) {
        HmSkeleton()
      } else {
        ForEach(this.taskListData, (item: TaskInfoItemModel, index: number) => {
          ListItem() {
            TaskItemCard({ taskItemData: item })
          }
        })
      }


    }
    .onReachEnd(async () => {
      // this.queryParams.page++

      if (this.allPage >= this.currentPage) {
        if (!this.loading) {
          this.loading = true //开始加载数据
          await this.getTaskList()
          this.loading = false //加载完成
        }
      } else {
        this.loading = false
        promptAction.showToast({ message: '没有更多数据了' })
      }
    })
  }
}

//获取后端接口数据的标准流程：
//1.分析接口，接收什么参数、返回什么参数
//2.定义相关的数据类型
//3.封装api接口调用
//4.获取数据
//5.显示数据