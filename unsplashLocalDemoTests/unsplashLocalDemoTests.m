//
//  unsplashLocalDemoTests.m
//  unsplashLocalDemoTests
//
//  Created by Ajay kumar on 03/01/17.
//  Copyright © 2017 iMorale. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UnSplashViewController.h"
@interface unsplashLocalDemoTests : XCTestCase
{
    
}
@property (nonatomic) UnSplashViewController *vcToTest;
@end

@implementation unsplashLocalDemoTests

- (void)setUp {
    [super setUp];
    self.vcToTest = [[UnSplashViewController alloc] init];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}




-(void)testPerformanceofCall{
    
    
    
    
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    [self measureBlock:^{
        [self.vcToTest webCallMethod];
    }];

}

@end
