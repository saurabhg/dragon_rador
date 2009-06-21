//
//  FriendTest.h
//  DragonRador
//
//  Created by Motohiro Takayama on 6/21/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>

@class Friend;

@interface FriendTest : SenTestCase
{
   Friend *friend;
}

@end
