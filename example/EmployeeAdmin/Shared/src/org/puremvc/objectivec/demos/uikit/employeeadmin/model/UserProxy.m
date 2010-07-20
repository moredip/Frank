//
//  UserProxy.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserProxy.h"
#import "UserVO.h"

@implementation UserProxy

-(void)initializeProxy {
	[super initializeProxy];
	self.proxyName = [UserProxy NAME];
	self.data = [NSMutableArray array];
	[self create:[UserVO withUserName:@"lstooge" firstName:@"Larry" lastName:@"Stooge" email:@"larry@stooges.com" password:@"ijk456" confirmPassword:@"ijk456" department:@"Accounting"]];
	[self create:[UserVO withUserName:@"cstooge" firstName:@"Curly" lastName:@"Stooge" email:@"curly@stooges.com" password:@"xyz987" confirmPassword:@"xyz987" department:@"Sales"]];
	[self create:[UserVO withUserName:@"mstooge" firstName:@"Moe" lastName:@"Stooge" email:@"moe@stooges.com" password:@"abc123" confirmPassword:@"abc123" department:@"Plant"]];
}

+(NSString *)NAME {
	return @"UserProxy";
}

-(NSMutableArray *)data {
	return data;
}

-(void)create:(id)item {
	[self.data addObject:item];
}

-(void)update:(id)item {
	for (int i=0; i<[self.data count]; i++) {
		UserVO *userVO = [self.data objectAtIndex:i];
		if ([userVO.username isEqualToString:[item username]]) {
			[self.data replaceObjectAtIndex:i withObject:item];
			break;
		}
	}
}

-(void)delete:(id)item {
	for (int i=0; i<[self.data count]; i++) {
		UserVO *userVO = [self.data objectAtIndex:i];
		if ([userVO.username isEqualToString:[item username]]) {
			[self.data removeObjectAtIndex:i];
			break;
		}
	}
}

-(void)dealloc {
	[super dealloc];
}

@end
