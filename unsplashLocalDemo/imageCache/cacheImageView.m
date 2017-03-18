//
//  cacheImageView.m
//  unsplashLocalDemo
//
//  Created by Ajay kumar on 04/01/17.
//  Copyright © 2017 iMorale. All rights reserved.
//

#import "cacheImageView.h"
#import "AjayCache.h"

#define maxConCurrentLoad 10

@interface cacheImageView(){
    
    
}
@end


@implementation cacheImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) setImageWithUrl:(NSURL*)UrlString :(NSString*)fileName completion:(void (^)())completion
{
    __weak typeof(self) weakSelf = self;
    //NSString *key = UrlString.absoluteString;
    
    NSData *data = [AjayCache objectForKey:fileName];
    
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        self.image = image;
        if (completion) {
            completion();
        }
    }
    else
    {
        [[cacheImageView sharedQueue] addOperationWithBlock:^{
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:UrlString];
            
                        if (imageData != nil) {
                             [AjayCache setObject:imageData forKey:fileName];
                            
                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                 weakSelf.image = [UIImage imageWithData:imageData];
                                 if (completion) {
                                     completion();
                                 }

                             }];
                         }
            
            
        }];
    }
    
}



static NSOperationQueue *imageOperationQueue = nil;
 static AjayCache *AjayCacheObj = nil;
+(NSOperationQueue*)sharedQueue
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        AjayCacheObj  =[ AjayCache new];
        imageOperationQueue = [[NSOperationQueue alloc]init];
        imageOperationQueue.maxConcurrentOperationCount = maxConCurrentLoad;
    });
    return imageOperationQueue;
}



@end
