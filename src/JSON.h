//
//  JSON.h
//  Frank
//
//  Created by Pete Hodgson on 10/19/12.
//
//

#ifndef Frank_JSON_h
#define Frank_JSON_h

#import "AnyJSON.h"

#define TO_JSON(obj) ([[[NSString alloc] initWithData:AnyJSONEncode((obj), nil) encoding:NSUTF8StringEncoding] autorelease])

#define FROM_JSON(str) (AnyJSONDecode([(str) dataUsingEncoding:NSUTF8StringEncoding], nil))

#endif
