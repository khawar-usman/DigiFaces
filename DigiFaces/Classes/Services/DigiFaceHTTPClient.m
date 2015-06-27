

#import "DigiFaceHTTPClient.h"

#warning PASTE YOUR API KEY HERE
static NSString * const DigiFaceOnlineAPIKey = @"PASTE YOUR API KEY HERE";

static NSString * const DigiFaceOnlineURLString = @"http://digifacesservices.focusforums.com/";

@implementation DigiFaceHTTPClient

+ (DigiFaceHTTPClient *)sharedDigiFaceHTTPClient
{
    static DigiFaceHTTPClient *_sharedDigiFaceHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDigiFaceHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:DigiFaceOnlineURLString]];
    });
    
    return _sharedDigiFaceHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];

    }
    
    return self;
}

- (void)check_username_availability:(NSString*)username
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"UserNameToCheck"] = username;
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    parameters[@"access_token"] = onlinekey;;
    
    [self POST:@"api/Account/IsUserNameAvailable" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(userNameAvailabilityResponse:)]) {
            [self.delegate userNameAvailabilityResponse:[responseObject objectForKey:@"IsAvailable"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
        NSLog(@"%@",error);
        
    }];
}

@end
