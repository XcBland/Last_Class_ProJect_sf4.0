import { TaskNofityDetail } from "./TaskNofityDetail"

@Component
export struct TaskNotify {
  build() {
    Column() {
      TaskNofityDetail()
    }
    .width("100%")
    .height("100%")
    .backgroundColor($r('app.color.background_page'))
  }
}