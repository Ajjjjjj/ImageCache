//
//  WebHandlerClass.h
//
//  Copyright © 2016 Ajay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebHandlerClass;
//Delegate Methods for WebHandler Success and failure
@protocol WebHandlerDelegate <NSObject>
-(void)responseSuccessWithObject : (id)responseObject webservice:(WebHandlerClass*)handler;
-(void)failedWithError : (NSError*)error webservice:(WebHandlerClass*)handler;
@end


@interface WebHandlerClass : NSObject
@property (weak,nonatomic)      id<WebHandlerDelegate> webserviceDelegate;

+(WebHandlerClass*)sharedInstance;

-(void)unSplashWebCall:(NSURL*)url;

-(void)downloadImage:(NSURL *)url completion:(void (^)(UIImage *image))completion;

@end
