//
//  SelVideoPlayer.h
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelPlayerConfiguration;
@interface SelVideoPlayer : UIView

- (instancetype)initWithFrame:(CGRect)frame configuration:(SelPlayerConfiguration *)configuration;
- (void)orientationAspect;

/** 播放视频 */
- (void)_playVideo;
/** 暂停播放 */
- (void)_pauseVideo;

- (void)_deallocPlayer;

@end
