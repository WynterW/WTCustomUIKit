//
//  PublicCellListTableViewController.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/4.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import "PublicCellListTableViewController.h"
#import "WTPublicCell.h"

@interface PublicCellListTableViewController ()

@end

@implementation PublicCellListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[WTPublicCell class] forCellReuseIdentifier:@"WTPublicCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTPublicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WTPublicCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.customCellStyle = WTTableViewCellStyleDefault;
        cell.leftImgView.image = [UIImage imageNamed:@"comments_star_green"];
        cell.titleLb.text = @"Default";
        cell.bottomLineLb.hidden = NO;
        return cell;
    } else if (indexPath.row == 1) {
        cell.customCellStyle = WTTableViewCellStyleCenterText;
        cell.titleLb.text = @"CenterText";
        cell.bottomLineLb.hidden = NO;
        return cell;
    } else if (indexPath.row == 2) {
        cell.customCellStyle = WTTableViewCellStyleChecked;
        cell.titleLb.text = @"Checked";
        cell.rightImgView.image = [UIImage imageNamed:@"selected_btn"];
        cell.titleLb.textColor = [UIColor colorWithRed:11/255.0 green:176/255.0 blue:123/255.0 alpha:1];
        cell.bottomLineLb.hidden = NO;
        return cell;
    } else if (indexPath.row == 3) {
        cell.customCellStyle = WTTableViewCellStyleValue1;
        cell.titleLb.text = @"Value1";
        cell.subtitleLb.text = @"subtitle";
        cell.bottomLineLb.hidden = NO;
        return cell;
    } else if (indexPath.row == 4) {
        cell.customCellStyle = WTTableViewCellStyleValue1;
        cell.titleLb.text = @"Value1";
        cell.subtitleLb.text = @"subtitle";
        cell.leftImgView.hidden = NO;
        cell.rightImgView.hidden = NO;
        cell.leftImgView.image = [UIImage imageNamed:@"comments_star_green"];
        cell.rightImgView.image = [UIImage imageNamed:@"comments_star_green"];
        cell.bottomLineLb.hidden = NO;
        return cell;
    }
    
    cell.customCellStyle = WTTableViewCellStyleValue2;
    cell.titleLb.text = @"Value2";
    cell.subtitleLb.text = @"subtitle";

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
