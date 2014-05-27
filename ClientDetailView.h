//
//  ClientDetailView.h
//  Family Farm
//
//  Created by Axel Trajano on 1/19/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface ClientDetailView : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Client * client;

- (void)reloadClientTransactions:(Client *)client;

@end
