//
//  HETBaseModel.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/2/29.
//  Copyright © 2016年 mr.cao. All rights reserved.
//
#import "HETBaseModel.h"
#import <objc/runtime.h>

#define NSStringSafety(obj) \
[obj isKindOfClass:[NSObject class]]?[obj description]:@""

#define NSArraySafety(obj) \
[obj isKindOfClass:[NSArray class]]?obj:nil

#define NSDictionarySafety(obj) \
[obj isKindOfClass:[NSDictionary class]]?obj:nil

#define ObjectForKeySafety(obj,key) \
[obj isKindOfClass:[NSDictionary class]]?[obj objectForKey:key]:nil


#define ObjectIndexSafety(obj,index) \
[obj isKindOfClass:[NSArray class]]&&index<[obj count] ? [obj objectAtIndex:index] :nil


#define NSMutableArraySafety(obj)  \
[obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]] ? [NSMutableArray arrayWithArray:obj] :nil

#define NSMutableDictionarySafety(obj)  \
[obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]] ? [NSMutableDictionary dictionaryWithDictionary:obj] : nil


@implementation HETBaseModel


-(id)initWithDic:(NSDictionary*)dic{
    if (self=[super init]) {
        if (!dic||![dic isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        //当前类的property
        [self setClassProperty:[self class] withPropertyDic:dic];
        
        //父类的property
        if (self.superclass) {
            [self setClassProperty:self.superclass withPropertyDic:dic];
        }
        
        //NSArray* propertiesArray=[self GetPropertiesNameMethod];
        // [self setModelValueWithPropertiesArray:propertiesArray valueDic:dic];
    }
    return self;
}
-(void)setClassProperty:(Class)class withPropertyDic:(NSDictionary*)propertyDic{
    unsigned int outCount, i;
    //获取所有property
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id valueItem = propertyDic[propertyName];
        //如果的有set的value
        if (valueItem) {
            //获取该property的数据类型
            const char* attries = property_getAttributes(property);
            //数据类型的string
            NSString *attrString = [NSString stringWithUTF8String:attries];
            [self setPropery:attrString value:valueItem propertyName:propertyName];
        }
    }
    if (properties) {
        free(properties);
    }
}


-(void)setPropery:(NSString*)attriString
            value:(id)value
     propertyName:(NSString*)propertyName{
    //kvc不支持c的数据类型，所以只能NSNumber转化，NSNumber可以  64位是TB
    if ([attriString hasPrefix:@"T@\"NSString\""]) {
        [self setValue:NSStringSafety(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tc"] || [attriString hasPrefix:@"TB"]) {
        //32位Tc  64位TB
        [self setValue:[NSNumber numberWithBool:[value boolValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Ti"] || [attriString hasPrefix:@"Tq"]) {
        //32位 Ti是int 和 NSInteger  64位后，long 和  NSInteger 都是Tq， int 是Ti
        [self setValue:[NSNumber numberWithInteger:[NSStringSafety(value) integerValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tl"]) { //32位 long
        [self setValue:[NSNumber numberWithLongLong:[NSStringSafety(value) longLongValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tf"]) { //float
        [self setValue:[NSNumber numberWithFloat:[NSStringSafety(value) floatValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Td"]) { //CGFloat
        [self setValue:[NSNumber numberWithDouble:[NSStringSafety(value) doubleValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableArray\""]) {
        [self setValue:NSMutableArraySafety(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSArray\""]) {
        [self setValue:NSArraySafety(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSDictionary\""]) {
        [self setValue:NSDictionarySafety(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableDictionary\""]) {
        [self setValue:NSMutableDictionarySafety(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableDictionary\""]) {
        [self setValue:NSMutableDictionarySafety(value) forKey:propertyName];
    }
}
-(void)setModelValueWithPropertiesArray:(NSArray*)propertiesArray valueDic:(NSDictionary*)dic{
    for (NSString* propertyName in propertiesArray) {
        //NSLog(@"propertyName is %@",propertyName);
        id propertyValue=[dic objectForKey:propertyName];
        if (propertyName) {
            if (propertyValue) {
                [self setValue:propertyValue forKey:propertyName];
            }
            else{
                [self setValue:@"" forKey:propertyName];
            }
        }
    }
}


-(NSDictionary*)convertModelToDic{
    NSArray* propertiesArray=[self GetPropertiesNameMethod];
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    for (NSString* propertyName in propertiesArray) {
        if (propertyName) {
            id propertyValue=[self valueForKey:propertyName];
            
            if(propertyValue)
            {
                [dic setObject:propertyValue forKey:propertyName];
            }
            else
            {
                 [dic setObject:@"0" forKey:propertyName];
            }
            
        }
    }
    return dic;
}

- (NSArray*)GetPropertiesNameMethod {
    
    NSMutableArray* properListarray=[[NSMutableArray alloc] init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            //const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            //NSLog(@"propertyName:%@",propertyName);
           // NSString *propertyType = [NSString stringWithCString:propType
                                                                 //  encoding:[NSString defaultCStringEncoding]];
            
            //获取该property的数据类型
            const char* attries = property_getAttributes(property);
            //数据类型的string
            NSString *attrString = [NSString stringWithUTF8String:attries];
            [properListarray addObject:propertyName];
            
            //            NSLog(@"propName is %@",propertyName);
        }
    }
    free(properties);
    return properListarray;
}

//static const char *getPropertyType(objc_property_t property) {
//    const char *attributes = property_getAttributes(property);
//    char buffer[1 + strlen(attributes)];
//    strcpy(buffer, attributes);
//    char *state = buffer, *attribute;
//    while ((attribute = strsep(&state, ",")) != NULL) {
//        if (attribute[0] == 'T') {
//            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
//        }
//    }
//    return "@";
//}

@end
