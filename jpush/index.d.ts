import { IonicNativePlugin } from '@ionic-native/core';
export declare class JPush extends IonicNativePlugin {
    init(): Promise<any>;
    setDebugMode(enable: boolean): Promise<any>;
    getRegistrationID(): Promise<any>;
    stopPush(): Promise<any>;
    resumePush(): Promise<any>;
    isPushStopped(): Promise<any>;
    /**
     * @param params { sequence: number, tags: [string, string] }
     */
    setTags(params: object): Promise<any>;
    /**
     * @param params { sequence: number, tags: [string, string] }
     */
    addTags(params: object): Promise<any>;
    /**
     * @param params { sequence: number, tags: [string, string] }
     */
    deleteTags(params: object): Promise<any>;
    /**
     * @param params { sequence: number }
     */
    cleanTags(params: object): Promise<any>;
    /**
     * @param params { sequence: number }
     */
    getAllTags(params: object): Promise<any>;
    /**
     * @param params { sequence: number, tag: string }
     */
    checkTagBindState(params: object): Promise<any>;
    /**
     * @param params { sequence: number, alias: string }
     */
    setAlias(params: object): Promise<any>;
    /**
     * @param params { sequence: number }
     */
    deleteAlias(params: object): Promise<any>;
    /**
     * @param params { sequence: number }
     */
    getAlias(params: object): Promise<any>;
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
    setBadge(badge: number): Promise<any>;
    resetBadge(): Promise<any>;
    setApplicationIconBadgeNumber(badge: number): Promise<any>;
    getApplicationIconBadgeNumber(): Promise<any>;
    addLocalNotificationForIOS(delayTime: number, content: string, badge: number, notificationId: number, extras: string): Promise<any>;
    deleteLocalNotificationWithIdentifierKeyInIOS(identifierKey: string): Promise<any>;
    addDismissActions(actions: Array<object>, categoryId: string): Promise<any>;
    addNotificationActions(actions: Array<object>, categoryId: string): Promise<any>;
    setLocation(latitude: number, longitude: number): Promise<any>;
    startLogPageView(pageName: string): Promise<any>;
    stopLogPageView(pageName: string): Promise<any>;
    beginLogPageView(pageName: string, duration: number): Promise<any>;
    getConnectionState(): Promise<any>;
    setBasicPushNotificationBuilder(): Promise<any>;
    setCustomPushNotificationBuilder(): Promise<any>;
    clearAllNotification(): Promise<any>;
    clearNotificationById(id: number): Promise<any>;
    setLatestNotificationNum(num: number): Promise<any>;
    addLocalNotification(builderId: number, content: string, title: string, notificationId: number, broadcastTime: number, extras: string): Promise<any>;
    removeLocalNotification(notificationId: number): Promise<any>;
    reportNotificationOpened(msgId: number): Promise<any>;
    requestPermission(): Promise<any>;
    setSilenceTime(startHour: number, startMinute: number, endHour: number, endMinute: number): Promise<any>;
    setPushTime(weekdays: Array<string>, startHour: number, endHour: number): Promise<any>;
}
