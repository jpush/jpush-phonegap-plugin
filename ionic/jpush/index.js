var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
import { Plugin, Cordova, IonicNativePlugin } from '@ionic-native/core';
import { Injectable } from '@angular/core';
var JPush = (function (_super) {
    __extends(JPush, _super);
    function JPush() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    JPush.prototype.init = function () { return; };
    JPush.prototype.setDebugMode = function (enable) { return; };
    JPush.prototype.getRegistrationID = function () { return; };
    JPush.prototype.stopPush = function () { return; };
    JPush.prototype.resumePush = function () { return; };
    JPush.prototype.isPushStopped = function () { return; };
    JPush.prototype.setTags = function (params) { return; };
    JPush.prototype.addTags = function (params) { return; };
    JPush.prototype.deleteTags = function (params) { return; };
    JPush.prototype.cleanTags = function (params) { return; };
    JPush.prototype.getAllTags = function (params) { return; };
    /**
     * @param params { sequence: number, tag: string }
     */
    JPush.prototype.checkTagBindState = function (params) { return; };
    JPush.prototype.setAlias = function (params) { return; };
    JPush.prototype.deleteAlias = function (params) { return; };
    JPush.prototype.getAlias = function (params) { return; };
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
    JPush.prototype.getUserNotificationSettings = function () { return; };
    JPush.prototype.clearLocalNotifications = function () { return; };
    // iOS API - start
    JPush.prototype.setBadge = function (badge) { return; };
    JPush.prototype.resetBadge = function () { return; };
    JPush.prototype.setApplicationIconBadgeNumber = function (badge) { return; };
    JPush.prototype.getApplicationIconBadgeNumber = function () { return; };
    JPush.prototype.addLocalNotificationForIOS = function (delayTime, content, badge, identifierKey, extras) { return; };
    JPush.prototype.deleteLocalNotificationWithIdentifierKeyInIOS = function (identifierKey) { return; };
    JPush.prototype.addDismissActions = function (actions, categoryId) { return; };
    JPush.prototype.addNotificationActions = function (actions, categoryId) { return; };
    JPush.prototype.setLocation = function (latitude, longitude) { return; };
    JPush.prototype.startLogPageView = function (pageName) { return; };
    JPush.prototype.stopLogPageView = function (pageName) { return; };
    JPush.prototype.beginLogPageView = function (pageName, duration) { return; };
    // iOS API - end
    // Android API - start
    JPush.prototype.getConnectionState = function () { return; };
    JPush.prototype.setBasicPushNotificationBuilder = function () { return; };
    JPush.prototype.setCustomPushNotificationBuilder = function () { return; };
    JPush.prototype.clearAllNotification = function () { return; };
    JPush.prototype.clearNotificationById = function (id) { return; };
    JPush.prototype.setLatestNotificationNum = function (num) { return; };
    JPush.prototype.addLocalNotification = function (builderId, content, title, notificationId, broadcastTime, extras) { return; };
    JPush.prototype.removeLocalNotification = function (notificationId) { return; };
    JPush.prototype.reportNotificationOpened = function (msgId) { return; };
    JPush.prototype.requestPermission = function () { return; };
    JPush.prototype.setSilenceTime = function (startHour, startMinute, endHour, endMinute) { return; };
    JPush.prototype.setPushTime = function (weekdays, startHour, endHour) { return; };
    // Android API - end
    JPush.decorators = [
        { type: Injectable },
    ];
    /** @nocollapse */
    JPush.ctorParameters = function () { return []; };
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "init", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Boolean]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setDebugMode", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "getRegistrationID", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "stopPush", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "resumePush", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "isPushStopped", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setTags", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "addTags", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "deleteTags", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "cleanTags", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "getAllTags", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "checkTagBindState", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setAlias", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "deleteAlias", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "getAlias", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "getUserNotificationSettings", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "clearLocalNotifications", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setBadge", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "resetBadge", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setApplicationIconBadgeNumber", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "getApplicationIconBadgeNumber", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number, String, Number, String, Object]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "addLocalNotificationForIOS", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [String]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "deleteLocalNotificationWithIdentifierKeyInIOS", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Array, String]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "addDismissActions", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Array, String]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "addNotificationActions", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number, Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setLocation", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [String]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "startLogPageView", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [String]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "stopLogPageView", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [String, Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "beginLogPageView", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "getConnectionState", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setBasicPushNotificationBuilder", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setCustomPushNotificationBuilder", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "clearAllNotification", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "clearNotificationById", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setLatestNotificationNum", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number, String, String, Number, Number, String]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "addLocalNotification", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "removeLocalNotification", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "reportNotificationOpened", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "requestPermission", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number, Number, Number, Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setSilenceTime", null);
    __decorate([
        Cordova(),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Array, Number, Number]),
        __metadata("design:returntype", Promise)
    ], JPush.prototype, "setPushTime", null);
    JPush = __decorate([
        Plugin({
            pluginName: 'JPush',
            plugin: 'jpush-phonegap-plugin',
            pluginRef: 'plugins.jPushPlugin',
            repo: 'https://github.com/jpush/jpush-phonegap-plugin',
            install: 'ionic cordova plugin add jpush-phonegap-plugin --variable APP_KEY=your_app_key',
            installVariables: ['APP_KEY'],
            platforms: ['Android', 'iOS']
        })
    ], JPush);
    return JPush;
}(IonicNativePlugin));
export { JPush };
//# sourceMappingURL=index.js.map