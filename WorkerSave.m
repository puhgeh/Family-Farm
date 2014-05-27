//
//  WorkerSave.m
//  Family Farm
//
//  Created by Axel Trajano on 1/21/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "WorkerSave.h"

@interface WorkerSave ()

@property (copy) CallBack callback;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *contactField;

- (IBAction)saveEmployee:(UIBarButtonItem *)sender;

@end

@implementation WorkerSave

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
    
    if (_worker) {
        [_nameField setText:_worker.name];
        [_addressField setText:_worker.address];
        [_contactField setText:_worker.contactNumber];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveEmployee:(UIBarButtonItem *)sender {
    
    [self resignFirstResponder];
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = [delegate performSelector:@selector(managedObjectContext) withObject:nil];
    
    if (!_worker) {
        _worker = [NSEntityDescription insertNewObjectForEntityForName:[[Worker class] description]inManagedObjectContext:context];
    }
    
    NSString * name = [_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * address = [_addressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * contactNumber = [_contactField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (name.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Empty name" message:@"Please provide atleast a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    } else {
        
        [_worker setName:name];
        [_worker setAddress:address];
        [_worker setContactNumber:contactNumber];
        
        NSError * error;
        
        if([context save:&error]){
            if (_callback) {
                _callback();
            }
        }else{
            NSLog(@"Error : %@", error);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void) callback:(CallBack)callback {
    self.callback = callback;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _nameField) {
        [_addressField becomeFirstResponder];
    }
    else if (textField == _addressField) {
        [_contactField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    
    return YES;
    
}

@end
