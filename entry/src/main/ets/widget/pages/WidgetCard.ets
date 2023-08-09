@Entry
@Component
struct WidgetCard {
  /*
   * The mini title.
   */
  readonly MINI_TITLE: string = 'Title';

  /*
   * The item title.
   */
  readonly ITEM_TITLE: string = 'Title';

  /*
   * The item content.
   */
  readonly ITEM_CONTENT: string = 'Introduction';

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';

  /*
   * The ability name.
  */
  readonly ABILITY_NAME: string = 'EntryAbility';

  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';

  /*
   * The mini display priority.
   */
  readonly MINI_DISPLAY_PRIORITY: number = 2;

  /*
   * The max line.
   */
  readonly MAX_LINES: number = 1;

  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  /*
   * Image height percentage setting.
   */
  readonly IMAGE_HEIGHT_PERCENT: string = '64%';
  @State mini: boolean = false;

  build() {
    Row() {
      Column() {
        if (this.mini) {
          Column() {
            Text(this.MINI_TITLE)
              .fontSize($r('app.float.mini_title_font_size'))
              .fontColor($r('app.color.mini_text_font_color'))
              .margin({
                left: $r('app.float.mini_title_margin'),
                bottom: $r('app.float.mini_title_margin')
              })
          }
          .width(this.FULL_WIDTH_PERCENT)
          .alignItems(HorizontalAlign.End)
          .backgroundImageSize(ImageSize.Cover)
          .backgroundImage($r("app.media.ic_widget"), ImageRepeat.NoRepeat)
          .displayPriority(this.MINI_DISPLAY_PRIORITY)
        }
        Image($r("app.media.ic_widget"))
          .width(this.FULL_WIDTH_PERCENT)
          .height(this.IMAGE_HEIGHT_PERCENT)
          .objectFit(ImageFit.Fill)
          .borderRadius($r('app.float.image_border_radius'))
        Blank()
        Text(this.ITEM_TITLE)
          .fontSize($r('app.float.normal_title_font_size'))
        Text(this.ITEM_CONTENT)
          .maxLines(this.MAX_LINES)
          .fontSize($r('app.float.normal_content_font_size'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(this.FULL_HEIGHT_PERCENT)
      .alignItems(HorizontalAlign.Start)
      .backgroundColor($r('app.color.start_window_background'))
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .alignItems(VerticalAlign.Top)
    .padding($r('app.float.row_padding'))
    .onClick(() => {
      postCardAction(this, {
        "action": this.ACTION_TYPE,
        "abilityName": this.ABILITY_NAME,
        "params": {
          "message": this.MESSAGE
        }
      });
    })
  }
}