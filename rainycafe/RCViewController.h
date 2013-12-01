//
//  RCViewController.h
//  rainycafe
//
//  Created by geta6 on 11/30/13.
//  Copyright (c) 2013 geta6. All rights reserved.
//

@interface RCViewController : UIViewController <UIGestureRecognizerDelegate>
{
  __weak IBOutlet UIView* rainView;
  __weak IBOutlet UIView* confView;
  UIView *overlayMaskView;
}

@end
