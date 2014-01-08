#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>

@interface SBAppSliderScrollingViewController{
    NSMutableArray *_items;
    int _layoutOrientation;
}
@end

@interface SBAppSliderScrollView : UIScrollView
@end

%hook SBAppSliderScrollingViewController

- (void)scrollViewWillEndDragging:(SBAppSliderScrollView *)arg1 withVelocity:(CGPoint)arg2 targetContentOffset:(CGPoint)arg3 {

    if (arg1.contentOffset.y < -20.0 && arg2.y < -2.0) {
        NSUInteger orientation = MSHookIvar<int>(self, "_layoutOrientation");
        CGFloat cardWidth = ((orientation == UIInterfaceOrientationPortrait) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)/2;
        CGFloat cardLocation = arg1.frame.origin.x;
        CGFloat switcherSize = cardWidth * (MSHookIvar<NSMutableArray *>(self, "_items")).count;

        // Even better normalize note index. Mod it by 7 so the octave repeats itself.
        int noteIndex = round(cardLocation) % 7;
        
        CFURLRef soundFileURLRef;
        soundFileURLRef = (CFURLRef)[NSURL URLWithString:[NSString stringWithFormat:@"/Library/MusicalSwitcher/note%i.m4a",  noteIndex]];
        UInt32 soundID;
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }

    %orig;
}

%end
