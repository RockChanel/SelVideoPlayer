//
//  SelBackControl.m
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SelPlaybackControls.h"
#import <Masonry.h>

static const CGFloat PlaybackControlsAutoHideTimeInterval = 0.3f;
@interface SelPlaybackControls()

@property (nonatomic, assign) BOOL isShowing;

@end

@implementation SelPlaybackControls

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


/** 重置控制面板 */
- (void)_resetPlaybackControls
{
    self.bottomControlsBar.alpha = 0;
    self.isShowing = NO;
    self.playButton.hidden = YES;
}

/**
 设置视频时间显示以及滑杆状态
 @param playTime 当前播放时间
 @param totalTime 视频总时间
 @param sliderValue 滑杆滑动值
 */
- (void)_setPlaybackControlsWithPlayTime:(NSInteger)playTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue
{
    //当前时长进度progress
    NSInteger proMin = playTime / 60;//当前秒
    NSInteger proSec = playTime % 60;//当前分钟
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    //更新当前播放时间
    self.videoSlider.value = sliderValue;
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    //更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

/**
 根据播放状态调整控制面板UI显示
 @param isPlaying 播放状态
 */
- (void)_setPlaybackControlsWithIsPlaying:(BOOL)isPlaying
{
    self.playButton.selected = isPlaying;
}

/** progress显示缓冲进度 */
- (void)_setPlayerProgress:(CGFloat)progress {
    [self.progress setProgress:progress animated:NO];
}

/** 显示或隐藏控制面板 */
- (void)_playerShowOrHidePlaybackControls
{
    if (self.isShowing) {
        [self _playerHidePlaybackControls];
    } else {
        [self _playerShowPlaybackControls];
    }
}

/** 显示控制面板 */
- (void)_playerShowPlaybackControls
{
    [self _playerCancelAutoHidePlaybackControls];
    [UIView animateWithDuration:PlaybackControlsAutoHideTimeInterval animations:^{
        [self _showPlaybackControls];
    } completion:^(BOOL finished) {
        self.isShowing = YES;
        [self _autoHidePlaybackControls];
    }];
}

/** 隐藏控制面板 */
- (void)_playerHidePlaybackControls
{
    [self _playerCancelAutoHidePlaybackControls];
    [UIView animateWithDuration:PlaybackControlsAutoHideTimeInterval animations:^{
        [self _hidePlaybackControls];
    } completion:^(BOOL finished) {
        self.isShowing = NO;
    }];
}

/** 显示控制面板 */
- (void)_showPlaybackControls
{
    self.isShowing = YES;
    self.bottomControlsBar.alpha = 1;
    self.playButton.hidden = NO;
    [self _showOrHideStatusBar];
}

/** 隐藏控制面板 */
- (void)_hidePlaybackControls
{
    self.isShowing = NO;
    //self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.bottomControlsBar.alpha = 0;
    self.playButton.hidden = YES;
    if (self.isFullScreen) {
        [self _showOrHideStatusBar];
    }
}

/** 延时自动隐藏控制面板 */
- (void)_autoHidePlaybackControls
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_playerHidePlaybackControls) object:nil];
    [self performSelector:@selector(_playerHidePlaybackControls) withObject:nil afterDelay:_hideInterval];
}

/** 显示或隐藏状态栏 */
- (void)_showOrHideStatusBar
{
    switch (_statusBarHideState) {
        case SelStatusBarHideStateFollowControls:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:!self.isShowing];
        }
            break;
        case SelStatusBarHideStateNever:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
            break;
        case SelStatusBarHideStateAlways:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
            break;
        default:
            break;
    }
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
}

/** 取消延时隐藏playbackControls */
- (void)_playerCancelAutoHidePlaybackControls
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/** 创建UI */
- (void)setupUI
{
    [self addSubview:self.playButton];
    [self addSubview:self.bottomControlsBar];
    
    [_bottomControlsBar addSubview:self.fullScreenButton];
    [_bottomControlsBar addSubview:self.playTimeLabel];
    [_bottomControlsBar addSubview:self.totalTimeLabel];
    [_bottomControlsBar addSubview:self.progress];
    [_bottomControlsBar addSubview:self.videoSlider];
    
    [self makeConstraints];
    [self _resetPlaybackControls];
    [self addGesture];
}

