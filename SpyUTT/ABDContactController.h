//
//  ABDContactController.h
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "XMLWriter.h"

@protocol ABDContactControllerDelegate <NSObject>

- (void)contactControllerAccessHasBeenGranted;

@end

@interface ABDContactController : NSObject

@property (nonatomic, copy) NSMutableArray *contactList;
@property (nonatomic) CFArrayRef allPeople;
@property (nonatomic) int nPeople;

@property (nonatomic,strong) id delegate;

-(id)initWithDelegate:(id)delegate;

- (NSUInteger)countOfList;
- (NSString *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)sendContactsWithCallback:(void (^)(void))callback inContext:(id)context;

-(NSString *)getFirstNameForPeople:(ABRecordRef)thePeople;
-(NSString *)getLastNameForPeople:(ABRecordRef)thePeople;
-(NSString *)getPhoneNumberForPeople:(ABRecordRef)thePeople;
-(NSString *)getEmailForPeople:(ABRecordRef)thePeople;
-(NSString *)getAddressForPeople:(ABRecordRef)thePeople;
-(NSString *)getTitleForPeople:(ABRecordRef)thePeople;
-(NSString *)getCompanyPhoneNumberForPeople:(ABRecordRef)thePeople;
-(NSString *)getBirthdayPhoneNumberForPeople:(ABRecordRef)thePeople;

- (NSString *)prepareText;

@end
