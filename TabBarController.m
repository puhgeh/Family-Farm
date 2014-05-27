//
//  TabBarController.m
//  Family Farm
//
//  Created by Axel Trajano on 1/16/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "TabBarController.h"
#import "PaymentType.h"

@interface TabBarController ()

@property (strong, nonatomic) NSManagedObjectContext * context;

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    AXPreference * pref = [AXPreference sharedInstance];
    
    if (![pref valueForKey:@"SEEDED"]) {
        
        _context = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext) withObject:nil];
        
        PaymentType * item = [NSEntityDescription insertNewObjectForEntityForName:[[PaymentType class] description] inManagedObjectContext:_context];
        [item setName:@"item unit"];
        
        PaymentType * monetary = [NSEntityDescription insertNewObjectForEntityForName:[[PaymentType class] description] inManagedObjectContext:_context];
        [monetary setName:@"monetary"];
        
        NSError * error;
        if ([_context save:&error]) {
            [pref setValue:[NSNumber numberWithBool:YES] forKey:@"SEEDED"];
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
