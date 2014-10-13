//
//  MyDocument.h
//  iCloudTest
//
//  Created by 陈祖发 on 14-10-10.
//  Copyright (c) 2014年 陈祖发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDocument : UIDocument
{
    NSString *_userText;
}
@property (strong, nonatomic) NSString *userText;


@end
