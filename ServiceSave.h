//
//  ServiceSave.h
//  Family Farm
//
//  Created by Axel Trajano on 1/25/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"

@interface ServiceSave : UIViewController <UIActionSheetDelegate>

typedef void (^CallBack)(void);

@property (strong, nonatomic) Service * service;

- (void)callback:(CallBack)callback;

@end
