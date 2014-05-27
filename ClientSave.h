//
//  ClientSave.h
//  Family Farm
//
//  Created by Axel Trajano on 1/19/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

typedef void (^CallBack)(void);

@interface ClientSave : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Client * client;

- (void)callback:(CallBack)callback;

@end
