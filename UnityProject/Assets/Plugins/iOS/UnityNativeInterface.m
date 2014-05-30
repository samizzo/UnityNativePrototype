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
    UINavigationController* m_navController;
    UIViewController*       m_unityViewController;
    UIViewController*       m_nativeViewController;
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

    m_nativeViewController = [NativeInterface Create];

	m_unityViewController = [[UIViewController alloc] init];
	m_unityViewController.view = _unityView;
    
	_rootController.view = _rootView;

	m_navController = [[UINavigationController alloc] initWithRootViewController:m_unityViewController];
	[_rootView addSubview:m_navController.view];
    
    m_inNative = false;
//    UnityPause(true);
}

- (void) switchToNative;
{
    if (!m_inNative)
    {
        NSLog(@"Switching to native");
        //[m_navController popViewControllerAnimated:NO];
        [m_navController pushViewController:m_nativeViewController animated:NO];
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
        //[m_navController pushViewController:m_unityViewController animated:NO];
        [m_navController popViewControllerAnimated:NO];
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
        NSLog(@"Hello from native!");
        CustomAppController* controller = (CustomAppController*)[UIApplication sharedApplication].delegate;
        [controller switchToNative];
    }
    
#ifdef __cplusplus
}
#endif
