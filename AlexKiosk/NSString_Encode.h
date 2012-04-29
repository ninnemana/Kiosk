//
//  NSString_Encode.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/13/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encode)
- (NSString *)encodeString:(NSStringEncoding)encoding;
@end
