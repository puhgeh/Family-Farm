//
//  ClientTable.m
//  Family Farm
//
//  Created by Axel Trajano on 1/19/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "ClientTable.h"
#import "ClientDetailView.h"

@interface ClientTable ()

@property (strong, nonatomic) NSManagedObjectContext * context;
@property (strong, nonatomic) void (^callback)(void);
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSMutableArray * clients;
@property (strong, nonatomic) NSArray * searchResults;
@property (strong, nonatomic) UISplitViewController * splitViewController;
@property (strong, nonatomic) ClientDetailView * clientDetail;
@property (strong, nonatomic) NSIndexPath * lastIndexPath;

@end

@implementation ClientTable

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
    _clientDetail = [[[[_splitViewController viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:0];
    
    [_searchField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    
    typeof(self) __weak weakSelf = self;
    
    _callback = ^{
        [weakSelf.searchField setText:nil];
        [weakSelf fetchClients];
        [weakSelf.tableView reloadData];
        [weakSelf.clientDetail setClient:[weakSelf clientForIndexPath:weakSelf.lastIndexPath]];
    };
 
    [self fetchClients];
    
    if (![_clients isEmpty]) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [_clientDetail setClient:[self clientForIndexPath:indexPath]];
        _lastIndexPath = indexPath;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (_lastIndexPath) {
        [self.tableView selectRowAtIndexPath:_lastIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
    
}

- (Client *)clientForIndexPath:(NSIndexPath *)indexPath {
    
    Client * client;
    
    if (_searchField.text.length > 0) {
        client = [_searchResults objectAtIndex:indexPath.row];
    } else if(![_clients isEmpty]) {
        client = [_clients objectAtIndex:indexPath.row];
    }
    
    return client;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchClients {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    _context = [delegate performSelector:@selector(managedObjectContext) withObject:nil];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:[[Client class] description]inManagedObjectContext:_context];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    _clients = [NSMutableArray arrayWithArray:[_context executeFetchRequest:fetchRequest error:&error]];
    if (!_clients) {
        // Handle the error
        _clients = [NSMutableArray new];
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
    
    _searchResults = [_clients filteredArrayUsingPredicate:resultPredicate];
    
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
    
    return _clients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"clientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    Client * client = [self clientForIndexPath:indexPath];
    
    cell.textLabel.text = [client name];
    cell.detailTextLabel.text = [client contactNumber];
    
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
#warning UPDATE THE DETAIL VIEW FOR DELETED ITEMS THAT ARE CURRENTLY REFLECTED
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_context deleteObject:[_clients objectAtIndex:indexPath.row]];
        [_clients removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (_lastIndexPath.row == indexPath.row) {
            [_clientDetail reloadClientTransactions:nil];
            _lastIndexPath = nil;
        }
        
        NSError * error;
        if(![_context save:&error]){
            NSLog(@"Error : %@", error);
        }
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _lastIndexPath = indexPath;
    
    Client * client = [self clientForIndexPath:indexPath];
    [_clientDetail reloadClientTransactions:client];
    
    
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
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ClientSave * clientSave = [segue destinationViewController];
    [clientSave callback:_callback];
    
    if ([segue.identifier isEqualToString:@"editClient"]) {
        if (_searchField.text.length > 0) {
            [clientSave setClient:[_searchResults objectAtIndex:[self.tableView indexPathForCell:sender].row]];
        } else {
            [clientSave setClient:[_clients objectAtIndex:[self.tableView indexPathForCell:sender].row]];
        }
    }

}


@end
