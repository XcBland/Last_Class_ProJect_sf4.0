import { BASE_URL } from '../constants/url_var';
import { http } from '@kit.NetworkKit';
import { TOKEN_KEY } from '../constants';

/*
 * 封装网络请求的工具
 * 实现网络请求的方法
 */
export function requestHttp(url: string = "",
  method: http.RequestMethod = http.RequestMethod.GET,
  data?: object) {
  let urlStr = BASE_URL + url //拼接完整的url作为请求的地址
  /*
   * 发送请求的方式: GET, POST, PUT(修改/新增), DELETE(删除)
   *  如果发送的是POST请求,携带的数据需要在extraData中设置
   *  如果发送的是GET请求,携带的数据需要在url中设置 例如: http://www.example.com/getData?id=123
   */
  // 如果今后是GET请求方式,需要处理请求的参数
  if (method === http.RequestMethod.GET) {
    if (data && Object.keys(data).length > 0) {
      urlStr += '?' + Object.keys(data).map(key => {
        if (data[key]) {
          return `${key}=${data[key]}`
        } else {
          return ''
        }
      }).join('&')
    }
  }
  // 1.创建请求
  const httpRequest = http.createHttp()

  // 2.设置请求头
  const config: http.HttpRequestOptions = {
    header: {
      // 设置请求的数据类型
      'Content-Type': 'application/json',
      // 获取用户令牌，因为用户登录成功后，令牌是存在PersistentStorage中的
      'Authorization': AppStorage.get<string>(TOKEN_KEY) || ''  // ||===??
    },
    method,
    extraData: method === http.RequestMethod.GET ? '' : data, // get请求需要单独设置请求参数
  }

  // 3.


}