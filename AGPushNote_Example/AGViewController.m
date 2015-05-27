//
//  AGViewController.m
//  AGPushNote_Example
//
//  Created by Aviel Gross on 4/29/14.
//  Copyright (c) 2014 Aviel Gross. All rights reserved.
//

#import "AGViewController.h"
#import "AGPushNoteView.h"

static NSInteger pushCounter = 0;

@interface AGViewController ()

@end

@implementation AGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushNowAction:(UIButton *)sender {
//    [AGPushNoteView showWithNotificationMessage:[NSString stringWithFormat:@"%d", pushCounter++]];
  AGPushNote* pushNote = [[AGPushNote alloc] init];
  pushNote.iconImageName = @"whichz_share";
  pushNote.userInfo = @{@"push_count":[NSNumber numberWithInteger:pushCounter++]};
  pushNote.message = [NSString stringWithFormat:@"This AGPushNoteView is used in Which'z App [%@]", pushNote.userInfo[@"push_count"]];
  [AGPushNoteView showNotification:pushNote];
  
  [AGPushNoteView setMessageAction:^(AGPushNote *pushNote) {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"PUSH"
                          message:[NSString stringWithFormat:@"%@",pushNote.userInfo[@"push_count"]]
                          delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:nil];
    [alert show];
  }];
}

@end
