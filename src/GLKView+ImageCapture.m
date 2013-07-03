//
//  GLKView+ImageCapture.m
//  Frank
//
//  Created by Toshiyuki Suzumura on 2013/07/03.
//

#import "GLKView+ImageCapture.h"

@implementation GLKView (ImageCapture)

- (UIImage*)captureImage {
    return [self snapshot];
}

@end