/** 添加手势 */
- (void)addGesture
{
    //单击手势
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:singleTapGesture];
    
    //双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    
    //当系统检测不到双击手势时执行再识别单击手势，解决单双击收拾冲突
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

/** 添加约束 */
- (void)makeConstraints
{
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.superview.center);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_bottomControlsBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    [_fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_bottomControlsBar);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomControlsBar).offset(5);
        make.width.equalTo(@45);
        make.centerY.equalTo(_bottomControlsBar.mas_centerY);
    }];
    
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_fullScreenButton.mas_left).offset(-5);
        make.width.equalTo(@45);
        make.centerY.equalTo(_bottomControlsBar.mas_centerY);
    }];
    
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playTimeLabel.mas_right).offset(5);
        make.right.equalTo(_totalTimeLabel.mas_left).offset(-5);
        make.height.equalTo(@2);
        make.centerY.equalTo(_bottomControlsBar.mas_centerY);
    }];

    [_videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_progress);
    }];
}

/** 底部控制栏 */
- (UIView *)bottomControlsBar
{
    if (!_bottomControlsBar) {
        _bottomControlsBar = [[UIView alloc]init];
        _bottomControlsBar.userInteractionEnabled = YES;
    }
    return _bottomControlsBar;
}

/** 播放按钮 */
- (UIButton *)playButton
{
    if (!_playButton){
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

/** 全屏切换按钮 */
- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"ic_turn_screen_white_18x18_"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"ic_zoomout_screen_white_18x18_"] forState:UIControlStateSelected];
        [_fullScreenButton addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}


/** 当前播放时间 */
- (UILabel *)playTimeLabel
{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc]init];
        _playTimeLabel.font = [UIFont systemFontOfSize:14];
        _playTimeLabel.text = @"00:00";
        _playTimeLabel.adjustsFontSizeToFitWidth = YES;
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.textColor = [UIColor whiteColor];
    }
    return _playTimeLabel;
}

/** 视频总时间 */
- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.textColor = [UIColor whiteColor];
    }
    return _totalTimeLabel;
}


/** 播放进度条 */
- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc]init];
        _progress.progressTintColor = [UIColor whiteColor];
        _progress.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _progress;
}

/** 滑杆 */
- (SelVideoSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider = [[SelVideoSlider alloc]init];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        //开始拖动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        //拖动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //结束拖动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    }
    return _videoSlider;
}

#pragma mark - 滑杆
/** 开始拖动事件 */
- (void)progressSliderTouchBegan:(SelVideoSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderTouchBegan:)]) {
        [_delegate videoSliderTouchBegan:slider];
    }
}
/** 拖动中事件 */
- (void)progressSliderValueChanged:(SelVideoSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderValueChanged:)]) {
        [_delegate videoSliderValueChanged:slider];
    }
}
/** 结束拖动事件 */
- (void)progressSliderTouchEnded:(SelVideoSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderTouchEnded:)]) {
        [_delegate videoSliderTouchEnded:slider];
    }
}

/** 播放按钮点击事件 */
- (void)playAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(playButtonAction:)]) {
        [_delegate playButtonAction:button.selected];
    }
}

/** 全屏切换按钮点击事件 */
- (void)fullScreenAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(fullScreenButtonAction)]) {
        [_delegate fullScreenButtonAction];
    }
}

/** 控制面板单击事件 */
- (void)tap:(UIGestureRecognizer *)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapGesture)]) {
        [_delegate tapGesture];
    }
}

/** 控制面板双击事件 */
- (void)doubleTap:(UIGestureRecognizer *)gesture
{   
    if (_delegate && [_delegate respondsToSelector:@selector(doubleTapGesture)]) {
        [_delegate doubleTapGesture];
    }
}


@end
