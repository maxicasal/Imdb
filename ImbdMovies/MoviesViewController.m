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
    self.titleTextField.text = @"";
    [self.view endEditing:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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

- (void)mapMovie:(NSDictionary *)movieD movie:(Movie *)movie {
    movie.title = [movieD objectForKey:@"title"];
    movie.rated =@"No rated";
    movie.imageURL = [movieD objectForKey:@"urlPoster"];
    movie.plot = [movieD objectForKey:@"plot"];
    NSArray *genres =[movieD objectForKey:@"genres"];
    NSMutableString *genreResult = [NSMutableString new];
    for (NSString* genre in genres){
        [genreResult appendString:[NSString stringWithFormat:@"%@, ", genre]];
    }
    movie.genre = [NSString stringWithString:genreResult];
    NSDate *date =[NSDate dateWithTimeIntervalSinceNow:[[movieD objectForKey:@"releaseDate"] doubleValue]];
    movie.releaseDate = [[date description] stringByReplacingOccurrencesOfString:@" +0000" withString:@""];;
    NSArray *runTime =[movieD objectForKey:@"runtime"];
    if (runTime.count > 0) {
        movie.time = [runTime objectAtIndex:0];
    }else{
        movie.time =@"113 min";
    }
}

- (void)searchMovies:(NSString *)stringURL {
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               
                               for (int index = 0; index < results.count; index++) {
                                   NSArray*moviesArray = [[results objectAtIndex:index] objectForKey:@"movies"];
                                   for(int i = 0; i<moviesArray.count; i++){
                                       NSDictionary *movieD = [moviesArray objectAtIndex:i];
                                       Movie *movie = [Movie new];
                                       [self mapMovie:movieD movie:movie];
                                       [self.movies addObject:movie];
                                   }
                               }
                               
                               [self.moviesTableView reloadData];
                               [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                           }];
}

- (IBAction)onComingSoonPressed:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* stringURL = @"http://www.myapifilms.com/imdb/comingSoon";
    [self searchMovies:stringURL];
}

- (IBAction)onTopPressed:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* stringURL = @"http://www.myapifilms.com/imdb/inTheaters";
    [self searchMovies:stringURL];
}

-(Movie *) getMovieFromAPI: (NSString *) movieSearch{
    Movie *movie = [Movie new];
    
    NSURL *url = [NSURL URLWithString:movieSearch];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               NSDictionary *movieDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               movie.title = [movieDictionary objectForKey:@"Title"];
                               movie.rated =[movieDictionary objectForKey:@"Rated"];
                               movie.imageURL = [movieDictionary objectForKey:@"Poster"];
                               movie.plot = [movieDictionary objectForKey:@"Plot"];
                               movie.genre = [movieDictionary objectForKey:@"Genre"];
                               movie.releaseDate = [movieDictionary objectForKey:@"Released"];
                               movie.time = [movieDictionary objectForKey:@"Runtime"];
                               [self.movies addObject:movie];
                               [self.moviesTableView reloadData];
                               [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
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
