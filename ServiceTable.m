//
//  ServiceTable.m
//  Family Farm
//
//  Created by Axel Trajano on 1/25/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "ServiceTable.h"

@interface ServiceTable ()

@property (strong, nonatomic) NSManagedObjectContext * context;
@property (strong, nonatomic) void (^callback)(void);
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSMutableArray * services;
@property (strong, nonatomic) NSArray * searchResults;
@property (strong, nonatomic) NSIndexPath * lastIndexPath;

@end

@implementation ServiceTable

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
    
    [_searchField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    
    typeof(self) __weak weakSelf = self;
    
    _callback = ^{
        [weakSelf.searchField setText:nil];
        [weakSelf fetchServices];
        [weakSelf.tableView reloadData];
    };
    
    [self fetchServices];
    
    if (![_services isEmpty]) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
#warning UPDATE THE SERVICE DETAIL HERE
        _lastIndexPath = indexPath;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (_lastIndexPath) {
        [self.tableView selectRowAtIndexPath:_lastIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
}

- (Service *)serviceForIndexPath:(NSIndexPath *)indexPath {
    
    Service * service;
    
    if (![_searchField isEmptyOnTrimWhiteSpaceAndNewLineCharacters:NO]) {
        service = [_searchResults objectAtIndex:indexPath.row];
    } else if (![_services isEmpty]) {
        service = [_services objectAtIndex:indexPath.row];
    }
    
    return service;
    
}

- (void)fetchServices {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    _context = [delegate performSelector:@selector(managedObjectContext) withObject:nil];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:[[Service class] description]inManagedObjectContext:_context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    _services = [NSMutableArray arrayWithArray:[_context executeFetchRequest:fetchRequest error:&error]];
    if (!_services) {
        // Handle the error
        _services = [NSMutableArray new];
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
    
    _searchResults = [_services filteredArrayUsingPredicate:resultPredicate];
    
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
        return _searchResults.count;
    }
    return _services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"serviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Service * service = [self serviceForIndexPath:indexPath];
    
    cell.textLabel.text = [service name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ per %@ hectare", service.baseCost, service.baseLandArea];
    
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
        [_context deleteObject:[_services objectAtIndex:indexPath.row]];
        [_services removeObjectAtIndex:indexPath.row];
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
    
    ServiceSave * serviceSave = [segue destinationViewController];
    [serviceSave callback:_callback];
    
    if ([segue.identifier isEqualToString:@"editService"]) {
        if (_searchField.text.length > 0) {
            [serviceSave setService:[_searchResults objectAtIndex:[self.tableView indexPathForCell:sender].row]];
        } else {
            [serviceSave setService:[_services objectAtIndex:[self.tableView indexPathForCell:sender].row]];
        }
    }
    
}

@end
