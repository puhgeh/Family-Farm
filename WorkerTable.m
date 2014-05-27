//
//  EmployeeTable.m
//  Family Farm
//
//  Created by Axel Trajano on 1/21/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "WorkerTable.h"
#import "WorkerDetailView.h"

@interface WorkerTable ()

@property (strong, nonatomic) UISplitViewController * splitViewController;
@property (strong, nonatomic) WorkerDetailView * workerDetail;
@property (strong, nonatomic) NSManagedObjectContext * context;
@property (strong, nonatomic) void (^callback)(void);
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSMutableArray * workers;
@property (strong, nonatomic) NSArray * searchResults;
@property (strong, nonatomic) NSIndexPath * lastIndex;

@end

@implementation WorkerTable

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
 
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    _splitViewController = (UISplitViewController *)[[self parentViewController] parentViewController];
    _workerDetail = [[[[_splitViewController viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:0];

    
    [_searchField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    
    typeof(self) __weak weakSelf = self;
    
    _callback = ^{
        [weakSelf.searchField setText:nil];
        [weakSelf fetchWorkers];
        [weakSelf.tableView reloadData];
    };
    
    [self fetchWorkers];
    
    if (_workers.count > 0) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
#warning SET WORKER FOR WORKER DETAIL HERE
        _lastIndex = indexPath;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (_lastIndex) {
        [self.tableView selectRowAtIndexPath:_lastIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
}

- (Worker *)workerForIndexPath:(NSIndexPath *)indexPath {

    Worker * worker;
    if (![_searchField isEmptyOnTrimWhiteSpaceAndNewLineCharacters:NO]) {
        worker = [_searchResults objectAtIndex:indexPath.row];
    } else if (![_workers isEmpty]) {
        worker = [_workers objectAtIndex:indexPath.row];
    }
    
    return worker;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchWorkers {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    _context = [delegate performSelector:@selector(managedObjectContext) withObject:nil];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:[[Worker class] description]inManagedObjectContext:_context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    _workers = [NSMutableArray arrayWithArray:[_context executeFetchRequest:fetchRequest error:&error]];
    if (!_workers) {
        // Handle the error
        _workers = [NSMutableArray new];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self filterContentForSearchText:textField.text];
    [self.tableView reloadData];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText {
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"name contains[cd] %@",
                                    searchText];
    
    _searchResults = [_workers filteredArrayUsingPredicate:resultPredicate];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_searchField.text.length > 0) {
        return [_searchResults count];
    }
    
    return _workers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"employeeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Worker * worker = [self workerForIndexPath:indexPath];
    cell.textLabel.text = [worker name];
    cell.detailTextLabel.text = [worker contactNumber];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_context deleteObject:[_workers objectAtIndex:indexPath.row]];
        [_workers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSError * error;
        if(![_context save:&error]){
            NSLog(@"Error : %@", error);
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     WorkerSave * employeeSave = [segue destinationViewController];
     [employeeSave callback:_callback];
     
     if ([segue.identifier isEqualToString:@"editEmployee"]) {
         if (_searchField.text.length > 0) {
             [employeeSave setWorker:[_searchResults objectAtIndex:[self.tableView indexPathForCell:sender].row]];
         } else {
             [employeeSave setWorker:[_workers objectAtIndex:[self.tableView indexPathForCell:sender].row]];
         }
     }
 
 }
@end
