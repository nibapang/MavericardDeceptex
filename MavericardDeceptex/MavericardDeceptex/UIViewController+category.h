//
//  UIViewController+category.h
//  MavericardDeceptex
//
//  Created by Mavericard Deceptex on 2025/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (category)

- (BOOL)mavericardNeedLoadAdBannData;

- (NSString *)mavericardMainHostUrl;

- (void)mavericardShowAdVsiew:(NSString *)adurl;

@end

NS_ASSUME_NONNULL_END
