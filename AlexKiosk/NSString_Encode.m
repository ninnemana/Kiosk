//
//  NSString_Encode.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/13/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import "NSString_Encode.h"

@implementation NSString (encode)
- (NSString *)encodeString:(NSStringEncoding)encoding
{
    return (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
                                                                NULL, (CFStringRef)@";/?:@&=$+{}<>,",
                                                                CFStringConvertNSStringEncodingToEncoding(encoding));
}  
@end
