//
//  WorkerSave.h
//  Family Farm
//
//  Created by Axel Trajano on 1/21/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Worker.h"

typedef void (^CallBack)(void);

@interface WorkerSave : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Worker * worker;

- (void)callback:(CallBack)callback;

@end
