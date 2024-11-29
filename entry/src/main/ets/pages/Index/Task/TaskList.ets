import { getTaskList } from '../../../api'
import { HmLoading, HmSkeleton } from '../../../components'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import { TaskItemCard } from './TaskItemCard'

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
  @State refreshing: boolean = false //是否正在刷新数据
  @State str: string = '下拉刷新' //刷新提示语
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive //刷新状态

  // @State status: RefreshStatus = RefreshStatus.Inactive //刷新状态

  //获取任务列表数据
  async getTaskList(append: boolean) {
    const result = await getTaskList(this.queryParams)
    this.allPage = result.pages //总页数
    if (append) {
      this.taskListData = this.taskListData.concat(result.items) //合并数据
    } else {
      this.taskListData = result.items //更新数据
    }
    this.queryParams.page++
    append = true

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

  /*刷新数据*/
  onRefresh() {
    // this.getRefreshDisplay()
    this.refreshing = true
    this.taskListData = []
    this.queryParams.page = 1
    this.allPage = 1
    this.getTaskList(false)
    setTimeout(() => {
      this.refreshing = false
      this.loading = false
    }, 1000)

  }

  /*获取刷新状态*/
  getStatusText() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return '下拉刷新'
      case RefreshStatus.OverDrag:
        return '超过刷新距离，松开立即刷新'
      case RefreshStatus.Refresh:
        return '正在刷新...'
      case RefreshStatus.Done:
        return '刷新完成'
      default:
        return ''
    }
  }

  @Builder
  getRefreshDisplay() {
    Row({ space: 10 }) {
      LoadingProgress()
        .width(40)
        .aspectRatio(1)
        .color($r('app.color.text_secondary'))
      Text(this.getStatusText())
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
    }
    .width('100%')
    .height(50)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Refresh({ refreshing: $$this.refreshing, builder: this.getRefreshDisplay() }) {
      List() {
        if (this.taskListData.length === 0) {
          HmSkeleton()
        } else {

          /*          if (this.status === RefreshStatus.Refresh) {
                      ListItem() {
                        Text(this.str)
                          .fontSize(16)
                          .fontWeight(FontWeight.Bold)
                          .fontColor(Color.Gray)
                      }
                    }*/
          // if (this.refreshStatus === RefreshStatus.Refresh) {
          //   this.getRefreshDisplay()
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
      .scrollBar(BarState.Off)
      .onReachEnd(async () => {
        if (this.allPage >= this.queryParams.page) {
          if (!this.loading) {
            this.loading = true //开始加载数据
            await this.getTaskList(true)
            this.loading = this.allPage < this.queryParams.page ? true : false //如果没有更多数据了，则停止加载
          }
        }
      })
    }
    .onStateChange((status: RefreshStatus) => {
      this.refreshStatus = status
      if (status === RefreshStatus.Drag) {
        this.str = '下拉刷新'
      } else if (status === RefreshStatus.OverDrag) {
        this.str = '超过刷新距离，松开立即刷新'
      } else if (status === RefreshStatus.Refresh) {
        this.str = '正在刷新...'
        setTimeout(() => {
          this.onRefresh()
        }, 3000)
      } else if (status === RefreshStatus.Done) {
        this.str = '刷新完成'
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