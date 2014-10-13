//
//  ViewController.h
//  iCloudTest
//
//  Created by 陈祖发 on 14-10-10.
//  Copyright (c) 2014年 陈祖发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDocument.h"

@interface ViewController : UIViewController<UITextViewDelegate>

{
    MyDocument *_document;
    NSURL *_documentURL;
    NSURL *_ubiquityURL;
    UITextView *_textView;
    NSMetadataQuery *_metadataQuery;
}
@property (strong, nonatomic) IBOutlet UILabel* detailLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSURL *documentURL;
@property (strong, nonatomic) MyDocument *document;
@property (strong, nonatomic) NSURL *ubiquityURL;
@property (strong, nonatomic) NSMetadataQuery *metadataQuery;
-(IBAction)saveDocument;

@end
