//
//  testMarvell.h
//  Pods
//
//  Created by mr.cao on 16/11/25.
//
//

#import <Foundation/Foundation.h>

@interface MarvellV2Factory : NSObject
-(void)startSendSSID:(NSString *)currentssid withPassWord:(NSString *)psw;

-(void)stopSend;
@end
