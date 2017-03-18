//
//  WebHandlerClass.m
//
//  Copyright © 2016 Ajay. All rights reserved.
//

#import "WebHandlerClass.h"

@interface WebHandlerClass ()<NSURLSessionDelegate>
{
    
}
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end
@implementation WebHandlerClass

static WebHandlerClass *singleInstance = nil;
+(WebHandlerClass*)sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singleInstance = [[WebHandlerClass alloc]init];
    });
    return singleInstance;
}

-(void)unSplashWebCall:(NSURL*)urlLocal
{
    __weak typeof(self) weakSelf = self;
  
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:urlLocal
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                
                if (error) {
                    NSLog(@"Error %@",error.localizedDescription);
                    [self.webserviceDelegate failedWithError:(NSError *)error webservice:weakSelf];

                }
                else if(data)
                {
                    NSError *error;
                    id json = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
                    //NSLog(@"==%@",json);
                    if (error) {
                        NSLog(@"Error %@",error.localizedDescription);
                        [self.webserviceDelegate failedWithError:(NSError *)error webservice:weakSelf];

                    }
                    else
                    {
                        [self.webserviceDelegate responseSuccessWithObject:(id)json webservice:weakSelf];
                    }
            
                }
                else{
                    
                }
                
            }] resume];
    
    
    
    
    
    
}

-(void)downloadImage:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                
                if (error) {
                    if (completion) completion(nil);

                    NSLog(@"Error %@",error.localizedDescription);
                    
                }
                else if(data)
                {
                    
                    UIImage *image =[UIImage imageWithData:data];
                    if (image) {
                        
                        if (completion) completion(image);

                    }
                }
                else{
                    
                }
                
            }] resume];

    
    
}

@end
