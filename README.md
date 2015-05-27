AGPushNote
==========

Custom view for easily displaying in-app push notification that feels like default iOS banners.
This is an edited version of AGPushNoteView.
I used this version for Which'z App. Below the example how we used it. There are some significant changes:

* PushNote model class is added. It has 3 properties: message, iconImageName and userInfo.
* Since, this could mainly be used for showing remote push notifications in the app, in this way you can pass the userInfo which you gained from AppDelegate.
* UI is changed.
* Added bounce effect for showing.
* Added iPhone 6 and iPhone 6 + support. 

<img src="https://github.com/yunuserenguzel/AGPushNote/blob/master/Resources/push_ex.png" height="50%">

* Will look like iOS7 on iOS7 and will (try to) look like iOS6 on iOS6.
* Both block and protocol ways are available to control the action of tapping the message and showing/dismissing the view.
* Automatic handling for more than 1 push - Try calling `showNotification:` repeatedly to see how this works (Shown in the example app).
* Action block for tapping the message can be changed at any time - even after the view is already on screen! (Use `setMessageAction:` to set it). 
* Optionaly hide the view after X seconds (Default is 5), remove comment in code the make this work...

## Usage

This is a one liner. Simply import and call this method to show a message:
```objc
#import "AGPushNoteView.h"
.
.
AGPushNote* pushNote = [[AGPushNote alloc] init];
pushNote.message = @"John Doe sent you a message!";
pushNote.iconImageName = @"new_message.png";
[AGPushNoteView showNotification:pushNote];
```

To set the action for when the user tap the message, call:
```objc
[AGPushNoteView setMessageAction:^(AGPushNote *pushNote){
        // Do something...
    }];
```
* Since AGPushNote can handle showing multiple notifications, the `pushNote` object in the block will be the pushNote the user tapped on.


## More Stuff

To use the delegate methods call:
```objc
id <AGPushNoteViewDelegate> someObj...
[AGPushNoteView setDelegateForPushNote:someObj];
```

To use the timer to auto hide the view after showing it, finds this line and remove the comment from it:
```objc
@implementation AGPushNoteView
.
.
PUSH_VIEW.closeTimer = [NSTimer...
```
The default 5 seconds delay is set in a define in the head of the `.m` file: 
```objc
#define CLOSE_PUSH_SEC 5
.
.
@interface AGPushNoteView() ...
```

## Things to see, stuff to do, places to go
* Add option to put small icon next to the message.
* Add option to switch the X button to the right side.

## Credits

AGNoteView was created by [Aviel Gross](http://bit.ly/aviel) in the development of [TLV Airport](https://itunes.apple.com/us/app/tel-aviv-int-airport-nml-t/id796888961?mt=8)
