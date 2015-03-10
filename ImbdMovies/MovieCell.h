//
//  MovieCell.h
//  ImbdMovies
//
//  Created by Maximiliano Casal on 3/10/15.
//  Copyright (c) 2015 Maximiliano Casal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratedLabel;
@property (weak, nonatomic) IBOutlet UITextView *plotTextView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
