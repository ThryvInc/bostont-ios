//
//  ScheduleViewController.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/7/12.
//
//

#import "ScheduleViewController.h"
#import "LineInfoViewController.h"
#import "SubwayModel.h"

@interface ScheduleViewController ()
@property (nonatomic, strong) SubwayModel *model;
@end

@implementation ScheduleViewController
@synthesize model = _model;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:.1 green:0 blue:.25 alpha:1];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Blue"] || [segue.identifier isEqualToString:@"Red"] || [segue.identifier isEqualToString:@"Orange"]) {
        ((LineInfoViewController *)segue.destinationViewController).model = self.model;
    }
}

- (IBAction)lineChosen:(UIButton *)sender
{
    NSString *line = [[sender.titleLabel.text componentsSeparatedByString:@" "] objectAtIndex:0];
    
    UIAlertView *loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading.\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [loadingAlert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(loadingAlert.bounds.size.width / 2, loadingAlert.bounds.size.height - 50);
    [indicator startAnimating];
    [loadingAlert addSubview:indicator];
    
    dispatch_queue_t queue = dispatch_queue_create("get line and start", NULL);
    dispatch_async(queue, ^{
        NSString *urlString = [NSString stringWithFormat:@"http://Developer.mbta.com/lib/rthr/%@.json",[line lowercaseString]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        // Tell MIME that content type
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-type"];
        NSLog(@"url: %@",urlString);
        NSURLResponse *response;
        NSError *error;
        NSData *retData = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:&response
                                                            error:&error];
        if (!error) {
            NSLog(@"response: %@", [NSString stringWithUTF8String:[retData bytes]]);
            NSDictionary *json = [self dataToJSON:retData];
            
            NSLog(@"%@",[[json objectForKey:@"TripList"] objectForKey:@"Line"]);
            
            self.model = [[SubwayModel alloc] initWithJson:[json objectForKey:@"TripList"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                
                [self performSegueWithIdentifier:line sender:self];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Internet Connection"
                                                               message:@"Please make sure you are connected to the internet."
                                                              delegate:self
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles: nil];
                [alert show];
            });
            
            NSLog(@"error:\n%@", error.debugDescription);
        }
    });
    dispatch_release(queue);
}

- (IBAction)greenInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Green Line"
                                                    message:@"Unfortunately, the MBTA does not offer schedule updates for the green line. But the moment they do, we'll be sure to pass it on to you!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil
                          ];
    [alert show];
}

- (IBAction)map:(id)sender
{
    [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (NSDictionary *) dataToJSON:(NSData *)data
{
    NSError *e;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
    
    return json;
}
@end
