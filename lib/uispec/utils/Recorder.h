#import <Foundation/Foundation.h>

@interface Recorder : NSObject {
	NSMutableArray* eventList;
	id playbackDelegate;
	SEL playbackDoneSelector;
}

+(Recorder *)sharedRecorder;
-(void)record;
-(void)saveToFile:(NSString*)path;
-(void)load:(NSArray*)events;
-(void)loadFromFile:(NSString*)path;
-(void)playbackWithDelegate:(id)delegate doneSelector:(SEL)selector;
-(void)stop;

@end
