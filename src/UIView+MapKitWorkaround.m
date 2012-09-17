//
//  UIView+MapKitWorkaround.m
//  Frank
//
//  Created by Pete Hodgson on 8/12/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(UIView_MapKitWorkaround)

@implementation UIView(MapKitWorkaround) 
- (id)_mapkit_hasPanoramaID { 
	return nil; 
}
@end