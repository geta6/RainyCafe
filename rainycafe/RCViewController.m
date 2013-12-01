//
//  RCViewController.m
//  rainycafe
//
//  Created by geta6 on 11/30/13.
//  Copyright (c) 2013 geta6. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RCViewController.h"

@implementation RCViewController

- (void)viewDidLoad
{
  DBGMSG(@"%s", __func__);
  [super viewDidLoad];
  overlayMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  [overlayMaskView setBackgroundColor:[UIColor blackColor]];
  [overlayMaskView setAlpha:.0f];
  [overlayMaskView setHidden:YES];
  [rainView addSubview:overlayMaskView];
  [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
  DBGMSG(@"%s", __func__);
  [super viewDidAppear:animated];
  [self.view setFrame:[[UIScreen mainScreen] bounds]];
  [rainView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  [confView setFrame:CGRectMake(self.view.frame.size.width, 0, confView.frame.size.width, self.view.frame.size.height)];
  [confView.layer setMasksToBounds:NO];
  [confView.layer setShadowOffset:CGSizeMake(0, 0)];
  [confView.layer setShadowColor:[[UIColor blackColor] CGColor]];
  [confView.layer setShadowRadius:5.0f];
}

- (void)didReceiveMemoryWarning
{
  DBGMSG(@"%s", __func__);
  [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (IBAction)didSwipeScreen:(UISwipeGestureRecognizer *)gesture
{
  DBGMSG(@"%s", __func__);
  switch ([gesture direction]) {
    case UISwipeGestureRecognizerDirectionLeft: {
      [overlayMaskView setAlpha:.0f];
      [overlayMaskView setHidden:NO];
      [UIView animateWithDuration:.24f animations:^(void) {
        [rainView setFrame:CGRectMake(-1 * confView.frame.size.width / 4, 0, rainView.frame.size.width, rainView.frame.size.height)];
        [confView setFrame:CGRectMake(self.view.frame.size.width - confView.frame.size.width, 0, confView.frame.size.width, confView.frame.size.height)];
        [confView.layer setShadowOpacity:.6f];
        [overlayMaskView setAlpha:.48f];
      }];
      break;
    }

    case UISwipeGestureRecognizerDirectionRight: {
      [UIView animateWithDuration:.24f animations:^(void) {
        [rainView setFrame:CGRectMake(0, 0, rainView.frame.size.width, rainView.frame.size.height)];
        [confView setFrame:CGRectMake(self.view.frame.size.width, 0, confView.frame.size.width, confView.frame.size.height)];
        [confView.layer setShadowOpacity:.0f];
        [overlayMaskView setAlpha:.0f];
      } completion:^(BOOL finished) {
        [overlayMaskView setHidden:NO];
      }];
      break;
    }

    default:
      break;
  }
}

@end
