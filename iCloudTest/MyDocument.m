//
//  MyDocument.m
//  iCloudTest
//
//  Created by 陈祖发 on 14-10-10.
//  Copyright (c) 2014年 陈祖发. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    const char* str = [self.userText UTF8String];
    
    return [NSData dataWithBytes:str length:strlen(str)];
}

-(BOOL) loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ( [contents length] > 0) {
        if (self.userText.length>0) {
            return YES;
        }
//        self.userText = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
        self.userText = [[NSString alloc] initWithBytes:[contents bytes] length:[contents length] encoding:NSUTF8StringEncoding];
    } else {
        self.userText = @"";
    }
    return YES;
}


@end
