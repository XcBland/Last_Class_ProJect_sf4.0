import { getTaskList } from '../../../api'
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

  //获取任务列表数据
  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    this.taskListData = result.items
  }

  aboutToAppear(): void {
    this.getTaskList()
  }

  build() {
    List() {
      ForEach(this.taskListData, (item: TaskInfoItemModel, index: number) => {
        ListItem() {
          TaskItemCard()
        }
      })
    }
  }
}

//获取后端接口数据的标准流程：
//1.分析接口，接收什么参数、返回什么参数
//2.定义相关的数据类型
//3.封装api接口调用
//4.获取数据
//5.显示数据