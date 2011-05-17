
#import "UIQueryWebView.h"

@implementation UIQueryWebView

-(UIQuery *)setValue:(NSString *)value forElementWithId:(NSString *)elementId {
	//NSString *javascript = [NSString stringWithFormat:@"$('#%@').val('%@');", elementId, value];
	NSString *javascript = [NSString stringWithFormat:@"document.getElementById('%@').value = '%@';", elementId, value];
	
	//if(![self jQuerySupported])
//		[self injectjQuery];
	
	[self stringByEvaluatingJavaScriptFromString:javascript];
	return [UIQuery withViews:views className:className];
}

-(UIQuery *)clickElementWithId:(NSString *)elementId {	
	//NSString *javascript = [NSString stringWithFormat:@"$('#%@').click();", elementId];
	NSString *javascript = [NSString stringWithFormat:@"document.getElementById('%@').click();", elementId];
	//if(![self jQuerySupported]) 
//		[self injectjQuery];
	
	//	javascript = [NSString stringWithFormat:@"$('#%@').click();", elementId];
//	else 
//		javascript = [NSString stringWithFormat:@"document.getElementById('%@').click();", elementId];
	
	[self stringByEvaluatingJavaScriptFromString:javascript];
	return [UIQuery withViews:views className:className];
}

-(void) injectjQuery {
	NSLog(@"Injecting jQuery");
	NSString *jQueryInjection = @"var headElement = document.getElementsByTagName('head')[0]; var script = document.createElement('script'); script.setAttribute('src','http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js'); script.setAttribute('type','text/javascript'); headElement.appendChild(script);";
	[self stringByEvaluatingJavaScriptFromString: jQueryInjection];	
}

-(BOOL) jQuerySupported {
	
	UIWebView *theWebView = self;
	NSString *html = [theWebView stringByEvaluatingJavaScriptFromString: @"document.documentElement.innerHTML"];
	
	BOOL isJQuerySupported = [html rangeOfString:@"jquery"].location != NSNotFound;
	
	NSLog(@"jQuery Supported : %d", isJQuerySupported);
	return isJQuerySupported;
}

-(NSString *) html {
	return [self stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
}

@end
