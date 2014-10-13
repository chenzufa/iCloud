//
//  ViewController.m
//  iCloudTest
//
//  Created by 陈祖发 on 14-10-10.
//  Copyright (c) 2014年 陈祖发. All rights reserved.
//

#import "ViewController.h"

#define UBIQUITY_CONTAINER_URL @"L8E8CV789S.com.dianjoy.iCloudTest"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //判断iCloud是否可用
    NSURL* url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL];
    if (!url) {
        return;
    }
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"document.doc"];
    _documentURL = [NSURL fileURLWithPath:dataFile];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    _ubiquityURL = [[filemgr URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL] URLByAppendingPathComponent:@"Documents"];
    NSLog(@"iCloud path = %@", [_ubiquityURL path]);
    
    if ([filemgr fileExistsAtPath:[_ubiquityURL path]] == NO)
    {
        NSLog(@"iCloud Documents directory does not exist");
        [filemgr createDirectoryAtURL:_ubiquityURL withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"iCloud Documents directory exists");
    }
    
    _ubiquityURL = [_ubiquityURL URLByAppendingPathComponent:@"document.doc"];
    NSLog(@"Full ubiquity path = %@", [_ubiquityURL path]);
    
    // Search for document in iCloud storage
    _metadataQuery = [[NSMetadataQuery alloc] init];
    [_metadataQuery setPredicate: [NSPredicate predicateWithFormat: @"%K like 'document.doc'",
                                  NSMetadataItemFSNameKey]];
    [_metadataQuery setSearchScopes:[NSArray arrayWithObjects:NSMetadataQueryUbiquitousDocumentsScope,nil]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:_metadataQuery];
    NSLog(@"starting query");
    [_metadataQuery startQuery];

}

- (IBAction)saveDocument
{
    _document.userText = _textView.text;
    
    [_document saveToURL:_ubiquityURL forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:^(BOOL success) {
               if (success){
                   NSLog(@"Saved to cloud for overwriting");
                   
                   _metadataQuery = [[NSMetadataQuery alloc] init];
                   [_metadataQuery setPredicate: [NSPredicate predicateWithFormat: @"%K like 'document.doc'",
                                                  NSMetadataItemFSNameKey]];
                   [_metadataQuery setSearchScopes:[NSArray arrayWithObjects:NSMetadataQueryUbiquitousDocumentsScope,nil]];
                   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryDidFinishGathering:)
                                                                name:NSMetadataQueryDidFinishGatheringNotification
                                                              object:_metadataQuery];
                   NSLog(@"starting query");
                   [_metadataQuery startQuery];
               } else {
                   NSLog(@"Not saved to cloud for overwriting");
               }
           }];
}

- (void)metadataQueryDidFinishGathering:(NSNotification *)notification
{
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    [query stopQuery];
    NSArray *results = [[NSArray alloc] initWithArray:[query results]];
    
    
    if ([results count] == 1)
    {
        NSLog(@"File exists in cloud");
        _ubiquityURL = [[results objectAtIndex:0] valueForAttribute:NSMetadataItemURLKey];
        _document = [[MyDocument alloc] initWithFileURL:_ubiquityURL];
        //self.document.userText = @"";
        [_document openWithCompletionHandler:
         ^(BOOL success) {
             if (success){
                 NSLog(@"Opened cloud doc");
                 _detailLabel.text = _document.userText;
             } else {
                 NSLog(@"Not opened cloud doc");
             }
         }];
    } else {
        NSLog(@"File does not exist in cloud");
        _document = [[MyDocument alloc] initWithFileURL:_ubiquityURL];
        
        [_document saveToURL:_ubiquityURL
           forSaveOperation: UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success){
                  NSLog(@"Saved to cloud");
              }  else {
                  NSLog(@"Failed to save to cloud");
              }
          }];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
