//
//  UIQueryScrollView.h
//  UISpec
//

#import "UIQuery.h"

@interface UIQueryScrollView : UIQuery {

}

-(UIQuery *)scrollDown:(int)offset;
-(UIQuery *)scrollToBottom;

@end
