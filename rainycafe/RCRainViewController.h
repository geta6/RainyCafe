//
//  RCRainViewController.h
//  rainycafe
//
//  Created by geta6 on 12/1/13.
//  Copyright (c) 2013 geta6. All rights reserved.
//

@interface RCRainViewController : UIViewController <UIWebViewDelegate>
{
  __weak IBOutlet UIWebView* mainView;
  __weak IBOutlet UIImageView* backView;
  Boolean didLoadWebView;
}

@end
