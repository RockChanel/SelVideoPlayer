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

/**
 初始化播放器
 @param configuration 播放器配置信息
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(SelPlayerConfiguration *)configuration;

/** 播放视频 */
- (void)_playVideo;
/** 暂停播放 */
- (void)_pauseVideo;
/** 释放播放器 */
- (void)_deallocPlayer;

@end
