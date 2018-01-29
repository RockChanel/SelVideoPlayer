//
//  UIViewController+PlayerRotation.m
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/29.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "UIViewController+PlayerRotation.h"
#import <objc/runtime.h>

@implementation UIViewController (PlayerRotation)

/**
 * 默认所有都不支持转屏,如需个别页面支持除竖屏外的其他方向，请在viewController重新下边这三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}

@end

@implementation UITabBarController (PlayerRotation)

+ (void)load {
    SEL selectors[] = {
        @selector(selectedIndex)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"sel_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        // 通过class_getInstanceMethod()函数从当前class对象中的method list获取method结构体
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        // 使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现swizzledSelector交换的方法，会导致失败
        if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
            //class_replaceMethod向对象所属的类动态添加所需的selector：，如果swizzledSelector没有实现，
            // class_replaceMethod，它有两种不同的行为。当类中没有想替换的原方法时，该方法会调用class_addMethod来为该类增加一个新方法，也因为如此，class_replaceMethod在调用时需要传入types参数，而method_exchangeImplementations和method_setImplementation却不需要。
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            // 通过class_addMethod()的验证，如果self实现了swizzledViwDidLoad这个方法，class_addMethod()函数将会返回NO，进行交换了
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

- (NSInteger)sel_selectedIndex {
    NSInteger index = [self sel_selectedIndex];
    if (index > self.viewControllers.count) { return 0; }
    return index;
}

/**
 * 如果window的根视图是UITabBarController，则会先调用这个Category，然后调用UIViewController+PlayerRotation
 * 只需要在支持除竖屏以外方向的页面重新下边三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.topViewController shouldAutorotate];
    } else {
        return [vc shouldAutorotate];
    }
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.topViewController supportedInterfaceOrientations];
    } else {
        return [vc supportedInterfaceOrientations];
    }
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.topViewController preferredInterfaceOrientationForPresentation];
    } else {
        return [vc preferredInterfaceOrientationForPresentation];
    }
}

@end

@implementation UINavigationController (ZFPlayerRotation)

/**
 * 如果window的根视图是UINavigationController，则会先调用这个Category，然后调用UIViewController+PlayerRotation
 * 只需要在支持除竖屏以外方向的页面重新下边三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end

@implementation UIAlertController (ZFPlayerRotation)

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations; {
    return UIInterfaceOrientationMaskAll;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
#endif

@end
