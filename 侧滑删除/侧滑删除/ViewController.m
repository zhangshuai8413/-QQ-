//
//  ViewController.m
//  侧滑删除
//
//  Created by kakao on 16/4/5.
//  Copyright © 2016年 shuai zhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *allDataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllViews];
    
    [self loadAllData];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 添加全部页面元素

- (void)addAllViews

{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
    
#warning iOS8 - 分割线样式
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    
    _tableView.separatorEffect = blurEffect;
    
    
    
    // 注册
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    
    
    // 右上角编辑按钮
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

#pragma mark 加载所有数据

- (void)loadAllData

{
    
    self.allDataArray =[[NSMutableArray alloc] initWithObjects:@"王菲",@"周迅",@"李冰冰",@"白冰",@"紫薇",@"马苏",@"刘诗诗",@"赵薇",@"angelbaby",@"熊黛林",nil];
    
}

#pragma mark 编辑按钮

- (void)setEditing:(BOOL)editing animated:(BOOL)animated

{
    
    [super setEditing:editing animated:animated];
    
    
    
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    
}


#pragma mark - UITableViewDataSource Methods

#pragma mark 设置有多少分组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return _allDataArray.count;
    
}

#pragma mark 设置某行上显示的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    
    cell.textLabel.text = _allDataArray[indexPath.row];
    
    //    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0f];
    
    
    
    return cell;
    
}


#pragma mark 设置可以进行编辑

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return YES;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

#pragma mark 设置处理编辑情况

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 1. 更新数据
        
        [_allDataArray removeObjectAtIndex:indexPath.row];
        
        
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    
    
}
#pragma mark 设置可以移动

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return YES;
    
}

#pragma mark 处理移动的情况

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath

{
    
    // 1. 更新数据
    
    NSString *title = _allDataArray[sourceIndexPath.row];
    
    [_allDataArray removeObject:title];
    
    [_allDataArray insertObject:title atIndex:destinationIndexPath.row];
    
    
    
    // 2. 更新UI
    
    [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        
        
        
        // 1. 更新数据
        
        [_allDataArray removeObjectAtIndex:indexPath.row];
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    
        // 删除一个置顶按钮
    
        UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    
            NSLog(@"点击了置顶");
    
    
    
            // 1. 更新数据
    
            [_allDataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    
    
    
            // 2. 更新UI
    
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
            [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
            [self.tableView reloadData];
    
        }];
    
        topRowAction.backgroundColor = [UIColor blueColor];
    
    
    
    // 添加一个更多按钮
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了更多");
        
        
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    
    
    // 将设置好的按钮放到数组中返回
    
    // return @[deleteRowAction, topRowAction, moreRowAction];
    
    return @[deleteRowAction,moreRowAction,topRowAction];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
