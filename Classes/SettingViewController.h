//
//  SettingViewController.h
//  DragonRador
//
//  Created by Motohiro Takayama on 6/7/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
   UITableView *table_view;
   UITextField *userField;
   UITextField *passwordField;
}

@property (nonatomic, retain) UITableView *table_view;

@end
