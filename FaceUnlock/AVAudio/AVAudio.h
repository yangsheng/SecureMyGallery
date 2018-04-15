//
//  AVAudio.h
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//Protocol

@protocol MusicPlayerDelegate <NSObject>

-(void) playbackStartedForMusicKey: (NSString *) key;

-(void) playbackStoppedForMusicKey: (NSString *) key;

-(void) playbackFinishedForMusicKey: (NSString *) key;

@end

@interface AVAudio : NSObject<AVAudioPlayerDelegate> {
    NSMutableDictionary *sounds;
    NSMutableArray *music;
    AVAudioPlayer *musicPlayer;
    NSString *musicKey;
    id<MusicPlayerDelegate> __weak delegate;
}

//Singleton

+ (AVAudio *)sharedAudio;

//Propertis

@property (nonatomic, strong) NSMutableDictionary *sounds;
@property (nonatomic, strong) NSMutableArray *music;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) NSString *musicKey;
@property (nonatomic, weak) id<MusicPlayerDelegate> delegate;

//Sound effects control

-(void) playSound: (NSString *) key;

-(void) playLoopingSound: (NSString *) key;

-(void) stopSound: (NSString *) key;

-(void) stopLoopingSounds;

-(void) stopAllSounds;

//Music control

-(void) playMusicKey: (NSString *) key;

-(void) stopMusic;

//Volume control

-(void) setGeneralVolume: (float) vol;

-(void) setVolume: (float) vol forSound: (NSString *) key;

@end