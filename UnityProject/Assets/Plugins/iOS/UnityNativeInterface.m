//
//  UnityNativeInterface.m
//  Unity-iPhone
//
//  Created by Sam Izzo on 30/05/14.
//
//

#import "UnityNativeInterface.h"
#import "NativeInterface.h"

#ifdef __cplusplus
extern "C"
{
#endif

void SwitchToNative()
{
    NSLog(@"Hello from native!");
    UIViewController* vc = [NativeInterface Create];
}

#ifdef __cplusplus
}
#endif