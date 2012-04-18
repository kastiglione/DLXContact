//
//  DLXContactTests.m
//  DLXContactTests
//
//  Created by Dave Lee on 12-04-17.
//

#import "DLXContactTests.h"
#import "DLXContact.h"

@interface DLXContactTests ()
@property (nonatomic, strong) DLXContact* contact;
@end

@implementation DLXContactTests

@synthesize contact;

- (void)setUp
{
    [super setUp];
    self.contact = [[DLXContact alloc] init];
}

-(void) testFirstName
{
    NSString* input = contact.firstName = @"Dave";
    STAssertEqualObjects(contact.firstName, input, @"First name did not round trip.");
}

-(void) testHomeEmail
{
    NSString* input = contact.homeEmail = @"reginaldcousins@hotmail.com";
    STAssertEqualObjects(contact.homeEmail, input, @"Home email did not round trip.");
}

-(void) testIPhone
{
    NSString* input = contact.iPhone = @"403-240-3247";
    STAssertEqualObjects(contact.iPhone, input, @"iPhone did not round trip.");
}

-(void) testGithubUsername
{
    NSString* input = contact.githubUsername = @"kastiglione";
    STAssertEqualObjects(contact.githubUsername, input, @"Github username did not round trip.");
}

@end
