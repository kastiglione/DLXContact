//
//  DLXContact.h
//  DLXContact
//
//  Created by Dave Lee on 12-04-17.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface DLXContact : NSObject

-(id) initWithRecord: (ABRecordRef) record;

@property (nonatomic, readonly) ABRecordRef ABRecord;

@property NSString* firstName;
@property NSString* lastName;
@property NSString* middleName;
@property NSString* prefix;
@property NSString* suffix;
@property NSString* nickname;
@property NSString* phoneticFirstName;
@property NSString* phoneticLastName;
@property NSString* phoneticMiddleName;
@property NSString* organization;
@property NSString* jobTitle;
@property NSString* department;
@property NSString* note;
@property NSDate* birthday;

@property NSString* homeEmail;
@property NSString* workEmail;

@property NSString* homePhone;
@property NSString* workPhone;
@property NSString* mainPhone;
@property NSString* mobilePhone;
@property NSString* iPhone;

@property NSString* skypeUsername;

@property NSString* githubUsername;

@end
