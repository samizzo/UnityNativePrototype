//
//  NativeInterface.h
//  NativeInterface
//
//  Created by Sam Izzo on 30/05/14.
//  Copyright (c) 2014 Fancy Pants Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>

@interface NativeInterface : NSObject

@property (readonly) UIStoryboard* Storyboard;
@property (readonly) UIViewController* ViewController;

- (id)init;
- (void)dealloc;
- (void)removeView;

@end
