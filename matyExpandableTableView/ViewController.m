//
//  ViewController.m
//  matyExpandableTableView
//
//  Created by Maitrayee Ghosh on 05/08/14.
//  Copyright (c) 2014 Maitrayee Ghosh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initialization];
}

#pragma  mark - Initialization

-(void)initialization
{
    arrayForBool=[[NSMutableArray alloc]init];
    sectionTitleArray=[[NSArray alloc]initWithObjects:@"Tap me",@"Tap me",@"Tap me",@"Tap me" ,nil];
    for (int i=0; i<[sectionTitleArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    

}


#pragma mark -
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return section+2;
    }
    else
    return 0;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid=@"hello";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }

    
        BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
             /********** If the section supposed to be closed *******************/
        if(!manyCells)
        {
            cell.backgroundColor=[UIColor clearColor];
            
            cell.textLabel.text=@"";
        }
             /********** If the section supposed to be Opened *******************/
        else
        {
            cell.textLabel.text=[NSString stringWithFormat:@"cell %d",indexPath.row+1];
            cell.backgroundColor=[UIColor clearColor];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone ;
        }
    cell.imageView.image=[UIImage imageNamed:@"appleLogo.png"];
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"no of section %d",[sectionTitleArray count]);
    return [sectionTitleArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    /*************** reload tableview with little animation ***********************************/
    
    [UIView transitionWithView: self.expandableTableView
                      duration: 0.1f
                       options: UIViewAnimationOptionTransitionNone
                    animations: ^(void)
     {
         [self.expandableTableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         /* TODO: Whatever you want here */
     }];
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 40;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,40)];
    sectionView.tag=section;
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 130, 40)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor blackColor];
    viewLabel.font=[UIFont fontWithName:@"Arial" size:20];
    viewLabel.text=[sectionTitleArray objectAtIndex:section];
    
    UIImageView *viewImage=[[UIImageView alloc]initWithFrame:CGRectMake(270, 8, 25,25)];
    viewImage.contentMode = UIViewContentModeScaleAspectFit;
    viewImage.clipsToBounds = YES;
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        viewImage.image=[UIImage imageNamed:@"circle_drop_up.png"];
    }
    else
    viewImage.image=[UIImage imageNamed:@"circle_drop_down.png"];
    [sectionView addSubview:viewImage];
    [sectionView addSubview:viewLabel];
    
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
    
}


#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionTitleArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
            else  [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            
        }
        
    /************** Show little Animation for opening or closing table cell **************************/
        
        [UIView transitionWithView: self.expandableTableView
                          duration: 0.5f
                           options: UIViewAnimationOptionTransitionNone
                        animations: ^(void)
         {
             [self.expandableTableView reloadData];
         }
                        completion: ^(BOOL isFinished)
         {
             /* TODO: Whatever you want here */
         }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
