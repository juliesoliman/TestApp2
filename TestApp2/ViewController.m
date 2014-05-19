//
//  ViewController.m
//  TestApp2
//
//  Created by Julie Soliman on 5/19/14.
//  Copyright (c) 2014 Solstice Mobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self doNotUseParameter:5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doNotUseParameter:(int)i
{
    
}

@end
