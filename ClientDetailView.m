//
//  ClientDetailView.m
//  Family Farm
//
//  Created by Axel Trajano on 1/19/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "ClientDetailView.h"
#import "TransactionHeader.h"
#import "TransactionTable.h"
#import "TransactionDetail.h"

@interface ClientDetailView ()

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet UIView *detailContainer;
@property (strong, nonatomic) TransactionTable * transactionTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTransactionButton;

@end

@implementation ClientDetailView

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
    
    [self.splitViewController setDelegate:self];
    [self setupViewContainers];
    
}

- (void)setClient:(Client *)client {
    
    _client = client;
    if (_client) {
        [self setTitle:[NSString stringWithFormat:@"%@'s Transactions", client.name]];
    } else {
        [self setTitle:@"Transactions"];
    }
    if (!_transactionTable) {
        _transactionTable = [TransactionTable new];
    }
    [_transactionTable setClient:_client];
    
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
}

- (void)setupViewContainers {
    
    [self setupHeaderView];
    [self setupDetailView];
    
}

- (void)setupHeaderView {
    
    //SETUP HEADER CONTAINER
    TransactionHeader * header = [TransactionHeader new];
    [_headerContainer addSubview:header.view];
    [header.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerContainer setClipsToBounds:YES];
    
    [_headerContainer addConstraint:[NSLayoutConstraint constraintWithItem:header.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_headerContainer attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_headerContainer addConstraint:[NSLayoutConstraint constraintWithItem:header.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_headerContainer attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [_headerContainer addConstraint:[NSLayoutConstraint constraintWithItem:header.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headerContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_headerContainer addConstraint:[NSLayoutConstraint constraintWithItem:header.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_headerContainer attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_headerContainer addConstraint:[NSLayoutConstraint constraintWithItem:header.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_headerContainer attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_headerContainer addConstraint:[NSLayoutConstraint constraintWithItem:header.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_headerContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
}

- (void)setupDetailView {
    
    //SETUP DETAIL CONTAINER
    [_detailContainer setBackgroundColor:[UIColor greenColor]];
    if (!_transactionTable) {
        _transactionTable = [TransactionTable new];
    }
    
    [_detailContainer addSubview:_transactionTable.view];
    
    
    [_transactionTable.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_detailContainer addConstraint:[NSLayoutConstraint constraintWithItem:_transactionTable.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_detailContainer attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_detailContainer addConstraint:[NSLayoutConstraint constraintWithItem:_transactionTable.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_detailContainer attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_detailContainer addConstraint:[NSLayoutConstraint constraintWithItem:_transactionTable.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_detailContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_detailContainer addConstraint:[NSLayoutConstraint constraintWithItem:_transactionTable.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_detailContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    //ADD VIEW CONTROLLER
    [self addChildViewController:_transactionTable];
    
}

- (void)reloadClientTransactions:(Client *)client {
    
    //RELOAD THE TRANSACTION TABLE
    [self setClient:client];
    [_transactionTable setClient:client];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    
    
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"addTransaction"] && !_client) {
        return NO;
    }
    
    return YES;
    
}

@end
