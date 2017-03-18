//
//  FirstViewController.m
//  unsplashLocalDemo
//
//  Created by Ajay kumar on 05/01/17.
//  Copyright © 2017 iMorale. All rights reserved.
//

#import "FirstViewController.h"
#import "UnSplashViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view.
}

-(IBAction)openUnsplash:(id)sender{
    UnSplashViewController *unSplashObj = (UnSplashViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"UnSplashViewController"];
    //menu is only an example
    unSplashObj.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:unSplashObj animated:YES completion:nil];}


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
