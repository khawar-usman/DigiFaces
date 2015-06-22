//
//  SDConstants.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#ifndef DigiFaces_SDConstants_h
#define DigiFaces_SDConstants_h

#define kCurrentPorjectID       @"CurrentProjectId"
#define kAboutMeText            @"AboutMeText"
#define kEmail                  @"Email"

#define kBaseURL @"http://digifacesservices.focusforums.com/"


#define kGetHomeAnnouncements   @"api/Project/GetHomeAnnouncement/{projectId}"
#define kAboutMeUpdate          @"api/Account/UpdateAboutMe"
#define kSendHelpMessage        @"api/System/SendHelpMessage"
#define kModeratorMessage       @"api/Account/SendMessageToModerator/{projectId}/{parentMessageId}"
#define kUpdateAvagar           @"api/Account/UploadUserCustomAvatar"

#endif
