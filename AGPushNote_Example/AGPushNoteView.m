//
//  IAAPushNoteView.m
//  TLV Airport
//
//  Created by Aviel Gross on 1/29/14.
//  Copyright (c) 2014 NGSoft. All rights reserved.
//

#import "AGPushNoteView.h"

#define APP [UIApplication sharedApplication].delegate
#define isIOS7 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
#define PUSH_VIEW [AGPushNoteView sharedPushView]

#define CLOSE_PUSH_SEC 5
#define SHOW_ANIM_DUR 0.5
#define HIDE_ANIM_DUR 0.3

@implementation AGPushNote


@end

@interface AGPushNoteView()
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIButton *dismissButton;
@property (nonatomic) UIView* bottomBorder;

@property (strong, nonatomic) NSTimer *closeTimer;
@property (strong, nonatomic) AGPushNote *currentPushNote;
@property (strong, nonatomic) NSMutableArray *pendingPushArr;

@property (strong, nonatomic) void (^messageTapActionBlock)(AGPushNote* pushNote);
@end


@implementation AGPushNoteView

//Singleton instance
static AGPushNoteView *_sharedPushView;

+ (instancetype)sharedPushView
{
  @synchronized([self class])
  {
    if (!_sharedPushView){
      _sharedPushView = [[AGPushNoteView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
      [_sharedPushView setUpUI];
    }
    return _sharedPushView;
  }
  // to avoid compiler warning
  return nil;
}

+ (void)setDelegateForPushNote:(id<AGPushNoteViewDelegate>)delegate {
  [PUSH_VIEW setPushNoteDelegate:delegate];
}

#pragma mark - Lifecycle (of sort)
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    CGRect f = self.frame;
    CGFloat width = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    self.frame = CGRectMake(f.origin.x, f.origin.y, width, f.size.height);
  }
  return self;
}

- (void) setVisibleFrame
{
  [self setFrame:CGRectMake(0.0, -10.0, 0, 0)];
}

- (void) setHiddenFrame
{
  [self setFrame:CGRectMake(0.0, -76.0, 0, 0)];
}

- (void)setUpUI {
  [self setHiddenFrame];
  
  [self setUserInteractionEnabled:YES];
  self.layer.zPosition = MAXFLOAT;
  //  self.multipleTouchEnabled = NO;
  //  self.exclusiveTouch = YES;
  
  UITapGestureRecognizer *msgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageTapAction)];
  [msgTap setNumberOfTapsRequired:1];
  self.userInteractionEnabled = YES;
  [self addGestureRecognizer:msgTap];
  
  self.messageLabel.textColor = [UIColor colorWithRed:0.23 green:0.35 blue:0.6 alpha:1.0];
  self.messageLabel.font = [UIFont systemFontOfSize:16.0];
  self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
  
  //:::[For debugging]:::
  //            self.containerView.backgroundColor = [UIColor yellowColor];
  //            self.closeButton.backgroundColor = [UIColor redColor];
  //            self.messageLabel.backgroundColor = [UIColor greenColor];
  
  [APP.window addSubview:PUSH_VIEW];
}

- (UILabel *)messageLabel
{
  if(!_messageLabel) {
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];
  }
  return _messageLabel;
}

- (UIView *)bottomBorder
{
  if(!_bottomBorder) {
    _bottomBorder = [[UIView alloc] init];
    _bottomBorder.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    [self addSubview:_bottomBorder];
  }
  return _bottomBorder;
}
- (UIImageView *)iconImageView
{
  if(!_iconImageView) {
    _iconImageView = [[UIImageView alloc] init];
    [self addSubview:_iconImageView];
  }
  return _iconImageView;
}

- (UIButton *)dismissButton
{
  if(!_dismissButton) {
    _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dismissButton setImage:[UIImage imageNamed:@"dismiss_normal.png"] forState:UIControlStateNormal];
    [_dismissButton setImage:[UIImage imageNamed:@"dismiss_highlighted.png"] forState:UIControlStateHighlighted];
    [_dismissButton addTarget:self action:@selector(closeActionItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dismissButton];
  }
  return _dismissButton;
}

