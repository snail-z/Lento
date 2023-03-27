//
//  MAViewController.m
//  MADebugMagic
//
//  Created by zhanghao on 03/23/2023.
//  Copyright (c) 2023 zhanghao. All rights reserved.
//

#import "MAViewController.h"
#import <MADebugMagic.h>

@interface MAViewController ()

@end

@implementation MAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MADebugActionLogItem *item = [MADebugActionLogItem new];
    item.className = NSStringFromClass(self.class);
    [MADebugLogManager.shared save:item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
