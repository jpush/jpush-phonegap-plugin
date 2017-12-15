import { Plugin, Cordova, IonicNativePlugin } from '@ionic-native/core';
import { Injectable } from '@angular/core';

export interface TagOptions {
  sequence: number;
  tags?: Array<string>;
}

export interface AliasOptions {
  sequence: number;
  alias?: string;
}

@Plugin({
  pluginName: 'JPush',
  plugin: 'jpush-phonegap-plugin',
  pluginRef: 'plugins.jPushPlugin',
  repo: 'https://github.com/jpush/jpush-phonegap-plugin',
  install: 'ionic cordova plugin add jpush-phonegap-plugin --variable APP_KEY=your_app_key',
  installVariables: ['APP_KEY'],
  platforms: ['Android', 'iOS']
})
@Injectable()
export class JPush extends IonicNativePlugin {

  @Cordova()
  init(): Promise<any> { return; }

  @Cordova()
  setDebugMode(enable: boolean): Promise<any> { return; }

  @Cordova()
  getRegistrationID(): Promise<any> { return; }

  @Cordova()
  stopPush(): Promise<any> { return; }

  @Cordova()
  resumePush(): Promise<any> { return; }

  @Cordova()
  isPushStopped(): Promise<any> { return; }

  @Cordova()
  setTags(params: TagOptions): Promise<any> { return; }

  @Cordova()
  addTags(params: TagOptions): Promise<any> { return; }

  @Cordova()
  deleteTags(params: TagOptions): Promise<any> { return; }

  @Cordova()
  cleanTags(params: TagOptions): Promise<any> { return; }

  @Cordova()
  getAllTags(params: TagOptions): Promise<any> { return; }

  /**
   * @param params { sequence: number, tag: string }
   */
  @Cordova()
  checkTagBindState(params: object): Promise<any> { return; }

  @Cordova()
  setAlias(params: AliasOptions): Promise<any> { return; }

  @Cordova()
  deleteAlias(params: AliasOptions): Promise<any> { return; }

  @Cordova()
  getAlias(params: AliasOptions): Promise<any> { return; }

  /**
   * Determinate whether the application notification has been opened.
   * 
   * iOS: 0: closed; >1: opened.
   *  UIRemoteNotificationTypeNone = 0,
   *  UIRemoteNotificationTypeBadge = 1 << 0,
   *  UIRemoteNotificationTypeSound = 1 << 1,
   *  UIRemoteNotificationTypeAlert = 1 << 2,
   *  UIRemoteNotificationTypeNewsstandContentAvailability = 1 << 3
   * 
   * Android: 0: closed; 1: opened.
   */
  @Cordova()
  getUserNotificationSettings(): Promise<any> { return; }

  @Cordova()
  clearLocalNotifications(): Promise<any> { return; }

  // iOS API - start

  @Cordova()
  setBadge(badge: number): Promise<any> { return; }

  @Cordova()
  resetBadge(): Promise<any> { return; }

  @Cordova()
  setApplicationIconBadgeNumber(badge: number): Promise<any> { return; }

  @Cordova()
  getApplicationIconBadgeNumber(): Promise<any> { return; }

  @Cordova()
  addLocalNotificationForIOS(delayTime: number, content: string, badge: number, identifierKey: string, extras?: object): Promise<any> { return; }

  @Cordova()
  deleteLocalNotificationWithIdentifierKeyInIOS(identifierKey: string): Promise<any> { return; }

  @Cordova()
  addDismissActions(actions: Array<object>, categoryId: string): Promise<any> { return; }

  @Cordova()
  addNotificationActions(actions: Array<object>, categoryId: string): Promise<any> { return; }

  @Cordova()
  setLocation(latitude: number, longitude: number): Promise<any> { return; }

  @Cordova()
  startLogPageView(pageName: string): Promise<any> { return; }

  @Cordova()
  stopLogPageView(pageName: string): Promise<any> { return; }

  @Cordova()
  beginLogPageView(pageName: string, duration: number): Promise<any> { return; }

  // iOS API - end

  // Android API - start

  @Cordova()
  getConnectionState(): Promise<any> { return; }

  @Cordova()
  setBasicPushNotificationBuilder(): Promise<any> { return; }

  @Cordova()
  setCustomPushNotificationBuilder(): Promise<any> { return; }

  @Cordova()
  clearAllNotification(): Promise<any> { return; }

  @Cordova()
  clearNotificationById(id: number): Promise<any> { return; }

  @Cordova()
  setLatestNotificationNum(num: number): Promise<any> { return; }

  @Cordova()
  addLocalNotification(builderId: number, content: string, title: string, notificationId: number, broadcastTime: number, extras?: string): Promise<any> { return; }

  @Cordova()
  removeLocalNotification(notificationId: number): Promise<any> { return; }

  @Cordova()
  reportNotificationOpened(msgId: number): Promise<any> { return; }

  @Cordova()
  requestPermission(): Promise<any> { return; }

  @Cordova()
  setSilenceTime(startHour: number, startMinute: number, endHour: number, endMinute: number): Promise<any> { return; }

  @Cordova()
  setPushTime(weekdays: Array<string>, startHour: number, endHour: number): Promise<any> { return; }

  // Android API - end
}
