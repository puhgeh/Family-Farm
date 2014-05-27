//
//  ServiceSave.m
//  Family Farm
//
//  Created by Axel Trajano on 1/25/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "ServiceSave.h"
#import "PaymentType.h"

@interface ServiceSave ()

@property (strong, nonatomic) NSManagedObjectContext * context;
@property (copy) CallBack callback;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *baseLandField;
@property (weak, nonatomic) IBOutlet UITextField *baseCostField;
@property (weak, nonatomic) IBOutlet UITextField *workerPercentageField;
@property (weak, nonatomic) IBOutlet UITextField *unitOfLandField;
@property (weak, nonatomic) IBOutlet UIButton *unitOfCostField;
@property (strong, nonatomic) PaymentType * paymentType;
@property (strong, nonatomic) NSArray * paymentTypes;
@property (strong, nonatomic) NSMutableArray * listOfCostTypes;
@property (strong, nonatomic) UIActionSheet * listUnitOfCost;

- (IBAction)saveService:(UIBarButtonItem *)sender;
- (IBAction)popUnitOfCost:(UIButton *)sender;

@end

@implementation ServiceSave

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
    
    _context = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext) withObject:nil];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:[[PaymentType class] description] inManagedObjectContext:_context];
    NSFetchRequest * fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entity];
    
    _paymentTypes = [_context executeFetchRequest:fetchRequest error:nil];
    
    
    if (_service) {
        [_nameField setText:_service.name];
        [_baseLandField setText:[_service.baseLandArea stringValue]];
        [_unitOfLandField setText:[_service unitOfLand]];
        [_baseCostField setText:[_service.baseCost stringValue]];
        [_unitOfCostField setTitle:[_service unitOfCost] forState:UIControlStateNormal];
        [_workerPercentageField setText:[_service.defaultPercentage stringValue]];
    } else {
        _paymentType = [_paymentTypes objectAtIndex:0];
        [_unitOfCostField setTitle:_paymentType.name forState:UIControlStateNormal];
    }
    
    _listOfCostTypes = [NSMutableArray new];
    _listUnitOfCost = [[UIActionSheet alloc] initWithTitle:@"Unit:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (PaymentType * paymentType in _paymentTypes) {
        [_listOfCostTypes addObject:paymentType.name];
        [_listUnitOfCost addButtonWithTitle:paymentType.name];
    }
    
    [_listOfCostTypes addObject:@"Cancel"];
    [_listUnitOfCost addButtonWithTitle:@"Cancel"];
    [_listUnitOfCost setCancelButtonIndex:_listOfCostTypes.count];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveService:(UIBarButtonItem *)sender {
    
    [self resignFirstResponder];
    
    if (!_service) {
        _service = [NSEntityDescription insertNewObjectForEntityForName:[[Service class] description]inManagedObjectContext:_context];
    }
    
    NSString * name = [_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UIAlertView * alert;
    NSMutableString * message = [NSMutableString new];
    if ([_nameField isEmptyOnTrimWhiteSpaceAndNewLineCharacters:YES]) {
        [message appendString:@"Name"];
    }
    if ([_baseLandField isEmptyOnTrimWhiteSpaceAndNewLineCharacters:YES]) {
        [message appendString:@"\nBase Hectare"];
    }
    if ([_baseCostField isEmptyOnTrimWhiteSpaceAndNewLineCharacters:YES]) {
        [message appendString:@"\nBase Cost"];
    }
    if ([_unitOfLandField isEmptyOnTrimWhiteSpaceAndNewLineCharacters:YES]) {
        [message appendString:@"\nUnit Of Land"];
    }
    if ([_workerPercentageField isEmptyOnTrimWhiteSpaceAndNewLineCharacters:YES]) {
        [message appendString:@"\nWorker Percentage"];
    }
    
    
    if (message.length > 1) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Please provide the following:" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    } else {
        
        NSNumber * baseLandArea = [NSNumber numberWithDouble:[_baseLandField.text doubleValue]];
        NSDecimalNumber * baseCost = [NSDecimalNumber decimalNumberWithString:_baseCostField.text];
        NSNumber * defaultPercentage = [NSNumber numberWithDouble:[_workerPercentageField.text doubleValue]];
        
        [_service setName:name];
        [_service setBaseLandArea:baseLandArea];
        [_service setUnitOfLand:[_unitOfLandField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [_service setBaseCost:baseCost];
        [_service setUnitOfCost:[[_unitOfCostField titleLabel] text]];
        [_service setDefaultPercentage:defaultPercentage];
        
        
        NSError * error;
        
        if([_context save:&error]){
            if (_callback) {
                _callback();
            }
        }else{
            NSLog(@"Error : %@", error);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (IBAction)popUnitOfCost:(UIButton *)sender {
    
    if (![_listUnitOfCost isVisible]) {
        [_listUnitOfCost showFromRect:sender.bounds inView:sender animated:YES];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [_unitOfCostField setTitle:[[_paymentTypes objectAtIndex:buttonIndex] name] forState:UIControlStateNormal];
    
}

- (void)callback:(CallBack)callback {
    self.callback = callback;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _nameField) {
        [_baseLandField becomeFirstResponder];
    } else if (textField == _baseLandField) {
        [_baseCostField becomeFirstResponder];
    } else if (textField == _baseLandField) {
        [_workerPercentageField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
    
}

@end
