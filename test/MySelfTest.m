//
//  MySelfTest.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/16/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "MySelfTest.h"
#import "MySelf.h"

@implementation MySelfTest

- (void) setUp
{
   my_self = [[MySelf alloc] initWithName:@"hoge" password:@"fuga"];
}

- (void) tearDown
{
   [my_self release];
}

- (void) testMath
{
   STAssertNotNil(my_self, @"instance check");
}

- (void) testToggleVisible
{
   STAssertTrue(my_self.visible, @"default is visible");
}

@end
