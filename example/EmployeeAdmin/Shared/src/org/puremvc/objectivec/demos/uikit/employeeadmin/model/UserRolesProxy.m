//
//  UserRolesProxy.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserRolesProxy.h"

@implementation UserRolesProxy

-(void)initializeProxy {
	[super initializeProxy];
	self.proxyName = [UserRolesProxy NAME];
	self.data = [NSMutableArray array];
	[self update:[UserRolesVO withUsername:@"lstooge" roles:[NSMutableArray arrayWithObjects:@"Payroll", @"Employee Benefits", nil]]];
	[self update:[UserRolesVO withUsername:@"cstooge" roles:[NSMutableArray arrayWithObjects:@"Accounts Payable", @"Accounts Receivable", @"General Ledger", nil]]];
	[self update:[UserRolesVO withUsername:@"mstooge" roles:[NSMutableArray arrayWithObjects:@"Inventory", @"Production", @"Sales", @"Shipping", nil]]];
}

+(NSString *)NAME {
	return @"UserRolesProxy";
}

-(NSMutableArray *)data {
	return data;
}

-(UserRolesVO *)findByUsername:(NSString *)username {
	for (int i=0; i<[self.data count]; i++) {
		UserRolesVO *userRolesVO = [self.data objectAtIndex:i];
		if ([userRolesVO.username isEqualToString:username]) {
			return userRolesVO;
		}
	}
	return [UserRolesVO withUsername:username roles:[NSMutableArray array]];
}

-(void)update:(id)item {
	for (int i=0; i<[self.data count]; i++) {
		UserRolesVO *userRolesVO = [self.data objectAtIndex:i];
		if ([userRolesVO.username isEqualToString:[item username]]) {
			[self.data replaceObjectAtIndex:i withObject:item];
			return;
		}
	}
	[self.data addObject:item];
}

@end
