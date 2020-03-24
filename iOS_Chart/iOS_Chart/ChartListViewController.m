//
//  ChartListViewController.m
//  iOS_Chart
//
//  Created by KC on 2017/7/18.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "ChartListViewController.h"

@interface ChartListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray *titles;
@property(nonatomic, strong)NSMutableArray *classNames;
@property(nonatomic, strong)UITableView *myTable;

@end

@implementation ChartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarBarTintColor = UIColor.whiteColor;
    
    self.title = @"图表类型列表";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"饼图" class:@"PieChartDemo"];
    [self addCell:@"柱状图" class:@"ColumnChartDemo"];
    [self addCell:@"折线图" class:@"PolylineChartDemo"];
    [self addCell:@"波形图" class:@"WaveChartDemo"];
    
    self.myTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class){
        LCBaseViewController *ctrl = class.new;
        ctrl.title = self.titles[indexPath.row];
        ctrl.hasBack = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
}

- (void)addCell:(NSString *)title class:(NSString *)className;
{
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
