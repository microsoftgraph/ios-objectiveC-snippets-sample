/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "Authentication.h"
#import "MasterViewController.h"
#import "SnippetInfo.h"
#import "Snippets.h"
#import <MSGraphSDK/MSGraphSDK.h>


@interface Snippets()

@property (strong, nonatomic) MSGraphClient *graphClient;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *displayName;

@end

@implementation Snippets

- (instancetype)init {
    self = [super init];
    if (self){
        [self initializeSnippetGroups];
    }
    return self;
}

- (void)setGraphClientWithAuthProvider:(id<MSAuthenticationProvider>)provider {
    [MSGraphClient setAuthenticationProvider:provider];
    self.graphClient = [MSGraphClient client];
    
    //Helper method for retrieving some user info to assist with some of the snippet cases.
    [self getUserInfo];
}




- (void)initializeSnippetGroups {
    NSMutableArray *snippetGroups = [NSMutableArray new];
    NSMutableArray *snippetGroupNames = [NSMutableArray new];
    
    NSArray *userSection = @[[[SnippetInfo alloc] initWithName:@"Get me"            needsAdmin:NO action:@selector(getMe)],
                             [[SnippetInfo alloc] initWithName:@"Get users"         needsAdmin:NO action:@selector(getUsers)],
                             [[SnippetInfo alloc] initWithName:@"Get drive"         needsAdmin:NO action:@selector(getDrive)],
                             [[SnippetInfo alloc] initWithName:@"Get events"        needsAdmin:NO action:@selector(getEvents)],
                             [[SnippetInfo alloc] initWithName:@"Create event"      needsAdmin:NO action:@selector(createEvent)],
                             [[SnippetInfo alloc] initWithName:@"Update event"      needsAdmin:NO action:@selector(updateEvent)],
                             [[SnippetInfo alloc] initWithName:@"Delete event"      needsAdmin:NO action:@selector(deleteEvent)],
                             [[SnippetInfo alloc] initWithName:@"Get messages"      needsAdmin:NO action:@selector(getMessages)],
                             [[SnippetInfo alloc] initWithName:@"Send message"      needsAdmin:NO action:@selector(sendMessage)],
                             [[SnippetInfo alloc] initWithName:@"Get user files"    needsAdmin:NO action:@selector(getUserFiles)],
                             [[SnippetInfo alloc] initWithName:@"Create text file"  needsAdmin:NO action:@selector(createTextFile)],
                             [[SnippetInfo alloc] initWithName:@"Create folder"     needsAdmin:NO action:@selector(createFolder)],
                             [[SnippetInfo alloc] initWithName:@"Download file"     needsAdmin:NO action:@selector(downloadFile)],
                             [[SnippetInfo alloc] initWithName:@"Update file"       needsAdmin:NO action:@selector(updateFile)],
                             [[SnippetInfo alloc] initWithName:@"Rename file"       needsAdmin:NO action:@selector(renameFile)],
                             [[SnippetInfo alloc] initWithName:@"Delete file"       needsAdmin:NO action:@selector(deleteFile)],
                             [[SnippetInfo alloc] initWithName:@"Get manager"       needsAdmin:NO action:@selector(getManager)],
                             [[SnippetInfo alloc] initWithName:@"Get directs"       needsAdmin:NO action:@selector(getDirects)],
                             [[SnippetInfo alloc] initWithName:@"Get photo"         needsAdmin:NO action:@selector(getPhoto)],
                             [[SnippetInfo alloc] initWithName:@"Create user"       needsAdmin:NO action:@selector(createUser)],
                             [[SnippetInfo alloc] initWithName:@"Get user groups"   needsAdmin:NO action:@selector(getUserGroups)]];

    NSArray *groupsSection = @[[[SnippetInfo alloc] initWithName:@"Get all groups"  needsAdmin:YES action:@selector(getAllGroups)],
                               [[SnippetInfo alloc] initWithName:@"Get single group"needsAdmin:YES action:@selector(getSingleGroup)],
                               [[SnippetInfo alloc] initWithName:@"Get members"     needsAdmin:YES action:@selector(getMembers)],
                               [[SnippetInfo alloc] initWithName:@"Get owners"      needsAdmin:YES action:@selector(getOwners)],
                               [[SnippetInfo alloc] initWithName:@"Create group"    needsAdmin:YES action:@selector(createGroup)],
                               [[SnippetInfo alloc] initWithName:@"Update group"    needsAdmin:YES action:@selector(updateGroup)],
                               [[SnippetInfo alloc] initWithName:@"Delete group"    needsAdmin:YES action:@selector(deleteGroup)]];
    
    [snippetGroups addObject:userSection];
    [snippetGroupNames addObject:@"Users"];
    [snippetGroups addObject:groupsSection];
    [snippetGroupNames addObject:@"Groups"];
    
    _snippetGroups = [NSArray arrayWithArray:snippetGroups];
    _snippetGroupNames = [NSArray arrayWithArray:snippetGroupNames];
}


