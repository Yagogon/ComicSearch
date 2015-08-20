//
//  CharactersViewController.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 19/8/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "CharactersViewController.h"
#import "CharactersViewModel.h"
#import "CharacterResultViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIKit+AFNetworking.h>

@interface CharactersViewController ()
@property (strong, nonatomic) CharactersViewModel *viewModel;
@end

@implementation CharactersViewController

-(id) initWithVolumeIdentifier: (NSString *) volumeIdentifier style:(UITableViewStyle) style {
    
    
    if (self = [super initWithStyle:style]) {
        _viewModel = [[CharactersViewModel alloc] initWithVolumeIdentifier:volumeIdentifier];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
        
        @weakify(self);
        [self.viewModel.didUpdateCharactersSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView reloadData];
        }];

    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
      // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

       return [self.viewModel numberOfCharacters];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    CharacterResultViewModel *result = [self.viewModel resultAtIndex:indexPath.row];

    cell.textLabel.text = result.name;
    [cell.imageView setImageWithURL:result.imageURL placeholderImage:[UIImage imageNamed:@"superhero.png"]];

    return cell;

}

@end
