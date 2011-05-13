

#import "UIConsole.h"
#import "UIQuery.h"
#import "UIBug.h"

@implementation MyTextField : UITextField

-(BOOL)becomeFirstResponder {
	[super becomeFirstResponder];
	[UIBug removeKeyboardIfExists];
	return YES;
}

@end

@implementation UIConsole

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0,20,320,16)]) {
		self.backgroundColor = [UIColor whiteColor];
        scriptField = [[MyTextField alloc] initWithFrame:CGRectMake(0, 0, 265, 16)];
		scriptField.autocorrectionType = UITextAutocorrectionTypeNo;
		scriptField.font = [UIFont systemFontOfSize:13];
		scriptField.placeholder = @"Enter Script";
		[self addSubview:scriptField];
		
		UIButton *goButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		goButton.frame = CGRectMake(265, 0, 30, 16);
		goButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[goButton setTitle:@"Run" forState:UIControlStateNormal];
		[goButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:goButton];
		
		UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		exitButton.frame = CGRectMake(300, 0, 20, 16);
		exitButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[exitButton setTitle:@"X" forState:UIControlStateNormal];
		[exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:exitButton];
		
		[scriptField becomeFirstResponder];
    }
    return self;
}

-(void)go {
	$(scriptField.text);
}

-(void)exit {
	[self removeFromSuperview];
}

- (void)dealloc {
	[scriptField release];
    [super dealloc];
}


@end

