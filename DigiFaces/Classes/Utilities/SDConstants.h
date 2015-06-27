//
//  SDConstants.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#ifndef DigiFaces_SDConstants_h
#define DigiFaces_SDConstants_h


#define kS3AccessKey            @"AKIAIG2CIAZWZIA6L7YA"
#define kS3AccessSecret         @"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"
#define kS3Bucket               @"media.digifaces.com"

#define kCurrentPorjectID       @"CurrentProjectId"
#define kAboutMeText            @"AboutMeText"
#define kEmail                  @"Email"
#define kImageURL               @"ImageURL"

#define kBaseURL @"http://digifacesservices.focusforums.com/"

#define kGetHomeAnnouncements   @"api/Project/GetHomeAnnouncement/{projectId}"
#define kAboutMeUpdate          @"api/Account/UpdateAboutMe"
#define kSendHelpMessage        @"api/System/SendHelpMessage"
#define kModeratorMessage       @"api/Account/SendMessageToModerator/{projectId}/{parentMessageId}"
#define kUpdateAvagar           @"api/Account/UploadUserCustomAvatar"
#define kAboutDigifaces         @"api/System/GetAbout/{languageCode}"
#define kUploadCustomAvatar     @"api/Account/UploadUserCustomAvatar"
#define kDailyDiaryInfo         @"api/Project/GetDailyDiary/{diaryId}"

#endif
