//
//  ConstantDef.h
//  jmessage
//
//  Created by ljg on 16/1/19.
//
//

#ifndef ConstantDef_h
#define ConstantDef_h



#endif /* ConstantDef_h */

#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

static NSString *const JPushConfig_FileName     = @"JPushConfig";
static NSString *const JPushConfig_Appkey       = @"Appkey";
static NSString *const JPushConfig_Channel      = @"Channel";
static NSString *const JPushConfig_IsProduction = @"IsProduction";
static NSString *const JPushConfig_IsIDFA       = @"IsIDFA";
static NSString *const JPushConfig_Delay        = @"Delay";

static NSString *const JPushDocumentEvent_ReceiveNotification       = @"receiveNotification";
static NSString *const JPushDocumentEvent_OpenNotification          = @"openNotification";
static NSString *const JPushDocumentEvent_BackgroundNotification    = @"backgroundNotification";
static NSString *const JPushDocumentEvent_SetTagsWithAlias          = @"setTagsWithAlias";
static NSString *const JPushDocumentEvent_ReceiveMessage            = @"receiveMessage";
static NSString *const JPushDocumentEvent_ReceiveLocalNotification  = @"receiveLocalNotification";

static NSString *const JPushDocumentEvent_receiveRegistrationId     = @"receiveRegistrationId";
