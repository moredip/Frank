//
//  UIQueryScrollView.h
//  UISpec
//

#import "UIQuery.h"

@interface UIQueryScrollView : UIQuery {

}

-(UIQuery*)scrollToTop;
-(UIQuery *)scrollDown:(int)offset;
-(UIQuery *)scrollToBottom;

@end
