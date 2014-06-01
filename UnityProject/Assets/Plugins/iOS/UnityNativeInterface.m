//
//  UnityNativeInterface.m
//  Unity-iPhone
//
//  Created by Sam Izzo on 30/05/14.
//
//

#import "UnityInterface.h"
#import "UnityNativeInterface.h"
#import "NativeInterface.h"
#import "UnityViewControllerBase.h"
#import "UnityAppController.h"

#ifndef __cplusplus
extern void		UnityPause(bool pause);
#endif

@interface CustomAppController : UnityAppController
{
    UIViewController*       m_unityViewController;
    NativeInterface*        m_nativeInterface;
    bool                    m_inNative;
}

- (void) switchToNative;
- (void) switchToUnity;
- (void) createViewHierarchyImpl;
@end

@implementation CustomAppController
- (void) createViewHierarchyImpl;
{
    _rootController	= [[UnityDefaultViewController alloc] init];
    _rootView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    m_nativeInterface = [[NativeInterface alloc] init];

	m_unityViewController = [[UIViewController alloc] init];
	m_unityViewController.view = _unityView;

	_rootController.view = _rootView;

    [_rootView addSubview:m_unityViewController.view];
    m_inNative = false;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToUnity) name:@"SwitchToUnityRequested" object:nil];
}

- (void) switchToNative;
{
    if (!m_inNative)
    {
        NSLog(@"Switching to native");
        [m_unityViewController.view removeFromSuperview];
        [_rootView addSubview:m_nativeInterface.ViewController.view];
        m_inNative = true;
        UnityPause(true);
    }
    else
    {
        NSLog(@"Already in native, not switching");
    }
}

- (void) switchToUnity;
{
    if (m_inNative)
    {
        m_inNative = false;
        [m_nativeInterface removeView];
        [_rootView addSubview:m_unityViewController.view];
        UnityPause(false);
    }
}

@end

IMPL_APP_CONTROLLER_SUBCLASS(CustomAppController)


#ifdef __cplusplus
extern "C"
{
#endif
    
    void SwitchToNative()
    {
        CustomAppController* controller = (CustomAppController*)[UIApplication sharedApplication].delegate;
        [controller switchToNative];
    }
    
#ifdef __cplusplus
}
#endif
