import { getTaskList } from '../../../api'
import { HmLoading, HmSkeleton } from '../../../components'
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
  @State loading: boolean = false //是否正在加载数据

  //获取任务列表数据
  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    this.taskListData = this.taskListData.concat(result.items) //合并数据
    this.allPage = result.pages //总页数
    this.queryParams.page++
  }

  @Builder
  getBottomDisplay() {
    Row() {
      if (this.loading) {
        Text(this.allPage < this.queryParams.page ? '没有更多数据了' : '正在加载...')
        if (this.allPage >= this.queryParams.page) {
          HmLoading()
        }
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  // @Builder
  // getTopDisplay() {
  //   Row() {
  //     if (!this.loading) {
  //       if (this.queryParams.page === 1 && this.taskListData.length === 0) {
  //         HmLoading()
  //       }
  //     }
  //   }
  // }

  build() {
    List() {
      if (this.taskListData.length === 0) {
        HmSkeleton()
      } else {
        // ListItem() {
        //   this.getTopDisplay()
        // }

        ForEach(this.taskListData, (item: TaskInfoItemModel, index: number) => {
          ListItem() {
            TaskItemCard({ taskItemData: item })
          }
        })

        ListItem() {
          //   列表底部显示加载状态
          this.getBottomDisplay()
        }
      }


    }
    .onReachStart(async () => {
      if (this.queryParams.page > 1) {
        this.queryParams.page = 1
        this.taskListData = []
        await this.getTaskList()
      } else {
        this.loading = true
        await this.getTaskList()
        this.loading = false
      }
    })
    .onReachEnd(async () => {
      if (this.allPage >= this.queryParams.page) {
        if (!this.loading) {
          this.loading = true //开始加载数据
          await this.getTaskList()
          this.loading = this.allPage < this.queryParams.page ? true : false //如果没有更多数据了，则停止加载
        }
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