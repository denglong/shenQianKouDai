//
//  MyPlayGround.m
//  KingProFrame
//
//  Created by denglong on 9/23/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "MyPlayGround.h"

@implementation MyPlayGround

- (id)initSystemShake {
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType {
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@", soundName, soundType];
        [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:soundName ofType:soundType];
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
            
            if (error != kAudioServicesNoError) {
                sound = 0;
            }
        }
    }
    return self;
}

- (void)play {
    AudioServicesPlaySystemSound(sound);
}


@end
