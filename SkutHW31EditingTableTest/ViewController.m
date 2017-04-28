//
//  ViewController.m
//  SkutHW31EditingTableTest
//
//  Created by Mac on 6/10/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "ViewController.h"
#import "IDGroup.h"
#import "IDStudent.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* groupeArray;


@end

@implementation ViewController



- (void) loadView{
    [super loadView];
    CGRect frame = self.view.bounds;
    frame.origin=CGPointZero;
    
    UITableView* tableView= [[UITableView alloc]initWithFrame:frame style: UITableViewStyleGrouped];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    //tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupeArray =[NSMutableArray array];
    /*for (int i = 0; i< ((arc4random() % 6) + 5); i++){
    
        IDGroup* group =[[IDGroup alloc] init];
        group.name = [NSString stringWithFormat: @"Group #%d", i];
        
        NSMutableArray* array = [NSMutableArray array];
        
        for(int j =0; j < ((arc4random() % 10) + 15); j++){
            [array addObject: [IDStudent randomStudent]];
        
        }
        group.studentsArray = array;
        [self.groupeArray addObject:group];
        
    }
    [self.tableView reloadData];
     */
    self.navigationItem.title= @"Students";
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem=editButton;
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.leftBarButtonItem=addButton;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
-(void) actionAdd: (UIBarButtonItem*) sender{
    
    IDGroup* group =[[IDGroup alloc] init];
    group.name = [NSString stringWithFormat: @"Group #%lu", [self.groupeArray count]+1];

    group.studentsArray = @[[IDStudent randomStudent]];
    
    NSInteger newSectionIndex=0;
    
    [self.groupeArray insertObject:group atIndex:newSectionIndex];
    [self.tableView beginUpdates];
    
    NSIndexSet* insertSections = [NSIndexSet indexSetWithIndex:newSectionIndex];
   
    [self.tableView insertSections: insertSections
                  withRowAnimation:[self.groupeArray count] % 2 ? UITableViewRowAnimationFade : UITableViewRowAnimationRight];
  
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delayInSeconds = 0.3;
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents]){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
       
    });
   

}



-(void) actionEdit: (UIBarButtonItem*) sender{
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated: NO];
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if(self.tableView.editing){
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem=editButton;
   // [self.navigationItem setRightBarButtonItem:editButton animated: YES];

}


# pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        IDGroup* sourceGroup = [self.groupeArray objectAtIndex:indexPath.section];
        IDStudent* student = [sourceGroup.studentsArray objectAtIndex:indexPath.row - 1];
        NSMutableArray* tempArray=[NSMutableArray arrayWithArray:sourceGroup.studentsArray];
        [tempArray removeObject:student];
        sourceGroup.studentsArray=tempArray;
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [tableView endUpdates];
        
        
    
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.groupeArray count];

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return [[self.groupeArray objectAtIndex:section] name];
}


-(NSInteger) tableView: (UITableView* )tableView numberOfRowsInSection:(NSInteger)section {
    IDGroup* group =[self.groupeArray objectAtIndex:section];
    
    return [group.studentsArray count]+1;
}

-(UITableViewCell *) tableView: (UITableView* )tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath{
    
    if(indexPath.row == 0){
        static NSString* addStudentIdentifier = @"addStudentCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        if(!cell){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
            cell.textLabel.textColor=[UIColor blueColor];
            cell.textLabel.text=@"Add Student";
            
        }

        return cell;
    
    }

    static NSString* studentIdentifier = @"studentCell";
    
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:studentIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentIdentifier];
    }
    
    IDGroup* group = [self.groupeArray objectAtIndex:indexPath.section];
    IDStudent* student = [group.studentsArray objectAtIndex:indexPath.row - 1];
    
    
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", student.firstName, student.lastName];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%1.2f",student.averageGrade];

    
    if(student.averageGrade >=4.0){
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }
    else if (student.averageGrade >=3.0){
        cell.detailTextLabel.textColor = [UIColor orangeColor];
    }
    else  {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
             
    return cell;


}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*IDGroup* sourceGroup = [self.groupeArray objectAtIndex:indexPath.section];
    IDStudent* student = [sourceGroup.studentsArray objectAtIndex:indexPath.row];
    
    return student.averageGrade <4.f;*/
    //return YES;
    
    return indexPath.row>0;
};


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    IDGroup* sourceGroup = [self.groupeArray objectAtIndex:sourceIndexPath.section];
    IDStudent* student = [sourceGroup.studentsArray objectAtIndex:sourceIndexPath.row-1];
    
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.studentsArray];
    
    
    if(sourceIndexPath.section == destinationIndexPath.section){
        [tempArray exchangeObjectAtIndex: sourceIndexPath.row-1 withObjectAtIndex:destinationIndexPath.row-1];
        
    sourceGroup.studentsArray = tempArray;
    
    }
    else{
    
    [tempArray removeObject:student];
    sourceGroup.studentsArray = tempArray;
    
    
    IDGroup* destinationGroup =[self.groupeArray objectAtIndex:destinationIndexPath.section];
    tempArray = [NSMutableArray arrayWithArray: destinationGroup.studentsArray];
    [tempArray insertObject:student atIndex:destinationIndexPath.row-1];
    destinationGroup.studentsArray = tempArray;
    }
    

}



# pragma mark - UITableViewDelegate


- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
 
       return indexPath.row==0 ? UITableViewCellEditingStyleNone: UITableViewCellEditingStyleDelete;
    

}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
};

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{

    if(proposedDestinationIndexPath.row==0){
        return sourceIndexPath;
    }else
        return proposedDestinationIndexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        NSLog(@"ADD");
        IDGroup* group = [self.groupeArray objectAtIndex:indexPath.section];
        NSMutableArray* tempArray = nil;
        if(group.studentsArray){
            tempArray = [NSMutableArray arrayWithArray:group.studentsArray];
        }
        else{
            tempArray = [NSMutableArray array];
        }
        NSInteger newStudentIndex=0;
        
        [tempArray insertObject:[IDStudent randomStudent] atIndex:newStudentIndex];
        
        group.studentsArray=tempArray;
        [self.tableView beginUpdates];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:newStudentIndex+1 inSection:indexPath.section];
        
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:
                       UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        double delayInSeconds = 0.3;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([[UIApplication sharedApplication] isIgnoringInteractionEvents]){
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }});
    }
}




@end
