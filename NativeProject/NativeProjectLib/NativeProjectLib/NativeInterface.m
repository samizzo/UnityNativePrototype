//
//  NativeInterface.m
//  NativeInterface
//
//  Created by Sam Izzo on 30/05/14.
//  Copyright (c) 2014 Fancy Pants Games. All rights reserved.
//

#import "NativeInterface.h"
#import "ViewController.h"

@implementation NativeInterface

+ (UIViewController*)Create
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    return viewController;
}

@end
