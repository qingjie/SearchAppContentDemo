//
//  ViewController.m
//  SearchAppContentDemo
//
//  Created by qingjie on 1/10/16.
//  Copyright © 2016 Retrieve LLC. All rights reserved.
//


#import <CoreSpotlight/CoreSpotlight.h>
#import "ViewController.h"
#import "Friend.h"

@interface ViewController (){
    NSArray *tableDataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    tableDataArray = [self tableDataSource];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    [self saveFriend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --tableview


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return tableDataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"com.qingjie.www.searchAppContentDemo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    Friend *friendCell = (Friend *)[tableDataArray objectAtIndex:indexPath.row];
    cell.imageView.image = friendCell.image;
    cell.textLabel.text = friendCell.name;
    cell.detailTextLabel.text = friendCell.webURL;
    
    return cell;
    
}



-(NSArray *)tableDataSource {
    NSArray *nameArray = @[@"cat",@"dog",@"lion",@"horse"];
    int i = 0;
    NSMutableArray *friendArray = [[NSMutableArray alloc] init];
    for (NSString *item in nameArray) {
        Friend *friend = [[Friend alloc] init];
        friend.name = item;
        friend.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", ++i]];
        friend.webURL = @"www.syr.edu";
        friend.f_id = [NSString stringWithFormat:@"%d",i];
        [friendArray addObject:friend];
        
    }
    
    return friendArray != nil ? friendArray : nil;
}

-(void) saveFriend{
    
    NSMutableArray <CSSearchableItem*> *searchableItem = [NSMutableArray array];
    
    for (Friend *friend in tableDataArray) {
        CSSearchableItemAttributeSet *attribute = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"image"];
        attribute.title = friend.name;
        attribute.contentDescription = friend.webURL;
        attribute.thumbnailData = UIImagePNGRepresentation(friend.image);
        
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:friend.f_id domainIdentifier:@"www.qingjie.search.friend" attributeSet:attribute];
        [searchableItem addObject:item];
        
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItem completionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"error=%@",error);
        }
        
    }];
    
}

-(void)loadImage:(NSString *)f_id{
    Friend *someFriend = nil;
    
    for (Friend *item in tableDataArray) {
        if ([item.f_id isEqualToString:f_id]) {
            someFriend = item;
            break;
        }
    }
    
    if (someFriend) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 300, 50, 50)];
        imageView.image = someFriend.image;
        [self.view addSubview:imageView];
    }
}

@end