#pragma mark - Snippets - Users

// Returns select information about the signed-in user from Azure Active Directory. Applies to personal or work accounts
- (void)getMe {
    [[[self.graphClient me] request] getWithCompletion:^(MSGraphUser *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = [NSString stringWithFormat:@"Retrieval of account information succeeded for %@", response.displayName];
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Returns all of the users in your tenant's directory.  to personal or work accounts
- (void)getUsers {
    [[[self.graphClient users] request] getWithCompletion:^(MSCollection *response, MSGraphUsersCollectionRequest *nextRequest, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSMutableString *responseString = [NSMutableString stringWithString:@"List of users:\n"];
            for(MSGraphUser *user in response.value){
                [responseString appendFormat:@"%@ \n", user.displayName];
            }
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Gets the signed-in user's drive from OneDrive. Applies to personal or work accounts
- (void)getDrive {
    [[[[self.graphClient me] drive] request] getWithCompletion:^(MSGraphDrive *drive, NSError *error){
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = [NSString stringWithFormat:@"Drive information:\nDriveType is %@\nTotal quota is %lld", drive.driveType, drive.quota.total];
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Gets the signed-in user's events. Applies to personal or work accounts
- (void)getEvents {
    [[[[self.graphClient me] events] request] getWithCompletion:^(MSCollection *response, MSGraphUserEventsCollectionRequest *nextRequest, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSMutableString *responseString = [NSMutableString stringWithString:@"List of events:\n"];
            for(MSGraphEvent *event in response.value){
                [responseString appendFormat:@"%@ \n", event.subject];
            }
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Create an event in the signed in user's calendar. Applies to personal or work accounts.
- (void)createEvent {
    //Creates a sample event and sends it to the logged in user
    MSGraphEvent *event = [self getEventObject];
    
    [[[[self.graphClient me] events] request] addEvent:event withCompletion:^(MSGraphEvent *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = [NSString stringWithFormat:@"Event created with id %@", response.entityId];
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Updates an event in the signed in user's calendar.  Applies to personal or work accounts.
- (void)updateEvent {
    //Creates a sample event and sends it to the logged in user
    [self createSampleEventwithCompletion:^(MSGraphEvent *event, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            event.subject = @"Updated subject";
            [[[[self.graphClient me] events:event.entityId] request] update:event withCompletion:^(MSGraphEvent *response, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = @"Event updated with a new subject.";
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Deletes an event in the signed in user's calendar.  Applies to personal or work accounts.
- (void)deleteEvent {
    //Creates a sample event and sends it to the logged in user
    [self createSampleEventwithCompletion:^(MSGraphEvent *event, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            [[[[self.graphClient me] events:event.entityId] request] deleteWithCompletion:^(NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = [NSString stringWithFormat:@"Deleted calendar event id: %@", event.entityId];
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Gets the signed-in user's messages from Office 365. Applies to personal or work accounts
- (void)getMessages {
    [[[[self.graphClient me] messages] request] getWithCompletion:^(MSCollection *response, MSGraphUserMessagesCollectionRequest *nextRequest, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSMutableString *responseString = [NSMutableString stringWithString:@"List of messages:\n"];
            for(MSGraphMessage *message in response.value){
                [responseString appendFormat:@"%@ \n", message.subject];
            }
            if (nextRequest) {
                [responseString appendFormat:@"Next request available for more messages"];
            }
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Create and send a message as the signed-in user. Applies to personal or work accounts
- (void)sendMessage {
    MSGraphMessage *message = [self getSampleMessage];
    MSGraphUserSendMailRequestBuilder *requestBuilder = [[self.graphClient me]sendMailWithMessage:message saveToSentItems:true];

    MSGraphUserSendMailRequest *mailRequest = [requestBuilder request];
    [mailRequest executeWithCompletion:^(NSDictionary *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = @"Message sent.";
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Returns all of the user's files. Applies to personal or work accounts
- (void)getUserFiles {
    [[[[[[self.graphClient me]drive]root]children]request]getWithCompletion:^(MSCollection *response, MSGraphDriveItemChildrenCollectionRequest *nextRequest, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSMutableString *responseString = [NSMutableString stringWithString:@"List of files:\n"];
            for(MSGraphDriveItem *file in response.value){
                [responseString appendFormat:@"%@: %lld \n", file.name, file.size];
            }
            
            if (nextRequest ) {
                [responseString appendFormat:@"Next request available for more files."];
            }
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Create a text file in the signed in user's OneDrive account- If a file already exists it will be overwritten. Applies to personal or work accounts
- (void)createTextFile {
    NSString *testFile = [[NSString alloc]init];
    NSData *uploadData = [testFile dataUsingEncoding:NSUTF8StringEncoding];
    [[[[[[self.graphClient me] drive] root] itemByPath:@"Test Folder/testTextFile.text"] contentRequest] uploadFromData:uploadData completion:^(MSGraphDriveItem *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = @"File created at Test Folder/testTextFile.text";
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Creates a new folder in the signed in user's OneDrive account. Applies to personal or work accounts
- (void)createFolder {
    MSGraphDriveItem *driveItem = [[MSGraphDriveItem alloc] initWithDictionary:@{[MSNameConflict rename].key : [MSNameConflict rename].value}];
    driveItem.name = @"TestFolder";
    driveItem.folder = [[MSGraphFolder alloc] init];
    
    // Use itemByPath as below to create a subfolder under an existing folder
    [[[[[self.graphClient me]drive] root] request] getWithCompletion:^(MSGraphDriveItem *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            driveItem.entityId  = response.entityId;

            //Create folder
            [[[[[[self.graphClient me] drive] items:driveItem.entityId] children] request] addDriveItem:driveItem withCompletion:^(MSGraphDriveItem *response, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = [NSString stringWithFormat:@"Created a folder %@", response.name];
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Downloads a file into the signed in user's OneDrive account. Applies to personal or work accounts
- (void)downloadFile {
    [self createFilewithCompletion:^(MSGraphDriveItem *driveItem, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            [[[[[self.graphClient me] drive] items:driveItem.entityId] contentRequest] downloadWithCompletion:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = [NSString stringWithFormat:@"Downloaded file at %@", location];
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Uploads a file in the signed in user's OneDrive account. Applies to personal or work accounts
- (void)updateFile {
    [self createFilewithCompletion:^(MSGraphDriveItem *driveItem, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *testText = @"NewTextValue";
            NSData *uploadData = [testText dataUsingEncoding:NSUTF8StringEncoding];
           
            [[[[[self.graphClient me] drive] items:driveItem.entityId] contentRequest] uploadFromData:uploadData completion:^(MSGraphDriveItem *response, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = [NSString stringWithFormat: @"File %@ contents updated",response.name];
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Renames a file in the signed in user's OneDrive account. Applies to personal or work accounts
- (void)renameFile {
    [self createFilewithCompletion:^(MSGraphDriveItem *driveItem, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            driveItem.name = @"NewTextFileName";
            [[[[[self.graphClient me] drive] items:driveItem.entityId] request] update:driveItem withCompletion:^(MSGraphDriveItem *response, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = [NSString stringWithFormat:@"New name is %@",response.name];
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Deletes a file in the signed in user's OneDrive account. Applies to personal or work accounts
- (void)deleteFile {
    [self createFilewithCompletion:^(MSGraphDriveItem *driveItem, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            [[[[[self.graphClient me] drive] items:driveItem.entityId] request] deleteWithCompletion:^(NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = @"File deleted";
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Get user's manager if they have one. Applies to work accounts only
- (void)getManager {
    [[[[self.graphClient me] manager] request] getWithCompletion:^(MSGraphDirectoryObject *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = [NSString stringWithFormat:@"Manager is %@\n\nFull object is %@", response.dictionaryFromItem[@"displayName"], response];
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Get user's direct reports. Applies to work accounts only
- (void)getDirects {
    [[[[self.graphClient me] directReports] request] getWithCompletion:^(MSCollection *response, MSGraphUserDirectReportsCollectionWithReferencesRequest *nextRequest, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSMutableString *responseString = [[NSMutableString alloc]initWithString:@"List of directs: \n"];
            
            for (MSGraphDirectoryObject *direct in response.value) {
                [responseString appendFormat: @"%@", direct.dictionaryFromItem[@"displayName"]];
            }
            
            if (nextRequest) {
                [responseString appendString:@"Next request available for more users"];
                
            }
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Gets the signed-in user's photo data if they have a photo. This snippet will return metadata for the user photo. Applies to work accounts only
- (void)getPhoto {
    [[[[self.graphClient me]photo]request]getWithCompletion:^(MSGraphProfilePhoto *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = [NSString stringWithFormat:@"Photo size is %d x %d", response.height, response.width];
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Creates a new user in the tenant. Applicable to work accounts with admin rights
- (void)createUser {
    NSString *userId = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *domainName = [[self.emailAddress componentsSeparatedByString:@"@"]lastObject];
    NSString *upn = [[[NSString stringWithFormat:@"<User>@<Domain>"]stringByReplacingOccurrencesOfString:@"<User>" withString:userId]stringByReplacingOccurrencesOfString:@"<Domain>" withString:domainName];
    
    MSGraphUser *newUser = [[MSGraphUser alloc]init];
    MSGraphPasswordProfile *passProfile = [[MSGraphPasswordProfile alloc]init];
    passProfile.password = @"!pass!word1";

    newUser.accountEnabled = true;
    newUser.displayName = self.displayName;
    newUser.passwordProfile = passProfile;
    newUser.mailNickname = userId;
    newUser.userPrincipalName = upn;
    
    [[[self.graphClient users] request] addUser:newUser withCompletion:^(MSGraphUser *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = [NSString stringWithFormat:@"User created: %@", response.displayName];
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Gets a collection of groups that the signed-in user is a member of. Applicable to work accounts with admin rights
- (void)getUserGroups {
    [[[[self.graphClient me] memberOf] request] getWithCompletion:^(MSCollection *response, MSGraphUserMemberOfCollectionWithReferencesRequest *nextRequest, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSMutableString *responseString = [[NSMutableString alloc]initWithString:@"List of groups: \n"];
            
            for (MSGraphDirectoryObject *group in response.value) {
                [responseString appendFormat: @"%@", group.dictionaryFromItem[@"displayName"]];
            }
            
            if (nextRequest) {
                [responseString appendString:@"Next request available for more groups."];
            }
            
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


#pragma mark - Snippets - Groups

// Returns all of the groups in your tenant's directory. Applicable to work accounts with admin rights
- (void)getAllGroups {
    [[[self.graphClient groups] request] getWithCompletion:^(MSCollection *response, MSGraphGroupsCollectionRequest *nextRequest, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSMutableString *responseString = [[NSMutableString alloc]initWithString:@"List of all groups: \n"];
            
            for (MSGraphDirectoryObject *group in response.value) {
                [responseString appendFormat: @"%@", group.dictionaryFromItem[@"displayName"]];
            }
            
            if (nextRequest) {
                [responseString appendString:@"Next request available for more groups."];
            }
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Gets a specified group. Applicable to work accounts with admin rights
- (void)getSingleGroup {
    [self createGroupwithCompletion:^(MSGraphGroup *group, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            [[[[self.graphClient groups] group:group.entityId] request] getWithCompletion:^(MSGraphGroup *response, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = [NSString stringWithFormat:@"Retrieved group: %@", response.displayName];
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Gets a specific group's members. Applicable to work accounts with admin rights
- (void)getMembers {
    [self createGroupwithCompletion:^(MSGraphGroup *group, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            [[[[[self.graphClient groups] group:group.entityId] members] request] getWithCompletion:^(MSCollection *response, MSGraphGroupMembersCollectionWithReferencesRequest *nextRequest, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSMutableString *responseString = [[NSMutableString alloc]initWithString:@"List of members: \n"];
                    
                    for (MSGraphDirectoryObject *member in response.value) {
                        [responseString appendFormat: @"%@", member.dictionaryFromItem[@"displayName"]];
                    }
                    
                    if (nextRequest) {
                        [responseString appendString:@"Next request available for more members."];
                    }
                    
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Gets a specific group's owners. Applicable to work accounts with admin rights
- (void)getOwners {
    [self createGroupwithCompletion:^(MSGraphGroup *group, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            [[[[[self.graphClient groups] group:group.entityId] owners] request] getWithCompletion:^(MSCollection *response, MSGraphGroupOwnersCollectionWithReferencesRequest *nextRequest, NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSMutableString *responseString = [[NSMutableString alloc]initWithString:@"List of owners: \n"];
                    
                    for (MSGraphDirectoryObject *owner in response.value) {
                        [responseString appendFormat: @"%@", owner.dictionaryFromItem[@"displayName"]];
                    }
                    
                    if (nextRequest) {
                        [responseString appendString:@"Next request available for more owners."];
                    }
                    
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


// Creates a group in user's account. Applicable to work accounts with admin rights
- (void)createGroup {
    MSGraphGroup *group = [self createGroupObject];
    [[[self.graphClient groups] request] addGroup:group withCompletion:^(MSGraphGroup *response, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            NSString *responseString = [NSString stringWithFormat:@"Group %@ was added", response.displayName];
            [self.delegate snippetSuccess:responseString];
        }
    }];
}


// Creates and updates a group in user's account. Applicable to work accounts with admin rights
- (void)updateGroup {
    [self createGroupwithCompletion:^(MSGraphGroup *group, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            group.displayName = @"Updated Group Display Name";
            [[[[self.graphClient groups] group:group.entityId] request] update:group
                                                             withCompletion:^(MSGraphGroup *response, NSError *error) {
                                                                 if (error) {
                                                                     [self.delegate snippetFailure:error];
                                                                 }
                                                                 else {
                                                                     NSString *responseString = [NSString stringWithFormat:@"Group %@ updated", response.displayName];
                                                                     [self.delegate snippetSuccess:responseString];
                                                                 }
                                                             }];
        }
    }];
}


// Creates and deletes a group in user's account. Applicable to work accounts with admin rights
- (void)deleteGroup {
    [self createGroupwithCompletion:^(MSGraphGroup *group, NSError *error) {
        if (error) {
            [self.delegate snippetFailure:error];
        }
        else {
            [[[[self.graphClient groups] group:group.entityId] request] deleteWithCompletion:^(NSError *error) {
                if (error) {
                    [self.delegate snippetFailure:error];
                }
                else {
                    NSString *responseString = @"Group has been deleted";
                    [self.delegate snippetSuccess:responseString];
                }
            }];
        }
    }];
}


#pragma mark - Helper methods

// Helper method to retrieve the logged in user's display name and email address
- (void)getUserInfo {
    [[[self.graphClient me] request] getWithCompletion:^(MSGraphUser *response, NSError *error) {
        if (error) {
            NSLog(@"Retrieval of user account information failed - %@", error.localizedDescription);
        }
        else {
            self.emailAddress = response.mail;
            self.displayName = response.displayName;
        }
    }];
}


// Helper method to create a new text file
- (void)createFilewithCompletion: (void (^)(MSGraphDriveItem *driveItem, NSError *error))completed{
    NSString *testFile = [[NSString alloc]init];
    NSData *uploadData = [testFile dataUsingEncoding:NSUTF8StringEncoding];
    [[[[[[self.graphClient me] drive] root] itemByPath:@"testSingleFile.text"] contentRequest] uploadFromData:uploadData completion:^(MSGraphDriveItem *response, NSError *error) {
        completed(response, error);
    }];
}


// Helper method that creates and send a sample calendar event to Office 365 - calls - getEventObject
- (void)createSampleEventwithCompletion: (void (^)(MSGraphEvent *event, NSError *error))completed {
    MSGraphEvent *event = [self getEventObject];
    [[[[[self.graphClient me] calendar] events] request] addEvent:event withCompletion:^(MSGraphEvent *response, NSError *error) {
        completed(response, error);
    }];
}


// Helper method that creates and send a sample user group in Office 365 - calls - createGroupObject
- (void)createGroupwithCompletion: (void (^)(MSGraphGroup *group, NSError *error))completed {
    MSGraphGroup *group = [self createGroupObject];
    [[[self.graphClient groups] request] addGroup:group withCompletion:^(MSGraphGroup *response, NSError *error) {
        completed(response, error);
    }];
}


// Helper method to create a sample calendar event
-(MSGraphEvent*) getEventObject {
    NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    
    MSGraphEvent *event = [[MSGraphEvent alloc] init];
    event.Subject = [NSString stringWithFormat:@"New event created on %@", (NSString*)[NSDate date]];
    event.type = [MSGraphEventType singleInstance];
    
    MSGraphDateTimeTimeZone *eventStart = [[MSGraphDateTimeTimeZone alloc]init];
    eventStart.dateTime = [formatter stringFromDate:[NSDate date]];
    eventStart.timeZone = @"Pacific/Honolulu";
    event.start= eventStart;
 
    MSGraphDateTimeTimeZone *eventEnd = [[MSGraphDateTimeTimeZone alloc]init];
    eventEnd.dateTime = [formatter stringFromDate:[[NSDate date]dateByAddingTimeInterval:3600]];
    eventEnd.timeZone = @"Pacific/Honolulu";
    event.end = eventEnd;
    
    NSMutableArray *toAttendees = [[NSMutableArray alloc]init];
    MSGraphAttendee *attendee = [[MSGraphAttendee alloc]init];
    MSGraphEmailAddress *address = (MSGraphEmailAddress*)self.emailAddress;
                               
    attendee.emailAddress = address;
    [toAttendees addObject:attendee];
    
    return event;
}


// Create a sample test message to send to specified user account
- (MSGraphMessage*) getSampleMessage{
    MSGraphMessage *message = [[MSGraphMessage alloc]init];
    MSGraphRecipient *toRecipient = [[MSGraphRecipient alloc]init];
    MSGraphEmailAddress *email = [[MSGraphEmailAddress alloc]init];
    
    email.address = self.emailAddress;
    toRecipient.emailAddress = email;
    
    NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
    [toRecipients addObject:toRecipient];
    
    message.subject = @"Mail received from the Office 365 iOS Microsoft Graph Snippets Sample";
    
    MSGraphItemBody *emailBody = [[MSGraphItemBody alloc]init];
    NSString *htmlContentPath = [[NSBundle mainBundle] pathForResource:@"EmailBody" ofType:@"html"];
    NSString *htmlContentString = [NSString stringWithContentsOfFile:htmlContentPath encoding:NSUTF8StringEncoding error:nil];
    
    emailBody.content = htmlContentString;
    emailBody.contentType = [MSGraphBodyType html];
    message.body = emailBody;
    
    message.toRecipients = toRecipients;
    
    return message;
    
}


// Helper method to greate a sample group object
- (MSGraphGroup*)createGroupObject {
    MSGraphGroup *group = [[MSGraphGroup alloc]init];
    group.displayName = @"New Sample Group";
    group.mailEnabled = true;
    group.mailNickname = @"SampleNickname";
    group.securityEnabled = false;
    group.groupTypes = @[@"Unified"];
  
    return group;
}


@end
