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

@interface MoviesViewController ()
@property NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *plotSegmented;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    //map each movie to the cell
    
    return cell;
}

- (IBAction)onSearchPressed:(id)sender {
    NSString *title = self.titleTextField.text;
    
    if ([self isMovieSaved:title]) {
        //load from core data
    }else{
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
    
    //map the json to the object
    
    return movie;
}

-(void) saveMovie: (Movie *) movie{
    
    //save in core data the new movie and add it to the tableView array
}

@end
