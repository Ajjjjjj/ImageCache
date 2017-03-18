//
//  LoadCollectionViewCell.h
//  unsplashLocalDemo
//
//  Created by Ajay kumar on 03/01/17.
//  Copyright © 2017 iMorale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cacheImageView.h"
@interface LoadCollectionViewCell : UICollectionViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *activityObj;
@property(nonatomic,weak)IBOutlet cacheImageView *imageView;
@end
