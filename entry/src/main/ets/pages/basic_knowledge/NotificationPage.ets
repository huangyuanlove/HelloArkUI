import Notification from '@ohos.notificationManager'
import NotificationRequest from '@ohos.notificationManager'
import ActionBar from '../../comm/ActionBar'

@Entry
@Component
struct NotificationPage {
  publishCallback(err) {
    if (err) {
      console.info("publish failed " + JSON.stringify(err));
    } else {
      console.info("publish success");
    }
  }

  build() {
    Column() {
      ActionBar({ title: '通知' })
      Button("普通文本类型").onClick(() => {

        //通知Request对象
        let notificationRequest = {
          id: 1,
          content: {
            contentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: "test_title",
              text: "test_text",
              additionalText: "test_additionalText"
            }
          }
        };
        Notification.publish(notificationRequest, this.publishCallback);
      }).margin(10)
      Button("长文本类型").onClick(() => {
        let notificationRequest = {
          id: 1,
          content: {
            contentType: Notification.ContentType.NOTIFICATION_CONTENT_LONG_TEXT, // 长文本类型通知
            longText: {
              title: 'test_NOTIFICATION_CONTENT_LONG_TEXT_title',
              text: 'test_NOTIFICATION_CONTENT_LONG_TEXT_text',
              additionalText: 'test_NOTIFICATION_CONTENT_LONG_TEXT_additionalText',
              longText: 'test_longTexttest_longTexttest_longTexttest_longTexttest_longTexttest_longText',
              briefText: 'test_briefText',
              expandedTitle: 'test_longText_expandedTitle',
            }
          }
        }
        Notification.publish(notificationRequest, this.publishCallback);
      }).margin(10)
      Button("多行文本类型").onClick(() => {
        let notificationRequest = {
          id: 1,
          content: {
            contentType: Notification.ContentType.NOTIFICATION_CONTENT_MULTILINE, // 多行文本类型通知
            multiLine: {
              title: 'test_title',
              text: 'test_text',
              briefText: 'test_briefText',
              longTitle: 'test_longTitle',
              lines: ['line_01', 'line_02', 'line_03', 'line_04'],
            }
          }
        }

        // 发布通知
        Notification.publish(notificationRequest, this.publishCallback);
      }).margin(10)
      Button("图片类型").onClick(() => {
      }).margin(10)
      Button("取消通知").onClick(() => {

      }).margin(10)
    }
  }
}