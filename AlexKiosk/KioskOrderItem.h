//
//  KioskOrderItem.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/28/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KioskOrderItem : NSObject{
    NSString *partID;
    NSNumber *qty;
    NSString *price;
}

@property (retain) NSString* partID;
@property (retain) NSNumber* qty;
@property (retain) NSString *price;

@end
