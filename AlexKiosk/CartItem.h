//
//  CartItem.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/24/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartItem : NSObject{
    NSString *partID;
    NSString *shortDesc;
    NSString *price;
    NSNumber *quantity;
    NSDictionary *part;
}

@property (retain) NSString* partID;
@property (retain) NSString* shortDesc;
@property (retain) NSString *price;
@property (retain) NSNumber* quantity;
@property (retain) NSDictionary* part;

@end
