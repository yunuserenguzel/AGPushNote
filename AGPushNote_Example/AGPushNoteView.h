//
//  IAAPushNoteView.h
//  TLV Airport
//
//  Created by Aviel Gross on 1/29/14.
//  Copyright (c) 2014 NGSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGPushNote : NSObject

@property NSString* message; //message text
@property NSString* iconImageName; // icon to be shown on left
@property NSDictionary* userInfo; // to pass the actual user info if this is push notification triggered

@end

@protocol AGPushNoteViewDelegate <NSObject>
@optional
- (void)pushNoteDidAppear; // Called after the view has been fully transitioned onto the screen. (equel to completion block).
- (void)pushNoteWillDisappear; // Called before the view is hidden, after the message action block.
@end

@interface AGPushNoteView : UIView
+ (void)showNotification:(AGPushNote*)pushNote;
+ (void)showNotification:(AGPushNote *)pushNote completion:(void (^)(void))completion;
+ (void)close;
+ (void)closeWithCompletion:(void (^)(void))completion;
+ (void)awake;

+ (void)setMessageAction:(void (^)(AGPushNote* pushNote))action;
+ (void)setDelegateForPushNote:(id<AGPushNoteViewDelegate>)delegate;

@property (nonatomic, weak) id<AGPushNoteViewDelegate> pushNoteDelegate;
@end
