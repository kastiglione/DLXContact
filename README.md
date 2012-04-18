# Easy API for iOS Contacts

## Requirements

The code uses ARC, which requires: Xcode 4.2 or newer and iOS 4 and newer.

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

## License

Licensed under the MIT License

see `LICENSE.txt`
