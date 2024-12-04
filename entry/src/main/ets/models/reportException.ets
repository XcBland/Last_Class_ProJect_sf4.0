import { ImageList } from ".";

export interface reportExceptionParams {
  transportTaskId: string;
  exceptionTime: string
  exceptionPlace: string;
  exceptionType: string
  exceptionDescribe: string;
  exceptionImageList: ImageList[]
}

export class reportExceptionParamsModel {
  transportTaskId: string = "";
  exceptionTime: string = "";
  exceptionPlace: string = "";
  exceptionType: string = "";
  exceptionDescribe: string = "";
  exceptionImageList: ImageList[] = [];

  constructor(model: reportExceptionParams) {
    this.transportTaskId = model.transportTaskId;
    this.exceptionTime = model.exceptionTime;
    this.exceptionPlace = model.exceptionPlace;
    this.exceptionType = model.exceptionType;
    this.exceptionDescribe = model.exceptionDescribe;
    this.exceptionImageList = model.exceptionImageList;
  }
}

export enum ExceptionType {
  TYPE1 = "发动机起动困难",
  TYPE2 = "不着车",
  TYPE3 = "漏油",
  TYPE4 = "漏水",
  TYPE5 = "照明失灵",
  TYPE6 = "有异响",
  TYPE7 = "排烟异常",
  TYPE8 = "温度异常",
  TYPE9 = "其他",
}