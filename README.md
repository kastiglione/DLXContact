# Easy API for iOS Contacts

## Installation

Copy `DLXContact.h` and `DLXContact.m` to your project.

## Usage

```objc
    DLXContact* contact = [[DLXContact alloc] init];
    contact.firstName = @"Reginald";
    contact.lastName = @"Cousins";
    contact.homeEmail = @"bubbles@hotmail.com";
    contact.githubUsername = @"bubbs";
    ABRecordRef person = contact.ABRecord;
```

see `DLXContact.h` for full API.
