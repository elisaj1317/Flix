//
//  DetailsViewController.m
//  Flix
//
//  Created by Elisa Jacobo Arill on 6/23/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIView *synopsisView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up poster image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    // set up backdrop image
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    
    // set up labels
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    
    NSString *rating = self.movie[@"vote_average"];
    double dec_rating = [rating doubleValue];
    self.ratingLabel.text = [NSString stringWithFormat:@"%0.1f / 10.0", dec_rating];
    self.title = self.movie[@"title"];
    
//    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    // Change size of view to be bigger than label
    CGRect newFrame = self.synopsisView.frame;

    newFrame.size.width = self.synopsisLabel.frame.size.width + 20;
    newFrame.size.height = self.synopsisLabel.frame.size.height + 20 + 25;
    [self.synopsisView setFrame:newFrame];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
