//
//  RCConfViewController.h
//  rainycafe
//
//  Created by geta6 on 12/1/13.
//  Copyright (c) 2013 geta6. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface RCConfViewController : UIViewController <AVAudioPlayerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
  __weak IBOutlet UISwitch *cafeSwitch;
  __weak IBOutlet UISwitch *rainSwitch;
  __weak IBOutlet UISlider *cafeSlider;
  __weak IBOutlet UISlider *rainSlider;
  __weak IBOutlet UIPickerView *rainycafePicker;
  __strong AVAudioPlayer *cafePlayer;
  __strong AVAudioPlayer *rainPlayer;
  __strong NSMutableArray *rainComponents;
}

@end
