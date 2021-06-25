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
    NSLog(@"details view is loading");
    
    // set up poster image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    self.posterView.image = nil;
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];

    [self.posterView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"movie_placeholder"]
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            self.posterView.alpha = 0.0;
                                            self.posterView.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.5sec
                                            [UIView animateWithDuration:0.5 animations:^{
                                                self.posterView.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            NSLog(@"Image was cached so just update the image");
                                            self.posterView.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    // set up backdrop image low -> high res
    NSString *smallUrlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w45%@", self.movie[@"backdrop_path"]];
    NSString *largeUrlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", self.movie[@"backdrop_path"]];
    
    NSURL *urlSmall = [NSURL URLWithString:smallUrlString];
    NSURL *urlLarge = [NSURL URLWithString:largeUrlString];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];

    __weak DetailsViewController *weakSelf = self;

    [self.backdropView setImageWithURLRequest:requestSmall
                          placeholderImage:[UIImage imageNamed:@"movie_placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
                                       weakSelf.backdropView.alpha = 0.0;
                                       weakSelf.backdropView.image = smallImage;
                                       
                                       [UIView animateWithDuration:0.3
                                                        animations:^{
                                                            
                                                            weakSelf.backdropView.alpha = 1.0;
                                           
                                                            
                                                        } completion:^(BOOL finished) {
                                                            [weakSelf.backdropView setImageWithURLRequest:requestLarge
                                                                                  placeholderImage:smallImage
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                weakSelf.backdropView.image = largeImage;
                                                                                  }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               // do something for the failure condition of the large image request
                                                                                               // possibly setting the ImageView's image to a default image
                                                                                           }];
                                                        }];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       // do something for the failure condition
                                       // possibly try to get the large image
                                   }];
    
    
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