- (void)setFrame:(CGRect)frame
{
  if (frame.origin.y > -10) {
    frame.origin.y = -10;
  }
  super.frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 74.0);
  self.dismissButton.frame = CGRectMake(super.frame.size.width - 33.0, 10, 33.0, 64.0);
  self.messageLabel.frame = CGRectMake(74.0, 10.0, super.frame.size.width - 33.0 - 64.0 - 10 , 64.0);
  self.iconImageView.frame = CGRectMake(0.0, 10.0, 64.0, 64.0);
  self.bottomBorder.frame = CGRectMake(0.0, 74.0, super.frame.size.width, 0.5);
}

+ (void)awake {
  if (PUSH_VIEW.frame.origin.y == 0) {
    [APP.window addSubview:PUSH_VIEW];
  }
}

+(void)showNotification:(AGPushNote *)pushNote
{
  [AGPushNoteView showNotification:pushNote completion:^{
    
  }];
}

+ (void)showNotification:(AGPushNote *)pushNote completion:(void (^)(void))completion
{
  PUSH_VIEW.currentPushNote = pushNote;
  if (pushNote) {
    [PUSH_VIEW.pendingPushArr addObject:pushNote];
    
    PUSH_VIEW.messageLabel.text = pushNote.message;
    PUSH_VIEW.iconImageView.image = [UIImage imageNamed:pushNote.iconImageName];
    
    APP.window.windowLevel = UIWindowLevelStatusBar;
    
    [PUSH_VIEW setHiddenFrame];
    [APP.window addSubview:PUSH_VIEW];
    
    [UIView animateWithDuration:SHOW_ANIM_DUR delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
      
      [PUSH_VIEW setVisibleFrame];
    } completion:^(BOOL finished) {
      completion();
      if ([PUSH_VIEW.pushNoteDelegate respondsToSelector:@selector(pushNoteDidAppear)]) {
        [PUSH_VIEW.pushNoteDelegate pushNoteDidAppear];
      }
    }];
    
    //Start timer (Currently not used to make sure user see & read the push...)
    //        PUSH_VIEW.closeTimer = [NSTimer scheduledTimerWithTimeInterval:CLOSE_PUSH_SEC target:[IAAPushNoteView class] selector:@selector(close) userInfo:nil repeats:NO];
  }
}

+ (void)closeWithCompletion:(void (^)(void))completion {
  if ([PUSH_VIEW.pushNoteDelegate respondsToSelector:@selector(pushNoteWillDisappear)]) {
    [PUSH_VIEW.pushNoteDelegate pushNoteWillDisappear];
  }
  
  [PUSH_VIEW.closeTimer invalidate];
  [UIView animateWithDuration:HIDE_ANIM_DUR delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    [PUSH_VIEW setHiddenFrame];
  } completion:^(BOOL finished) {
    [PUSH_VIEW handlePendingPushJumpWitCompletion:completion];
  }];
}

+ (void)close {
  [AGPushNoteView closeWithCompletion:^{
    //Nothing.
  }];
}

#pragma mark - Pending push managment
- (void)handlePendingPushJumpWitCompletion:(void (^)(void))completion {
  id lastObj = [self.pendingPushArr lastObject]; //Get myself
  if (lastObj) {
    [self.pendingPushArr removeObject:lastObj]; //Remove me from arr
    AGPushNote* pendingPushNote = [self.pendingPushArr lastObject];
    if (pendingPushNote) { //If got something - remove from arr, - than show it.
      [self.pendingPushArr removeObject:pendingPushNote];
      [AGPushNoteView showNotification:pendingPushNote completion:completion];
    } else {
      APP.window.windowLevel = UIWindowLevelNormal;
    }
  }
}

- (NSMutableArray *)pendingPushArr {
  if (!_pendingPushArr) {
    _pendingPushArr = [[NSMutableArray alloc] init];
  }
  return _pendingPushArr;
}

#pragma mark - Actions
+ (void)setMessageAction:(void (^)(AGPushNote* pushNote))action {
  PUSH_VIEW.messageTapActionBlock = action;
}

- (void)messageTapAction {
  if (self.messageTapActionBlock) {
    self.messageTapActionBlock(self.currentPushNote);
    [AGPushNoteView close];
  }
}
- (void) closeActionItem:(id)sender {
  [AGPushNoteView close];
}


@end
