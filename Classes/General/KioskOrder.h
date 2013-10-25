//
//  KioskOrder.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/28/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KioskOrder : NSObject{
    NSString *acctID;
    NSArray *OrderItems;
}

@property (retain) NSString* acctID;
@property (retain) NSArray* OrderItems;

@end
