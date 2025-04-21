import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { BaseListItem } from '../../comm/BaseListItem';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@kit.BasicServicesKit';
import BuildProfile from 'BuildProfile';
import hilog from '@ohos.hilog';
import { rcp } from "@kit.RemoteCommunicationKit";
import {  http } from '@kit.NetworkKit';
import fs from '@ohos.file.fs';
import json from '@ohos.util.json';

@Preview
@Component
export default struct BasicKnowledgePage {
  build() {
    Column() {
      Flex({ wrap: FlexWrap.Wrap, }) {
        BaseListItem({ label: '基础', path: 'pages/basic_knowledge/Base' })
        BaseListItem({ label: '生命周期', path: 'pages/basic_knowledge/LifeCirclePage' })
        BaseListItem({ label: '参数传递', path: 'pages/basic_knowledge/AboutParams' })
        BaseListItem({ label: '构建参数', path: 'pages/basic_knowledge/AboutBuildParams' })
        BaseListItem({ label: '@Styles装饰器', path: 'pages/basic_knowledge/AboutStyleAnno' })
        BaseListItem({ label: '@Extend装饰器', path: 'pages/basic_knowledge/AboutExtendAnno' })
        BaseListItem({ label: '@stateStyles', path: 'pages/basic_knowledge/AboutStateStyles' })
        BaseListItem({ label: '状态管理', path: 'pages/basic_knowledge/AboutStateManagement' })
        BaseListItem({ label: '通知', path: 'pages/basic_knowledge/NotificationPage' })

        Button() {
          Text('打开 UIAbility').fontSize(18)
            .padding(10)
        }
        .type(ButtonType.Normal)
        .borderRadius(10)
        .margin(10)
        .backgroundColor($r('app.color.green_39d169'))
        .onClick(() => {
          let context = getContext(this) as common.UIAbilityContext;
          let want: Want = {
            deviceId: '', // deviceId为空表示本设备
            bundleName: 'com.huangyuanlove.arkui_demo',
            abilityName: 'SecondAbility',
            moduleName: 'entry', // moduleName非必选
            parameters: {
              // 自定义信息
              info: '来自EntryAbility Index页面',
            },
          }
          //不接受返回结果，类似 Android startActivity
          // context.startAbility(want).then(()=>{
          //
          // }).catch((err)=>{
          //
          // })

          //接受返回结果 类似 Android startActivityForResult
          context.startAbilityForResult(want).then((data) => {
            if (data?.resultCode === 10001) {
              // 解析被调用方UIAbility返回的信息
              let info = data.want?.parameters?.info
            }
          }).catch((err: BusinessError) => {
            console.error(`startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
          })

        })

        Button("webview").onClick(() => {
          router.pushUrl({ url: "WebViewPage", params: { path: "https://www.chunyuyisheng.com" } })
        })

        Button('打开 feature hap').onClick((_)=>{
            let context = getContext(this) as common.UIAbilityContext
          context.startAbility({
            bundleName:BuildProfile.BUNDLE_NAME,
            abilityName:'FeatureHapAbility'
          }).then(()=>{
            hilog.error(0x01,'BasicKnowledgePage','BasicKnowledgePage 打开 feature hap')
          })
        })

        Button('charles抓包 rcp').onClick((_)=>{
          const session = rcp.createSession();
          const request = new rcp.Request('https://biztest.chunyutianxia.com/user_operation/app_interface/home_page/?app=0&platform=android&systemVer=10&version=10.6.12&app_ver=Build+10.6.12.250402&cyudId=53f38352-da64-4dac-b4e0-1b0cc681f6a0&secureId=e9ddd1fd-fffe-8a9f-57f7-defffdca8058&installId=1742785027244&phoneType=COL-AL10_by_HUAWEI&vendor=chunyu&screen_height=2060&screen_width=1080','GET');
          request.configuration = {
            security: {
              remoteValidation: 'skip',
            },
          };
          session.fetch(request).then((rep: rcp.Response) => {
            console.info(`Response succeeded: ${rep}`);
          }).catch((err: BusinessError) => {
            console.error(`Response err: Code is ${err.code}, message is ${err.message}`);
          });
        });

        Button('charles抓包 http').onClick((_)=>{


          let httpRequest = http.createHttp();
          httpRequest.request(
            // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
            "https://biztest.chunyutianxia.com/user_operation/app_interface/home_page/?app=0&platform=android&systemVer=10&version=10.6.12&app_ver=Build+10.6.12.250402&cyudId=53f38352-da64-4dac-b4e0-1b0cc681f6a0&secureId=e9ddd1fd-fffe-8a9f-57f7-defffdca8058&installId=1742785027244&phoneType=COL-AL10_by_HUAWEI&vendor=chunyu&screen_height=2060&screen_width=1080",
            {
              method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
              // 开发者根据自身业务需要添加header字段
              header: {
                'Content-Type': 'application/x-www-form-urlencoded'
              },

              expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
              priority: 1, // 可选，默认为1
              connectTimeout: 60000, // 可选，默认为60000ms
              readTimeout: 60000, // 可选，默认为60000ms
              usingProxy: true, // 可选，默认不使用网络代理，自API 10开始支持该属性
              // caPath:filePath

            }, (err: BusinessError, data: http.HttpResponse) => {
            if (!err) {
              // data.result为HTTP响应内容，可根据业务需要进行解析
              console.info('Result:' + JSON.stringify(data.result));
              console.info('code:' + JSON.stringify(data.responseCode));
              // data.header为HTTP响应头，可根据业务需要进行解析
              console.info('header:' + JSON.stringify(data.header));
              console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
              // 当该请求使用完毕时，调用destroy方法主动销毁
              httpRequest.destroy();
            } else {
              console.error('error:' + JSON.stringify(err));

              // 当该请求使用完毕时，调用destroy方法主动销毁
              httpRequest.destroy();
              console.error("flutter 鸿蒙打点：")
            }
          }
          );

        })



      }.width('100%').height('100%').padding({ top: 48 })

    }
  }
}