
#import "UIInspector.h"
#import "objc/runtime.h"  
#import "UIBug.h"
#import "NSNumberCreator.h"

@implementation UIInspector

@synthesize targetView, targetSubviews, properties;

static BOOL inBrowserMode = YES;

+(void)setInBrowserMode:(BOOL)yesOrNo {
	inBrowserMode = yesOrNo;
}

+(BOOL)inBrowserMode {
	return inBrowserMode;
}

-(id)initWithView:(UIView *)_targetView {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.targetView = _targetView;
		if ([_targetView respondsToSelector:@selector(subviews)]) {
			self.targetSubviews = targetView.subviews;
		} else if ([_targetView respondsToSelector:@selector(windows)]) {
			self.targetSubviews = [targetView windows];
		} else {
			self.targetSubviews = [NSArray array];
		}
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exit)] autorelease];
		[self loadProperties];
	}
	return self;
}

-(void)exit {
	[self.navigationController popToRootViewControllerAnimated:NO];
	[self.navigationController.view removeFromSuperview];
	[UIBug unhighlight];
}

-(void)loadProperties {
	self.properties = [UIQuery describe:targetView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//NSLog(@"targetView title = %@", NSStringFromClass([targetView class]));
	return section == 0 ? NSStringFromClass([targetView class]) : @"Children";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		//NSLog(@"properties numrow in section = %d", [properties allKeys].count);
		return [properties allKeys].count;
	} else {
		return targetSubviews.count;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	if (indexPath.section == 0) {
		NSString *key = [NSString stringWithFormat:@"%@ :",[[properties allKeys] objectAtIndex:indexPath.row]];
		id object = [properties objectForKey:[[properties allKeys] objectAtIndex:indexPath.row]];
		NSString *value = [NSString stringWithFormat:@" %@", object];
		CGSize valueSize = [value sizeWithFont:[UIFont systemFontOfSize:18]];
		CGSize keySize = [key sizeWithFont:[UIFont systemFontOfSize:18]];
		if (valueSize.width + keySize.width > 260) {
			UILabel *keyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, keySize.width, keySize.height)] autorelease];
			keyLabel.text = key;
			[cell.contentView addSubview:keyLabel];
			
			UILabel *valueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, keySize.height, valueSize.width, valueSize.height)] autorelease];
			valueLabel.text = value;
			[cell.contentView addSubview:valueLabel];
		} else {
			cell.textLabel.text = [NSString stringWithFormat:@"%@%@", key, value];
		}
		if (![object isKindOfClass:[NSString class]]) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	} else {
		UIView *subView = [targetSubviews objectAtIndex:indexPath.row];
		UIGraphicsBeginImageContext(subView.bounds.size);
		[subView.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		NSString *text = NSStringFromClass([subView class]);
		
		CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:18]];
		CGSize imageSize = viewImage.size;
		
		//NSLog(@"text width:%f height:%f", textSize.width, textSize.height);
//		NSLog(@"imageSize width:%f height:%f", imageSize.width, imageSize.height);
		
		if (textSize.width + imageSize.width > 260) {
			[cell.contentView addSubview:[[[UIImageView alloc] initWithImage:viewImage] autorelease]];
			UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, imageSize.height, textSize.width, textSize.height)] autorelease];
			textLabel.text = text;
			[cell.contentView addSubview:textLabel];
		} else {
			cell.imageView.image = viewImage;
			cell.textLabel.text = text;
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	//NSLog(@"cell text= %@", cell.text);
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		[self.navigationController pushViewController:[[[UIInspector alloc] initWithView:[properties objectForKey:[[properties allKeys] objectAtIndex:indexPath.row]]] autorelease] animated:YES];
	} else {
		[self.navigationController pushViewController:[[[UIInspector alloc] initWithView:[targetSubviews objectAtIndex:indexPath.row]] autorelease] animated:YES];
	}
}


//+(void)describe:(id)object {
//	struct objc_ivar_list *ivars = [object class]->ivars;
//	unsigned c = ivars->ivar_count;
//	unsigned i;
//	id objValue;
//	int intValue;
//	long longValue;
//	char *charPtrValue;
//	char charValue;
//	short shortValue;
//	float floatValue;
//	double doubleValue;
//	
//	NSMutableString *s = [[[NSMutableString alloc] init] autorelease];
//	
//    [s appendString:[object description]];
//    [s appendString:@"\n"];
//	
//	for (i=0;i<c;i++) {
//		const char *ivar_name = ivars->ivar_list[i].ivar_name;
//		const char *ivar_type = ivars->ivar_list[i].ivar_type;
//		
//		NSString *returnType = [NSString stringWithFormat:@"%s", ivar_type];
//		NSLog(@"return type = %@", returnType);
//		
//		[s appendFormat:@"\n%s\n",ivar_name];
//		switch(*ivar_type) {
//			case '@':
//				object_getInstanceVariable(object,ivar_name,(void **)&objValue);
//				if ([objValue respondsToSelector:@selector(description)]) {
//					[s appendFormat:@"%@\n",[objValue description]];
//				} else {                 
//					[s appendString:@"\n"];
//				}
//				break;
//			case 'i':
//				object_getInstanceVariable(object,ivar_name,(void **)&intValue);
//				[s appendFormat:@"%d\n",intValue];
//				break;
//			case 's':
//				object_getInstanceVariable(object,ivar_name,(void **)&shortValue);
//				[s appendFormat:@"%ud\n",shortValue];
//				break;
//			case 'd':
//				object_getInstanceVariable(object,ivar_name,(void **)&doubleValue);
//				[s appendFormat:@"lf\n",doubleValue];
//				break;
//			case 'f':
//				object_getInstanceVariable(object,ivar_name,(void **)&floatValue);
//				[s appendFormat:@"%f\n",floatValue];
//				break;
//			case 'l':
//				object_getInstanceVariable(object,ivar_name,(void **)&longValue);
//				[s appendFormat:@"%ld\n",longValue];
//				break;
//			case '*':
//				object_getInstanceVariable(object,ivar_name,(void **)&charPtrValue);
//				[s appendFormat:@"%s\n",charPtrValue];
//				break;
//			case 'c':
//				object_getInstanceVariable(object,ivar_name,(void **)&charValue);
//				[s appendFormat:@"%d\n",charValue];
//				break;
//		}
//	}
//    NSLog(s);
//}



- (void)dealloc {
	self.targetView = nil;
	self.properties = nil;
	self.targetSubviews = nil;
    [super dealloc];
}


@end

