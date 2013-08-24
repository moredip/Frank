//
//  SaveScreenshotInCameraRollCommand.m
//  Frank
//
//  Created by Sergio Padrino on 22/08/13.
//
//

#import "SaveScreenshotInCameraRollCommand.h"

#import "FranklyProtocolHelper.h"
#import "UIImage+Frank.h"

@interface SaveScreenshotInCameraRollCommand ()

@property (nonatomic, assign) NSUInteger numberOfPhotos;
@property (nonatomic, retain) UIImage *screenshot;

@end

@implementation SaveScreenshotInCameraRollCommand

- (void)dealloc
{
    [_screenshot release];
    
    [super dealloc];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    self.numberOfPhotos = [requestBody integerValue];

    self.screenshot = [UIImage imageFromApplication:YES
                                   resultInPortrait:UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])];

    // This code is running in the main thread and UIImageWriteToSavedPhotosAlbum also calls its callback in the main
    // thread. Therefore, it's impossible to make this process completely synchronous as needed (waiting for all the
    // images to be saved and then return the results), so all we can do is start a chain of calls for saving the images
    // and hope for the app to live long enough so that all the images are written in the camera roll.
    [self saveScreenshotInPhotosAlbum];

    return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    self.numberOfPhotos -= 1;

    // Continue saving images until all have been saved
    if (self.numberOfPhotos > 0) {
        [self saveScreenshotInPhotosAlbum];
    }
    else {
        self.screenshot = nil;
    }
}

- (void)saveScreenshotInPhotosAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.screenshot, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

@end
