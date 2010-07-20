
#import "UIQuerySearchBar.h"

@implementation UIQuerySearchBar

-(UIQuery *)searchWithText:(NSString *)searchText {
	UISearchBar *theSearchBar = self;
	[theSearchBar becomeFirstResponder];
	[theSearchBar setText:searchText];
	[theSearchBar.delegate searchBarSearchButtonClicked:theSearchBar];
	return [UIQuery withViews:views className:className];
}

@end
