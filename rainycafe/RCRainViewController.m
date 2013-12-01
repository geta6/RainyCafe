//
//  RCRainViewController.m
//  rainycafe
//
//  Created by geta6 on 12/1/13.
//  Copyright (c) 2013 geta6. All rights reserved.
//

#import "RCRainViewController.h"

@implementation RCRainViewController

- (void)viewDidLoad
{
  DBGMSG(@"%s", __func__);
  [super viewDidLoad];
  [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"www/index" ofType:@"html"]]]];
  [mainView setScalesPageToFit:YES];
//  for(id subview in mainView.subviews) {
//    if([[subview class] isSubclassOfClass:[UIScrollView class]]) {
//      [((UIScrollView *) subview) setBounces:NO];
//      [((UIScrollView *) subview) setScrollEnabled:NO];
//    }
//  }
  didLoadWebView = NO;
  [self rain:@"city"];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rainNotification:) name:@"rain" object:nil];
}

- (void)didReceiveMemoryWarning
{
  DBGMSG(@"%s", __func__);
  [super didReceiveMemoryWarning];
}

- (void)rain: (NSString *)identifier
{
  DBGMSG(@"%s %@", __func__, [NSString stringWithFormat:@"rain('%@');", identifier]);
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"www/img/%@", identifier] ofType:@"jpg"];
  [backView setImage:[UIImage imageWithContentsOfFile:imagePath]];
  [mainView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"rain('%@');", identifier]];
}

- (void)rainNotification: (NSNotification *)notification
{
  DBGMSG(@"%s", __func__);
  [self rain:[notification.userInfo objectForKey:@"id"]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  DBGMSG(@"%s", __func__);
  if (!didLoadWebView) {
    didLoadWebView = YES;
    [self rain:@"city"];
  }
}

- (IBAction)changeView:(UIButton *)button
{
  [self rain:button.titleLabel.text];
}

@end
