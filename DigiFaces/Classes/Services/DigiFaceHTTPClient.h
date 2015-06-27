

#import "AFHTTPSessionManager.h"

#import "AFHTTPSessionManager.h"

@protocol DigiFaceHTTPClientDelegate;

@interface DigiFaceHTTPClient : AFHTTPSessionManager
@property (nonatomic, weak) id<DigiFaceHTTPClientDelegate>delegate;

+ (DigiFaceHTTPClient *)sharedDigiFaceHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)check_username_availability:(NSString*)username;

@end

@protocol DigiFaceHTTPClientDelegate <NSObject>
@optional
-(void)userNameAvailabilityResponse:(BOOL)isAvailable;
@end