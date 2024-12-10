import { HmLoading, HmSkeleton } from 'swift_common';
import { MessageInfo, MessageParams, MessageParamsModel } from '../../../../models';
import { vibrator } from '@kit.SensorServiceKit';
import { Annoucements } from './Annoucements';
import { getMessage, getRead, getReadOnly } from '../../../../api';

// 公告栏
@Component
export struct Bulletin {
  @State messageList: MessageInfo[] = [];
  @State queryParams: MessageParams = new MessageParamsModel({
    contentType: '200', // 公告类型
    page: 1, // 页码
    pageSize: 2 // 每页条数
  });
  allPage: number = 1; // 总页数
  @State loading: boolean = false; // 是否正在加载数据
  @State refreshing: boolean = false; // 是否正在刷新数据
  @State str: string = '下拉刷新'; // 刷新提示语
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive; // 刷新状态
  @State reset: boolean = false; // 是否重置查询条件

  layer: CustomDialogController = new CustomDialogController({
    builder: HmLoading({ loadingText: '正在搜索中，请稍后...' }),
    customStyle: true, // 自定义样式
    autoCancel: true, // 自动取消
    alignment: DialogAlignment.Center // 居中显示
  }); // 弹窗控制器

  // 获取任务列表数据
  async getMessageList(isAppend: boolean) {
    const result = await getMessage(this.queryParams); // 获取数据
    this.allPage = parseInt(result.pages); // 总页数
    if (isAppend) {
      this.messageList = [...this.messageList, ...(result.items || [])]; // 合并数据
    } else {
      this.messageList = result.items || []; // 更新数据
    }
    this.queryParams.page++;
  }

  // 获取底部显示
  @Builder
  getBottomDisplay() {
    Row() {
      if (this.loading) {
        Text(this.allPage < this.queryParams.page ? '没有更多数据了' : '正在加载...')
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'));
        if (this.allPage >= this.queryParams.page) {
          HmLoading({ hWidth: 20 });
        }
      }
    }
    .width('100%')
      .height(50)
      .justifyContent(FlexAlign.Center);
  }

  // 刷新数据
  async onRefresh() {
    this.refreshing = true;
    this.messageList = [];
    this.queryParams.page = 1;
    this.allPage = 1;
    await this.getMessageList(false);
    this.refreshing = false;
    this.loading = false;
  }

  // 获取刷新状态
  getStatusText() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return '下拉刷新';
      case RefreshStatus.OverDrag:
        return '超过刷新距离，松开立即刷新';
      case RefreshStatus.Refresh:
        return '正在刷新...';
      case RefreshStatus.Done:
        return '刷新完成';
      default:
        return '';
    }
  }

  // 获取刷新提示语
  @Builder
  getRefreshDisplay() {
    Row({ space: 10 }) {
      LoadingProgress()
        .width(40)
        .aspectRatio(1)
        .color($r('app.color.text_secondary'));
      Text(this.getStatusText())
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'));
    }
    .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center);
  }

  // 清空已读
  async onFlush() {
    try {
      await getRead('201');
      this.messageList = this.messageList.map(item => {
        item.isRead = 1
        return item
      })
    } catch (e) {
      console.error(e);
    }
  }

  // 读取单个内容
  async onReadOnly(item: MessageInfo) {
    try {
      await getReadOnly(item.id);
      item.isRead = 1;
      this.messageList = [...this.messageList];
    } catch (e) {
      console.error(e);
    }
  }

  build() {
    Column() {
      Row({ space: 5 }) {
        Image($r('app.media.ic_yidu'))
          .width(24).height(24);
        Text('全部已读')
          .fontColor($r('app.color.text_primary'))
          .fontSize(14);
      }
      .onClick(() => this.onFlush())
      .height(40).width('100%');

      Refresh({ refreshing: $$this.refreshing, builder: this.getRefreshDisplay() }) {
        List() {
          if (this.messageList.length === 0) {
            HmSkeleton();
          } else {
            ForEach(this.messageList, (item: MessageInfo, index: number) => {
              ListItem() {
                Annoucements({
                  messageInfoModel: item,
                  onRecord: () => {
                    this.onFlush()
                  },
                  onReadOnly: () => {
                    this.onReadOnly(item)
                  }
                });
              }
            });

            ListItem() {
              this.getBottomDisplay();
            }
          }
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off) // 关闭滚动条
        .onReachEnd(async () => {
          if (this.allPage >= this.queryParams.page) {
            if (!this.loading) {
              this.loading = true;
              await this.getMessageList(true);
              this.loading = this.allPage < this.queryParams.page;
            }
          }
        });
      }
      .onStateChange((status: RefreshStatus) => {
        this.refreshStatus = status;
        switch (status) {
          case RefreshStatus.Drag:
            this.str = '下拉刷新';
            break;
          case RefreshStatus.OverDrag:
            this.str = '超过刷新距离，松开立即刷新';
            break;
          case RefreshStatus.Refresh:
            this.str = '正在刷新...';
            this.onRefresh();
            vibrator.startVibration({ duration: 300, type: 'time' }, { id: 0, usage: "touch" });
            break;
          case RefreshStatus.Done:
            this.str = '刷新完成';
            break;
          default:
            break;
        }
      });
    }
    .width('100%')
      .height('100%')
  }
}