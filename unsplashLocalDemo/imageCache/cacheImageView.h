//
//  cacheImageView.h
//  unsplashLocalDemo
//
//  Created by Ajay kumar on 04/01/17.
//  Copyright © 2017 iMorale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cacheImageView : UIImageView
{
    
}
-(void) setImageWithUrl:(NSURL*)UrlString :(NSString*)fileName completion:(void (^)())completion;
@end
