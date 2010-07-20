//
//  UserRolesEnum.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserRolesEnum.h"


@implementation UserRolesEnum

+(NSArray *)list {
	return [NSArray arrayWithObjects:@"Administrator", @"Accounts Payable", @"Accounts Receivable", @"Employee Benefits", @"General Ledger", @"Payroll", @"Inventory", @"Production", @"Quality Control", @"Sales", @"Orders", @"Customers", @"Shipping", @"Returns", nil];
}

@end
