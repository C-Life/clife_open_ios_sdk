//
//  HETFileInfo.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/5/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//  文件上传

#import <Foundation/Foundation.h>

@interface HETFileInfo : NSObject

/**
 *  文件上传
 *
 *  @param key      后台指定的这个文件上传的key
 *  @param filename 文件名字
 *  @param mimeType 文件类型
 *  @param data     文件二进制数据
 *
 *  @return
 */
- (id)initWithKey:(NSString *)key
         filename:(NSString *)filename
      mimeType:(NSString *)mimeType
             data:(NSData *)data;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSData *data;
@end
