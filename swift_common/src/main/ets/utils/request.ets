import { BASE_URL } from '../constants/url_var';
import { http } from '@kit.NetworkKit';
import { TOKEN_KEY } from '../constants';
import { promptAction, router } from '@kit.ArkUI';
import { UserSettingClass } from '.';
import { ResponseData } from '../models';
import axios, { AxiosRequestConfig, AxiosResponse, Method } from '@ohos/axios';


/*
 * 封装网络请求的工具
 * 实现网络请求的方法
 */
/*export async function requestHttp<T>(url: string = "",
  method: http.RequestMethod = http.RequestMethod.GET,
  data?: object): Promise<T> {
  let urlStr = BASE_URL + url //拼接完整的url作为请求的地址
  */
/*
   * 发送请求的方式: GET, POST, PUT(修改/新增), DELETE(删除)
   *  如果发送的是POST请求,携带的数据需要在extraData中设置
   *  如果发送的是GET请求,携带的数据需要在url中设置 例如: http://www.example.com/getData?id=123
   */
/*
  // 如果今后是GET请求方式,需要处理请求的参数
  if (method === http.RequestMethod.GET) {
    if (data && Object.keys(data).length > 0) {
      urlStr += '?' + Object.keys(data).map(key => {
        if (data[key]) {
          return `${key}=${data[key]}`
        }
        return ''

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

  // 3. 发送请求
  try {
    const res = await httpRequest.request(urlStr, config)
    // 解析结果
    // 需要在请求发送争取的情况下,才需要进行结果的解析
    if (res.responseCode === 401) {
      // 401 未授权，需要重新登录
      promptAction.showToast({ message: '未授权或Token过期，请重新登录' })
      AppStorage.set(TOKEN_KEY, '') // 清空用户令牌
      new UserSettingClass(getContext()).setUserToken('')
      console.log("401==>"+JSON.stringify(res))
      return Promise.reject(new Error('未授权或Token过期，请重新登录'))
    } else if (res.responseCode === 404) {
      promptAction.showToast({ message: '服务器请求的资源不存在/地址错误' })
      return Promise.reject(new Error('服务器请求的资源不存在/地址错误'))
    } else if (res.responseCode === 500) {
      promptAction.showToast({ message: '服务器内部错误' })
      return Promise.reject(new Error('服务器内部错误'))
    } else {
      // 成功的请求,返回结果
      const result = JSON.parse(res.result as string) as ResponseData<T>
      if(result.code ===200){
          return result.data as T
        }else{
          promptAction.showToast({ message: result.message })
        return Promise.reject(new Error(result.message))
      }

    }
  } catch (e) {
    promptAction.showToast({ message: JSON.stringify(e) })
    return Promise.reject(e)
  } finally {
    // 4.关闭请求
    httpRequest.destroy()

  }
}*/

export async function requestHttp<T>(url: string = "",
  method: Method = 'get',
  data?: object): Promise<T> {
  // if (method === 'get') {
  //   if (data && Object.keys(data).length > 0) {
  //     url += '?' + Object.keys(data).map(key => {
  //       if (data[key]) {
  //         return `${key}=${data[key]}`
  //       }
  //       return ''
  //
  //     }).join('&')
  //   }
  // }
  // const urlStr = BASE_URL + url
  // 1.创建请求
  const axiosRequest = axios.create({
    baseURL: BASE_URL,

  })
  // 2.设置请求头
  const config: AxiosRequestConfig = {
    url,
    method,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': AppStorage.get<string>(TOKEN_KEY) || ''  // ||===??
    },
    params: method === 'get' ? data : null, // (第二种)
    data: method !== 'get' ? data : null, // get请求需要单独设置请求参数
  }
  try {
    // 3. 发送请求
    const res: AxiosResponse<ResponseData<T>> = await axiosRequest.request(config)
    switch (res.status) {
      case 401:
        promptAction.showToast({ message: '未授权或Token过期，请重新登录' });
        AppStorage.set(TOKEN_KEY, ''); // 清空用户令牌
        new UserSettingClass(getContext()).setUserToken('');
        console.log("401==>" + JSON.stringify(res));
        router.replaceUrl({ url: 'pages/Login/Login' })
        return Promise.reject(new Error('未授权或Token过期，请重新登录'));
      case 404:
        promptAction.showToast({ message: '服务器请求的资源不存在/地址错误' });
        return Promise.reject(new Error('服务器请求的资源不存在/地址错误'));
      case 500:
        promptAction.showToast({ message: '服务器内部错误' });
        return Promise.reject(new Error('服务器内部错误'));
      default:
        if (res.data.code === 200) {
          console.log("requestSuccess==>" + JSON.stringify(res.data))
          return res.data.data as T;
        } else {
          promptAction.showToast({ message: res.data.message });
          return Promise.reject(new Error(res.data.message));
        }

    }

  } catch (e) {
    promptAction.showToast({ message: JSON.stringify(e) })
    console.log("requestError==>" + JSON.stringify(e))
    return Promise.reject(e)

  }
  // 4.关闭请求
  finally {
    axiosRequest.delete(url, config)
  }

}


/*export class Request{
  static get<T>(url: string, data?: object):Promise<T>{
    return requestHttp<T>(url, http.RequestMethod.GET, data)
  }
  static post<T>(url: string, data?: object):Promise<T>{
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }
  static put<T>(url: string, data?: object):Promise<T>{
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
  static delete<T>(url: string, data?: object):Promise<T>{
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }
}*/

export class Request {
  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'get', data)
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'post', data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'put', data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'delete', data)
  }
}