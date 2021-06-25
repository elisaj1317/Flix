//
//  MoviesViewController.m
//  Flix
//
//  Created by Elisa Jacobo Arill on 6/23/21.
//

// Light Mode HEX:
// Background: DCFBFC
// Synopsis Label: 98C1D9
// Main Text: 000000
// Other Text: 555555

// Dark Mode HEX:
// Background: 121228
// Synopsis Label: 1F0566
// Main Text: FFFFFF
// Other Text: AAAAAA

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end



@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // finds currently playing movies
    [self fetchMovies];
    
    // runs fetchMovies when screen pulled up
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchMovies {
    // access API and stores movies in self.movies
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               // Network Error has occured
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Load Data"
                                                                                          message:@"The internet connection appears to be offline."
                                                                                   preferredStyle:(UIAlertControllerStyleAlert)];
               // create a try again action
               UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                        style:UIAlertActionStyleDefault
                                                                                                                         handler:^(UIAlertAction * _Nonnull action) {
                   [self fetchMovies];
                   
               }];
               
               // add the try again action to the alertController
               [alert addAction:tryAgainAction];
               
               // shows connection error
               [self presentViewController:alert animated:YES completion:^{
               }];
               
           }
           else {
               // store all data
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               
               // store movies
               self.movies = dataDictionary[@"results"];
               
               // reloads table after movie info fetched
               [self.tableView reloadData];
               [self.activityIndicator stopAnimating];
               
           }
        // resets the refresh circle
        [self.refreshControl endRefreshing];
        
       }];
    [task resume];
}

// sets rows in table to number of movies
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

// sets up cells in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell has MovieCell format
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    // sets labels
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    // sets poster picture
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    cell.posterView.image = nil;
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];

    [cell.posterView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"movie_placeholder"]
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            cell.posterView.alpha = 0.0;
                                            cell.posterView.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.5sec
                                            [UIView animateWithDuration:0.5 animations:^{
                                                cell.posterView.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            NSLog(@"Image was cached so just update the image");
                                            cell.posterView.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    // initializes background color
    cell.backgroundColor = [UIColor
                           colorWithRed: 220.0 / 255.0
                           green: 251.0 / 255.0
                           blue: 252.0/ 255.0
                           alpha: 1.0];
    
    // sets highlighted state for cells
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor
                                      colorWithRed: 199.0 / 255.0
                                      green: 226.0 / 255.0
                                      blue: 228.0/ 255.0
                                      alpha: 1.0];
    cell.selectedBackgroundView = backgroundView;
    
    
    return cell;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Passes selected Movie into DetailsViewController
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;
    
}


@end
