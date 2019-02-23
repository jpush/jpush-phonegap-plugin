import { IonicNativePlugin } from '@ionic-native/core';
export interface TagOptions {
    sequence: number;
    tags?: Array<string>;
}
export interface AliasOptions {
    sequence: number;
    alias?: string;
}
/**
 * @name jpush
 * @description
 * This plugin does something
 *
 * @usage
 * ```typescript
 * import { jpush } from '@ionic-native/jpush';
 *
 *
 * constructor(private jpush: jpush) { }
 *
 * ...
 *
 *
 * this.jpush.functionName('Hello', 123)
 *   .then((res: any) => console.log(res))
 *   .catch((error: any) => console.error(error));
 *
 * ```
 */
export declare class JPush extends IonicNativePlugin {
    /**
     * This function does something
     * @param arg1 {string} Some param to configure something
     * @param arg2 {number} Another param to configure something
     * @return {Promise<any>} Returns a promise that resolves when something happens
     */
    functionName(arg1: string, arg2: number): Promise<any>;
    init(): void;
    setDebugMode(enable: boolean): void;
    getRegistrationID(): Promise<any>;
    stopPush(): Promise<any>;
    resumePush(): Promise<any>;
    isPushStopped(): Promise<any>;
    setTags(params: TagOptions): Promise<any>;
    addTags(params: TagOptions): Promise<any>;
    deleteTags(params: TagOptions): Promise<any>;
    cleanTags(params: TagOptions): Promise<any>;
    getAllTags(params: TagOptions): Promise<any>;
    /**
     * @param params { sequence: number, tag: string }
     */
    checkTagBindState(params: object): Promise<any>;
    setAlias(params: AliasOptions): Promise<any>;
    deleteAlias(params: AliasOptions): Promise<any>;
    getAlias(params: AliasOptions): Promise<any>;
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
    getUserNotificationSettings(): Promise<any>;
    clearLocalNotifications(): Promise<any>;
    setBadge(badge: number): void;
    resetBadge(): void;
    setApplicationIconBadgeNumber(badge: number): void;
    getApplicationIconBadgeNumber(): Promise<any>;
    addLocalNotificationForIOS(delayTime: number, content: string, badge: number, identifierKey: string, extras?: object): void;
    deleteLocalNotificationWithIdentifierKeyInIOS(identifierKey: string): void;
    addDismissActions(actions: Array<object>, categoryId: string): void;
    addNotificationActions(actions: Array<object>, categoryId: string): void;
    setLocation(latitude: number, longitude: number): void;
    startLogPageView(pageName: string): void;
    stopLogPageView(pageName: string): void;
    beginLogPageView(pageName: string, duration: number): void;
    getConnectionState(): Promise<any>;
    setBasicPushNotificationBuilder(): Promise<any>;
    setCustomPushNotificationBuilder(): Promise<any>;
    clearAllNotification(): Promise<any>;
    clearNotificationById(id: number): Promise<any>;
    setLatestNotificationNum(num: number): Promise<any>;
    addLocalNotification(builderId: number, content: string, title: string, notificationId: number, broadcastTime: number, extras?: string): Promise<any>;
    removeLocalNotification(notificationId: number): Promise<any>;
    reportNotificationOpened(msgId: number): Promise<any>;
    requestPermission(): Promise<any>;
    setSilenceTime(startHour: number, startMinute: number, endHour: number, endMinute: number): Promise<any>;
    setPushTime(weekdays: Array<string>, startHour: number, endHour: number): Promise<any>;
}
