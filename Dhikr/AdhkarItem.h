//
//  NSObject+AdhkarItem.h
//  Dhikr
//
//  Created by Umayah Abdennabi on 5/25/15.
//  Copyright (c) 2015 9qbd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdhkarItem : NSObject <NSCoding>

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSMutableArray *dhikr;
@property (nonatomic, readwrite) NSMutableArray *times;

- (instancetype) initWithDhikirName:(NSString *)name dhikr:(NSMutableArray *)dhikr times:(NSMutableArray *)times;

@end
