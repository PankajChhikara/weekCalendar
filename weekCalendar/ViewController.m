//
//  ViewController.m
//  weekCalendar
//
//  Created by Pankaj Chhikara on 25/06/15.
//  Copyright (c) 2015 pankajchhikara. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#import "weekCalendar.h"

@interface ViewController (){
    weekCalendar *wc;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableDictionary *data;
@property(nonatomic,strong)NSMutableArray *tableData;
@end

@implementation ViewController

-(NSMutableDictionary *)data{
    
    if (!_data) {
        _data=[[NSMutableDictionary alloc]init];
    }
    return _data;
}

-(NSMutableArray *)tableData{
    
    if (!_tableData) {
        _tableData=[[NSMutableArray alloc]init];
    }
    return _tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!wc) {
        wc=[[weekCalendar alloc]init];
    }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    _data= [wc currentWeekDays];
    [self setNavItemtile:[_data valueForKey:@"firstweekday"] endDate:[_data valueForKey:@"lastweekday"]];
    
    _tableData =[_data objectForKey:@"currentweek"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)setNavItemtile:(NSDate *)startDate endDate:(NSDate *)enddate{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd MMM"];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:startDate],[formatter stringFromDate:enddate]];
    //self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}



#pragma mark - UItableView Delegates Method


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _tableData.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd MMMM yyy"];
    cell.textLabel.text=[formatter stringFromDate:[_tableData objectAtIndex:indexPath.row]];
    
    return cell;
}


- (IBAction)nextBtnPressed:(id)sender {
    _data=[wc nextWeekDates];
    _tableData =[_data objectForKey:@"currentweek"];
    [self setNavItemtile:[_data valueForKey:@"firstweekday"] endDate:[_data valueForKey:@"lastweekday"]];
    [self.tableView reloadData];
}

- (IBAction)previousBtnPressed:(id)sender {
    _data= [wc previousWeekDates];
    _tableData =[_data objectForKey:@"currentweek"];
    [self setNavItemtile:[_data valueForKey:@"firstweekday"] endDate:[_data valueForKey:@"lastweekday"]];
    [self.tableView reloadData];
}

@end
