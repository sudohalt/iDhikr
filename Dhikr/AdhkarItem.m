/*  The MIT License (MIT)
 *
 *  Copyright (c) 2015 Umayah Abdennabi
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

//
//  NSObject+AdhkarItem.m
//

#import "AdhkarItem.h"

@implementation AdhkarItem

@synthesize name;
@synthesize dhikr;
@synthesize times;

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.dhikr = [aDecoder decodeObjectForKey:@"dhikr"];
        self.times = [aDecoder decodeObjectForKey:@"times"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.dhikr forKey:@"dhikr"];
    [aCoder encodeObject:self.times forKey:@"times"];
}


- (instancetype) initWithDhikirName:(NSString *)n dhikr:(NSMutableArray *)d times:(NSMutableArray *)t {
    NSUInteger dcount = [d count];
    NSUInteger tcount = [t count];
    if (dcount < tcount) {
        for (NSUInteger i = dcount; dcount < tcount; i++) {
            [d addObject:@"empty"];
        }
    } else if (dcount > tcount) {
        for (NSUInteger i = tcount; tcount < dcount; i++) {
            [t addObject:[NSNumber numberWithInt:0]];
        }
    }
    self = [super init];
    self.name = n;
    self.dhikr = d;
    self.times = t;
    return self;
}

@end
