//
//  RCConfViewController.m
//  rainycafe
//
//  Created by geta6 on 12/1/13.
//  Copyright (c) 2013 geta6. All rights reserved.
//

#import "RCConfViewController.h"

#define TIMEEXEC .005f
#define DIFFVOLS  .01f

@implementation RCConfViewController

- (void)viewDidLoad
{
  DBGMSG(@"%s", __func__);
  [super viewDidLoad];

  rainComponents = [[NSMutableArray alloc] init];

  NSError *cafeError;
  NSError *rainError;
  cafePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cafe" ofType:@"caf"]] error:&cafeError];
  rainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"caf"]] error:&rainError];

  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
  [[AVAudioSession sharedInstance] setActive:YES error:nil];

  if (cafeError != nil || rainError != nil) {
    NSLog(@"Cafe: %@", cafeError);
    NSLog(@"Rain: %@", rainError);
  } else {
    [cafePlayer setDelegate:self];
    [rainPlayer setDelegate:self];
    [cafePlayer setNumberOfLoops: -1];
    [rainPlayer setNumberOfLoops: -1];
    [self fadeInAudio:cafePlayer to:cafeSlider.value callback:nil];
    [self fadeInAudio:rainPlayer to:rainSlider.value callback:nil];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www/img"] error:nil];
  rainComponents = [[NSMutableArray alloc] init];
  int currentIndex = 0;
  for (int index = 0; index < [images count]; index++) {
    NSString *image = [[images objectAtIndex:index] stringByReplacingOccurrencesOfString:@".jpg" withString: @""];
    [rainComponents addObject:image];
    if ([image isEqualToString:@"city"]) {
      currentIndex = index;
    }
  }
  [rainycafePicker reloadAllComponents];
  [rainycafePicker selectRow:currentIndex inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
  DBGMSG(@"%s", __func__);
  [super didReceiveMemoryWarning];
}

- (void)fadeInAudio:(AVAudioPlayer *)player to:(float)toVolume callback:(void (^)())callback
{
  if (player.playing) {
    if (player.volume + DIFFVOLS < toVolume) {
      [NSTimer scheduledTimerWithTimeInterval:TIMEEXEC target:[NSBlockOperation blockOperationWithBlock:^{
        [player setVolume:player.volume + DIFFVOLS];
        [self fadeInAudio:player to:toVolume callback:callback];
      }] selector:@selector(main) userInfo:nil repeats:NO];
    } else {
      [player setVolume:toVolume];
      if (callback != nil) {
        callback();
      }
    }
  } else {
    [player setVolume:.0f];
    [player play];
    [self fadeInAudio:player to:toVolume callback:callback];
  }
}

- (void)fadeOutAudio:(AVAudioPlayer *)player callback:(void (^)())callback
{
  if (.0f < player.volume - DIFFVOLS) {
    [NSTimer scheduledTimerWithTimeInterval:TIMEEXEC target:[NSBlockOperation blockOperationWithBlock:^{
      [player setVolume:player.volume - DIFFVOLS];
      [self fadeOutAudio:player callback:callback];
    }] selector:@selector(main) userInfo:nil repeats:NO];
  } else {
    [player setVolume:.0f];
    [player stop];
    if (callback != nil) {
      callback();
    }
  }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [rainComponents count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [rainComponents objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  DBGMSG(@"%s", __func__);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"rain" object:self userInfo:@{@"id": [rainComponents objectAtIndex:row]}];
}

- (IBAction)switchCafePlayer
{
  DBGMSG(@"%s", __func__);
  [cafeSwitch setEnabled:NO];
  if (cafeSwitch.on) {
    [self fadeInAudio:cafePlayer to:cafeSlider.value callback:^(void) {
      [cafeSwitch setEnabled:YES];
    }];
  } else {
    [self fadeOutAudio:cafePlayer callback:^(void) {
      [cafeSwitch setEnabled:YES];
    }];
  }
}

- (IBAction)switchRainPlayer
{
  DBGMSG(@"%s", __func__);
  [rainSwitch setEnabled:NO];
  if (rainSwitch.on) {
    [self fadeInAudio:rainPlayer to:rainSlider.value callback:^(void) {
      [rainSwitch setEnabled:YES];
    }];
  } else {
    [self fadeOutAudio:rainPlayer callback:^(void) {
      [rainSwitch setEnabled:YES];
    }];
  }
}

- (IBAction)slideCafePlayer
{
  DBGMSG(@"%s", __func__);
  [cafePlayer setVolume:cafeSlider.value];
}

- (IBAction)slideRainPlayer
{
  DBGMSG(@"%s", __func__);
  [rainPlayer setVolume:rainSlider.value];
}

@end
