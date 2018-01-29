//
//  SelBackControl.h
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelVideoSlider.h"

/** 播放器控制面板代理 */
@protocol SelPlaybackControlsDelegate <NSObject>

@required
/**
 播放按钮点击事件
 @param selected 按钮选中状态
 */
- (void)playButtonAction:(BOOL)selected;
/** 全屏切换按钮点击事件 */
- (void)fullScreenButtonAction;

/** 滑杆开始拖动 */
- (void)videoSliderTouchBegan:(SelVideoSlider *)slider;
/** 滑杆拖动中 */
- (void)videoSliderValueChanged:(SelVideoSlider *)slider;
/** 滑杆结束拖动 */
- (void)videoSliderTouchEnded:(SelVideoSlider *)slider;

@optional
/** 控制面板单击事件 */
- (void)tapGesture;
/** 控制面板双击事件 */
- (void)doubleTapGesture;

@end

@interface SelPlaybackControls : UIView

/** 底部控制栏 */
@property (nonatomic, strong)UIView *bottomControlsBar;
/** 播放按钮 */
@property (nonatomic, strong) UIButton *playButton;
/** 全屏切换按钮 */
@property (nonatomic, strong) UIButton *fullScreenButton;
/** 进度滑杆 */
@property (nonatomic, strong) SelVideoSlider *videoSlider;
/** 播放时间 */
@property (nonatomic, strong) UILabel *playTimeLabel;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progress;
/** 播放器控制面板代理 */
@property (nonatomic, weak) id<SelPlaybackControlsDelegate> delegate;


/**
 设置视频时间显示以及滑杆状态
 @param playTime 当前播放时间
 @param totalTime 视频总时间
 @param sliderValue 滑杆滑动值
 */
- (void)_setPlaybackControlsWithPlayTime:(NSInteger)playTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue;

/**
 根据播放状态调整控制面板UI显示
 @param isPlaying 播放状态
 */
- (void)_setPlaybackControlsWithIsPlaying:(BOOL)isPlaying;

@end
