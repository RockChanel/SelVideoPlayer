//
//  SelMainViewController.m
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SelMainViewController.h"
#import "SelVideoViewController.h"

@interface SelMainViewController ()

@end

@implementation SelMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.center = self.view.center;
    play.bounds = CGRectMake(0, 0, 200, 100);
    [play setTitle:@"点击播放网络视频" forState:UIControlStateNormal];
    play.backgroundColor = [UIColor blackColor];
    [play setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [play addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:play];
}

- (void)playAction
{
    SelVideoViewController *videoVC = [[SelVideoViewController alloc]init];
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
