//
//  MoviesViewController.m
//  ImbdMovies
//
//  Created by Maximiliano Casal on 3/10/15.
//  Copyright (c) 2015 Maximiliano Casal. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "Movie.h"

@interface MoviesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *plotSegmented;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movies = [NSMutableArray new];
    [self loadMovies];
}

-(void) loadMovies{
    //load all movies from core data for the table
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = movie.title;
    cell.genreLabel.text = movie.genre;
    cell.ratedLabel.text = movie.rated;
    cell.timeLabel.text = movie.time;
    cell.releaseDateLabel.text = movie.releaseDate;
    cell.plotTextView.text = movie.plot;
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.genreLabel.adjustsFontSizeToFitWidth = YES;
    cell.ratedLabel.adjustsFontSizeToFitWidth = YES;
    cell.timeLabel.adjustsFontSizeToFitWidth = YES;
    cell.releaseDateLabel.adjustsFontSizeToFitWidth = YES;
//    NSURL*photoUrl = [NSURL URLWithString:movie.imageURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:photoUrl];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
//     {
//         if (!error)
//         {
//             UIImage* image = [[UIImage alloc] initWithData:data];
//             cell.imageView.image = image;
//         }
//     }];
    return cell;
}

- (IBAction)onSearchPressed:(id)sender {
    NSString *title = self.titleTextField.text;
    
    if ([self isMovieSaved:title]) {
        //load from core data
    }else{
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *plot = @"";
        if (self.plotSegmented.selectedSegmentIndex == 0) {
            plot =@"full";
        }else{
            plot = @"short";
        }
        NSString *url = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@&y=&plot=%@t&r=json", title, plot];
        [self searchMovie:url];
    }
}

-(BOOL) isMovieSaved: (NSString*) title{
    //search in database if the movie is saved
    return NO;
}

-(void) searchMovie: (NSString *)movieSearch{
    
    Movie *movie = [self getMovieFromAPI:movieSearch];
    
    [self saveMovie:movie];
}

-(Movie *) getMovieFromAPI: (NSString *) movieSearch{
    Movie *movie = [Movie new];
    
    NSURL *url = [NSURL URLWithString:movieSearch];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                               movie.title = [dict objectForKey:@"Title"];
                               movie.rated =[dict objectForKey:@"Rated"];
                               movie.imageURL = [dict objectForKey:@"Poster"];
                               movie.plot = [dict objectForKey:@"Plot"];
                               movie.genre = [dict objectForKey:@"Genre"];
                               movie.releaseDate = [dict objectForKey:@"Released"];
                               movie.time = [dict objectForKey:@"Runtime"];
                               
                               [self.movies addObject:movie];
                               [self.moviesTableView reloadData];
                           }];
    
    return movie;
}

-(void) saveMovie: (Movie *) movie{
    
    //save in core data the new movie and add it to the tableView array
}
- (IBAction)onTapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
