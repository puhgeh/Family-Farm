//
//  TransactionDetail.m
//  Family Farm
//
//  Created by Axel Trajano on 5/17/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "TransactionDetail.h"

@interface TransactionDetail ()

@property (weak, nonatomic) IBOutlet UITextField *serviceField;
@property (weak, nonatomic) IBOutlet UITextField *landAreaField;
@property (weak, nonatomic) IBOutlet UITextField *landAreaUnitField;
@property (weak, nonatomic) IBOutlet UITextField *serviceFeeField;
@property (weak, nonatomic) IBOutlet UITextField *paymentField;
@property (weak, nonatomic) IBOutlet UITextField *serviceDateField;
@property (weak, nonatomic) IBOutlet UITextField *partingPercentageField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (copy) UITextField * lastTextFieldSelected;
@property (strong, nonatomic) AXDatePickerDialog * datePickerDialog;

@end

@implementation TransactionDetail

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    [_serviceField setDelegate:self];
    [_landAreaField setDelegate:self];
    [_landAreaUnitField setDelegate:self];
    [_serviceFeeField setDelegate:self];
    [_paymentField setDelegate:self];
    [_serviceDateField setDelegate:self];
    [_partingPercentageField setDelegate:self];
    
    _datePickerDialog = [[AXDatePickerDialog alloc] initFromView:self.view controller:self notifier:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case -1:
            [self hideKeyboard];
            if (textField == _serviceDateField) {
                [_datePickerDialog show];
            }
            return NO;
            break;
        default:
            _lastTextFieldSelected = textField;
            return YES;
            break;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _landAreaField || textField == _serviceFeeField || textField == _partingPercentageField) {
        
        NSString * fieldString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        return [fieldString valueIsNumberWithDecimalPlaces:2];
    
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _landAreaField || textField == _serviceFeeField || textField == _partingPercentageField) {
    
        [textField setText:[[NSNumber numberWithFloat:[textField.text floatValue]] stringValue]];
    
    }
    
}

- (void)notifyForEvent:(AXEvent)event withObject:(id)object {
    
    switch (event) {
        case SELECT:
            [_serviceDateField setText:[object stringValueWithFormat:@"MMM dd, yyyy HH:mm:ss"]];
            break;
        default:
            break;
    }
    
}

- (void)hideKeyboard {
    
    [_lastTextFieldSelected resignFirstResponder];
    [_noteField resignFirstResponder];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
