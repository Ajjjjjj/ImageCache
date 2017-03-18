//
//  ShareViewController.m
//  unsplashLocalDemo
//
//  Created by Ajay kumar on 05/01/17.
//  Copyright © 2017 iMorale. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
{
    
}
@property(nonatomic)IBOutlet UIImageView *imageView;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.imageView.image = self.selectedImage;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(IBAction)moveBack:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)shareImage:(id)sender{
    
    if (self.selectedImage) {
        NSMutableArray *activityItems= [NSMutableArray arrayWithObjects:_imageView.image, nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
     
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    
    
  

}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
