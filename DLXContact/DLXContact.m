//
//  DLXContact.m
//  DLXContact
//
//  Created by Dave Lee on 12-04-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DLXContact.h"

static NSDictionary* MultiValueAsDictionary(ABMultiValueRef multiValue);

@interface DLXContact ()
@property (nonatomic, assign) ABRecordRef record;
@end


@implementation DLXContact

@synthesize record = _record;

-(id) initWithRecord: (ABRecordRef) record
{
    self = [super init];
    if (self != nil) {
        _record = CFRetain(record);
    }
    return self;
}

-(id) init
{
    ABRecordRef person = ABPersonCreate();
    self = [self initWithRecord: person];
    CFRelease(person);
    return self;
}

-(void) dealloc
{
    CFRelease(_record);
}

-(ABRecordRef) ABRecord
{
    return self.record;
}

#pragma mark -
#pragma mark Basic Properties

#define DEFINE_GETTER($type, $method, $property) \
-($type) $method \
{ \
    return (__bridge_transfer $type) ABRecordCopyValue(self.record, kABPerson##$property##Property); \
}

#define DEFINE_SETTER($type, $method, $property) \
-(void) $method: ($type) value \
{ \
    ABRecordSetValue(self.record, kABPerson##$property##Property, (__bridge CFStringRef) value, NULL); \
}

#define DEFINE_STRING_GETTER($method, $property) DEFINE_GETTER(NSString*, $method, $property)
#define DEFINE_STRING_SETTER($method, $property) DEFINE_SETTER(NSString*, $method, $property)

DEFINE_STRING_GETTER(firstName, FirstName)
DEFINE_STRING_SETTER(setFirstName, FirstName)
DEFINE_STRING_GETTER(lastName, LastName)
DEFINE_STRING_SETTER(setLastName, LastName)
DEFINE_STRING_GETTER(middleName, MiddleName)
DEFINE_STRING_SETTER(setMiddleName, MiddleName)
DEFINE_STRING_GETTER(prefix, Prefix)
DEFINE_STRING_SETTER(setPrefix, Prefix)
DEFINE_STRING_GETTER(suffix, Suffix)
DEFINE_STRING_SETTER(setSuffix, Suffix)
DEFINE_STRING_GETTER(nickname, Nickname)
DEFINE_STRING_SETTER(setNickname, Nickname)
DEFINE_STRING_GETTER(phoneticFirstName, FirstNamePhonetic)
DEFINE_STRING_SETTER(setPhoneticFirstName, FirstNamePhonetic)
DEFINE_STRING_GETTER(phoneticLastName, LastNamePhonetic)
DEFINE_STRING_SETTER(setPhoneticLastName, LastNamePhonetic)
DEFINE_STRING_GETTER(phoneticMiddleName, MiddleNamePhonetic)
DEFINE_STRING_SETTER(setPhoneticMiddleName, MiddleNamePhonetic)
DEFINE_STRING_GETTER(organization, Organization)
DEFINE_STRING_SETTER(setOrganization, Organization)
DEFINE_STRING_GETTER(jobTitle, JobTitle)
DEFINE_STRING_SETTER(setJobTitle, JobTitle)
DEFINE_STRING_GETTER(department, Department)
DEFINE_STRING_SETTER(setDepartment, Department)
DEFINE_STRING_GETTER(note, Note)
DEFINE_STRING_SETTER(setNote, Note)

DEFINE_GETTER(NSDate*, birthday, Birthday)
DEFINE_SETTER(NSDate*, setBirthday, Birthday)

#pragma mark -
#pragma mark Email and Phone Properties

#define DEFINE_MULTI_GETTER($type, $kind, $Property, $Label) \
-(NS##$type *) $kind##$Property \
{ \
    ABMultiValueRef multiValue = ABRecordCopyValue(self.record, kABPerson##$Property##Property); \
    if (multiValue == nil) \
        return nil; \
\
    NSDictionary* dictionary = MultiValueAsDictionary(multiValue); \
    NS##$type * result = [dictionary objectForKey: (__bridge NS##$type *) kAB##$Label##Label]; \
    CFRelease(multiValue); \
    return result; \
}

#define DEFINE_MULTI_SETTER($type, $kind, $Property, $Label) \
-(void) $kind##$Property: (NS##$type *) value \
{ \
    ABPropertyID property = kABPerson##$Property##Property; \
    ABMultiValueRef multiValue = ABRecordCopyValue(self.record, property); \
    ABMutableMultiValueRef mutableMultiValue = multiValue ? ABMultiValueCreateMutableCopy(multiValue) : ABMultiValueCreateMutable(kABMulti##$type##PropertyType); \
    ABMultiValueAddValueAndLabel(mutableMultiValue, (__bridge CF##$type##Ref) value, kAB##$Label##Label, NULL); \
    ABRecordSetValue(self.record, property, mutableMultiValue, NULL); \
    CFRelease(mutableMultiValue); \
    if (multiValue) CFRelease(multiValue); \
}

DEFINE_MULTI_GETTER(String, home, Email, Home)
DEFINE_MULTI_SETTER(String, setHome, Email, Home)
DEFINE_MULTI_GETTER(String, work, Email, Work)
DEFINE_MULTI_SETTER(String, setWork, Email, Work)

DEFINE_MULTI_GETTER(String, home, Phone, Home)
DEFINE_MULTI_SETTER(String, setHome, Phone, Home)
DEFINE_MULTI_GETTER(String, work, Phone, Work)
DEFINE_MULTI_SETTER(String, setWork, Phone, Work)
DEFINE_MULTI_GETTER(String, main, Phone, PersonPhoneMain)
DEFINE_MULTI_SETTER(String, setMain, Phone, PersonPhoneMain)
DEFINE_MULTI_GETTER(String, mobile, Phone, PersonPhoneMobile)
DEFINE_MULTI_SETTER(String, setMobile, Phone, PersonPhoneMobile)
// -iPhone and -setIPhone:
DEFINE_MULTI_GETTER(String, i, Phone, PersonPhoneIPhone)
DEFINE_MULTI_SETTER(String, setI, Phone, PersonPhoneIPhone)


#pragma mark -
#pragma mark Instant Message Services

-(NSString*) skypeUsername
{
    ABMultiValueRef multiValue = ABRecordCopyValue(self.record, kABPersonInstantMessageProperty);
    if (multiValue == nil)
        return nil;

    NSDictionary* dictionary = MultiValueAsDictionary(multiValue);
    NSString* keyPath = [NSString stringWithFormat: @"%@.%@", (__bridge NSString*) kABPersonInstantMessageServiceSkype, (__bridge NSString*) kABPersonInstantMessageUsernameKey];
    NSString* result = [dictionary valueForKeyPath: keyPath];
    CFRelease(multiValue);
    return result;
}

-(void) setSkypeUsername: (NSString*) value
{
    ABPropertyID property = kABPersonInstantMessageProperty;
    ABMultiValueRef multiValue = ABRecordCopyValue(self.record, property);
    ABMutableMultiValueRef mutableMultiValue = multiValue ? ABMultiValueCreateMutableCopy(multiValue) : ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                (__bridge NSString*) kABPersonInstantMessageServiceSkype, kABPersonInstantMessageServiceKey,
                                value, kABPersonInstantMessageUsernameKey, nil];
    ABMultiValueAddValueAndLabel(mutableMultiValue, (__bridge CFDictionaryRef) dictionary, kABPersonInstantMessageServiceSkype, NULL);
    ABRecordSetValue(self.record, property, mutableMultiValue, NULL);
    CFRelease(mutableMultiValue);
    if (multiValue) CFRelease(multiValue);
}


#pragma mark -
#pragma mark Custom Social Profile Services

static NSString* const kGithubServiceKey = @"Github";
static NSString* const kGithubURLBase = @"https://github.com/";

-(NSString*) githubUsername
{
    ABMultiValueRef multiValue = ABRecordCopyValue(self.record, kABPersonSocialProfileProperty);
    if (multiValue == nil)
        return nil;

    NSDictionary* dictionary = MultiValueAsDictionary(multiValue);
    NSString* keyPath = [NSString stringWithFormat: @"%@.%@", kGithubServiceKey, (__bridge NSString*) kABPersonSocialProfileUsernameKey];
    NSString* result = [dictionary valueForKeyPath: keyPath];
    CFRelease(multiValue);
    return result;
}

-(void) setGithubUsername: (NSString*) value
{
    ABPropertyID property = kABPersonSocialProfileProperty;
    ABMultiValueRef multiValue = ABRecordCopyValue(self.record, property);
    ABMutableMultiValueRef mutableMultiValue = multiValue ? ABMultiValueCreateMutableCopy(multiValue) : ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSString* URLString = [kGithubURLBase stringByAppendingString: value];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                kGithubServiceKey, kABPersonSocialProfileServiceKey,
                                value, kABPersonSocialProfileUsernameKey,
                                URLString, kABPersonSocialProfileURLKey, nil];
    CFErrorRef error = nil;
    ABMultiValueAddValueAndLabel(mutableMultiValue, (__bridge CFDictionaryRef) dictionary, (__bridge CFStringRef) kGithubServiceKey, NULL);
    ABRecordSetValue(self.record, property, mutableMultiValue, &error);
    CFRelease(mutableMultiValue);
    if (multiValue) CFRelease(multiValue);
}


#pragma mark -
#pragma mark Utilities

static
NSDictionary* MultiValueAsDictionary(ABMultiValueRef multiValue)
{
    if (multiValue == nil)
        return nil;

    NSArray* values = (__bridge_transfer NSArray*) ABMultiValueCopyArrayOfAllValues(multiValue);
    NSMutableArray* labels = [NSMutableArray arrayWithCapacity: ABMultiValueGetCount(multiValue)];
    for (CFIndex index = 0; index < ABMultiValueGetCount(multiValue); ++index) {
        [labels addObject: (__bridge_transfer NSString*) ABMultiValueCopyLabelAtIndex(multiValue, index)];
    }
    return [NSDictionary dictionaryWithObjects: values forKeys: labels];
}

@end
