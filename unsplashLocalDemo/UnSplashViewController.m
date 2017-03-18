//
//  ViewController.m
//  unsplashLocalDemo
//
//  Created by Ajay kumar on 03/01/17.
//  Copyright © 2017 iMorale. All rights reserved.
//

#import "UnSplashViewController.h"
#import "WebHandlerClass.h"
#import "LoadCollectionViewCell.h"
#import "ShareViewController.h"

#define unSplashBaseUrl @"https://unsplash.it/"
#define thumbSize 100
@interface UnSplashViewController ()<WebHandlerDelegate , UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *unsplashRecords;
}
@property(nonatomic,weak)IBOutlet UICollectionView *unsplashCollectionView;
@end

@implementation UnSplashViewController

#pragma View Controller Delegates
- (void)viewDidLoad {
    [super viewDidLoad];
    unsplashRecords =[[NSMutableArray alloc]init];
    
    
     [_unsplashCollectionView registerNib:[UINib nibWithNibName:@"LoadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    _unsplashCollectionView.dataSource =self;
    _unsplashCollectionView.delegate =self;
    
    [self.view setUserInteractionEnabled:NO];
    [SVProgressHUD show];
    [self performSelector:@selector(webCallMethod) withObject:nil afterDelay:0.5];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

#pragma web Call and delegates

-(void)webCallMethod{
    
  WebHandlerClass * webHandlerobj =  [WebHandlerClass sharedInstance];
    webHandlerobj.webserviceDelegate = self;
    NSURL *unSplashUrl =[NSURL URLWithString:unsplashUrl];
    [webHandlerobj unSplashWebCall:(NSURL*)unSplashUrl];
    
}


-(void)responseSuccessWithObject : (id)responseObject webservice:(WebHandlerClass*)handler{
    [self.view setUserInteractionEnabled:YES];
    __weak typeof(self) weakSelf= self;
    [SVProgressHUD dismiss];
    if ([responseObject isKindOfClass:[NSArray class]]) {
       unsplashRecords = ((NSArray*)responseObject).mutableCopy;
        
        if (unsplashRecords.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.unsplashCollectionView reloadData];

            });
        }
    }
    
    
}
-(void)failedWithError : (NSError*)error webservice:(WebHandlerClass*)handler{
    
    [self.view setUserInteractionEnabled:YES];
    [SVProgressHUD dismiss];
    
    
    
    UIAlertController *alertController;
    UIAlertAction *destroyAction;
    
    alertController = [UIAlertController alertControllerWithTitle:@"Alert!"
                                                          message:error.localizedDescription
                                                   preferredStyle:UIAlertControllerStyleAlert];
    destroyAction = [UIAlertAction actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleDestructive
                                           handler:^(UIAlertAction *action) {
                                               // do destructive stuff here
                                           }];
      // note: you can control the order buttons are shown, unlike UIActionSheet
    [alertController addAction:destroyAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}




-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma -mark Collectionview data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return unsplashRecords.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LoadCollectionViewCell *cell = (LoadCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    if (indexPath.item%2==0) {
        [cell setBackgroundColor:[UIColor grayColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor cyanColor]];
    }
    cell.activityObj.hidden= NO;;

    [cell.activityObj startAnimating];
    
    NSString *imageID = [NSString stringWithFormat:@"%@",[[unsplashRecords objectAtIndex:indexPath.item] objectForKey:@"id"]];
    
    NSString *urlName = [NSString stringWithFormat:@"%@%d/%d?image=%@",unSplashBaseUrl,thumbSize,thumbSize,imageID];
    NSString *imageName = [[unsplashRecords objectAtIndex:indexPath.item] objectForKey:@"filename"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [cell.imageView setImageWithUrl:[NSURL URLWithString:urlName] :(NSString*)imageName  completion:^(){
        [cell.activityObj stopAnimating];
        [cell.activityObj setHidesWhenStopped:YES];
    }];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageID = [NSString stringWithFormat:@"%@",[[unsplashRecords objectAtIndex:indexPath.item] objectForKey:@"id"]];
    
    NSString *imageWidth = [NSString stringWithFormat:@"%@",[[unsplashRecords objectAtIndex:indexPath.item] objectForKey:@"width"]];

    NSString *imageHeight = [NSString stringWithFormat:@"%@",[[unsplashRecords objectAtIndex:indexPath.item] objectForKey:@"height"]];
    
    
    NSString *urlName = [NSString stringWithFormat:@"%@%@/%@?image=%@",unSplashBaseUrl,imageWidth,imageHeight,imageID];

    [SVProgressHUD show];
    [self.view setUserInteractionEnabled:NO];
  
    [self performSelector:@selector(downloadImage:) withObject:urlName afterDelay:0.4];

}

-(void)downloadImage:(NSString*)urlString{
    __weak typeof(self) weakSelf= self;
    [[WebHandlerClass sharedInstance] downloadImage:(NSURL *)[NSURL URLWithString:urlString] completion:^(UIImage* processedImage){
        
        [SVProgressHUD dismiss];
        [self.view setUserInteractionEnabled:YES];
        if (processedImage.size.width>0) {
            
        dispatch_async(dispatch_get_main_queue(), ^{
            ShareViewController *shareObj = (ShareViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
            //menu is only an example
            shareObj.selectedImage=processedImage;
            shareObj.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:shareObj animated:YES completion:nil];
            
        });
        }
    }];

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(CGRectGetWidth(self.view.frame)/4-10, CGRectGetWidth(self.view.frame)/4-10);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
    
}


- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *IMG;
    for (id view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            IMG=(UIImageView*)view;
            IMG.alpha = 0.7f;
            [UIView animateWithDuration:0.1f animations:^{
                IMG.layer.transform = CATransform3DMakeScale(0.85f, 0.85f, 0.85f);
            }];
            
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *IMG;
    for (id view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            IMG=(UIImageView*)view;
            IMG.alpha = 1.0f;
            
            [UIView animateWithDuration:0.15f animations:^{
                IMG.layer.transform =CATransform3DIdentity;
            }];
            
        }
    }
    
}
-(IBAction)moveBack:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
