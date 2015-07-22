//
//  SDConstants.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#ifndef DigiFaces_SDConstants_h
#define DigiFaces_SDConstants_h


typedef enum {
    ThemeTypeDisplayImage,
    ThemeTypeDisplayText,
    ThemeTypeMarkup,
    ThemeTypeImageGallery,
    ThemeTypeNone
}ThemeType;


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
#define kGetNotifications       @"api/Account/GetNotifications/{projectId}"
#define kGetResponses           @"api/Activity/GetResponses/{activityId}"
#define kUpdateComments         @"api/Activity/UpdateComment"
#define kGetAboutMe             @"api/Account/GetAboutMe/{projectId}"
#define kGetActivties           @"api/Project/GetActivities/{projectId}"
#define kUpdateThread           @"api/Activity/UpdateThread"
#define kUpdateDailyDiary       @"api/Project/UpdateDailyDiary/{projectId}"
#define kUpdateTextAreaResponse @"api/Activity/UpdateTextareaResponse"
#define kUpdateGalleryResponse  @"api/Activity/UpdateImageGalleryResponse"

#endif
