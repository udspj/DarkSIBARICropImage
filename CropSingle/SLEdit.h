//
//  SLEdit.h
//  SPL
//
//  Created by KIM on 13/01/24.
//
//

#ifndef SPL_SLEdit_h
#define SPL_SLEdit_h

enum SIGN_NAVAGATION_BUTTON
{
    NAVAGATION_BUTTON_IMAGEPICKER = 1,
    NAVAGATION_BUTTON_SHARE,
};

enum {
	TAB_BUTTON_ARTFILTER = 0x1001,
	TAB_BUTTON_PHOTOSTORY,
	TAB_BUTTON_SIGN,
	TAB_FOOTER_BASE,
    TAB_BUTTON_CROP,
    TAB_BUTTON_SHADOW,
};

enum {
    STAMP_SELECT_NO = 0,
	STAMP_SELECT_HAND_WRITING,
    STAMP_SELECT_INKAN,
    STAMP_SELECT_OLYSTAMP,
};

enum PICKER_TYPE
{
    PICKER_TYPE_START = 1,
    PICKER_TYPE_INKAN_EDIT_CAMERAROLL,
    PICKER_TYPE_INKAN_EDIT_CAMERA,
    PICKER_TYPE_REOPEN,
};


enum SIGN_ALERT
{
    ALERT_PHOTOSTORY_TAB = 1,
    ALERT_PHOTOSTORY_TAB_NOT_SUPPORT_FORMAT,
    ALERT_IKAN_REOPEN,
};

enum STAMP_SIGN_BORDER_VIEW_EDIT_BUTTON_TYPE
{
    STAMP_SIGN_BORDER_TOOL_OPEN_BUTTON_TYPE_HANDWRITING = 1,
    STAMP_SIGN_BORDER_TOOL_OPEN_BUTTON_TYPE_IMAGE_SIGN = 2,
    STAMP_SIGN_BORDER_TOOL_OPEN_BUTTON_TYPE_LOGO = 3,
};

enum EDIT_ACTION_SHEET_TYPE
{
    EDIT_ACTION_SHEET_SHARE = 1,
    EDIT_ACTION_SHEET_IMAGE_SIGN = 3,
};

#define STAMP_COUNT             9     // VER 2.1
#define STATUS_BAR_HEIGHT       20

#define PHOTOSTORY_VIEW_TAG     9999

#define ART_FILTER_THUMBNAIL_SELECTED_FRAME_TAG		(-1001)	//缩略图选择框
#define ART_FILTER_THUMBNAIL_UNSELECTED_FRAME_TAG	(-1002)	//缩略图非选择框
#define ART_FILTER_THUMBNAIL_LABEL_TAG				(-2001)	//艺术滤波器名的标签
#define ART_FILTER_THUMBNAIL_TAG					(-3001)	//艺术滤波器的效果，花了缩略图
#define ART_FILTER_PROGRESSING_LABEL_TAG			(-4001)	//艺术滤波器保存中的标签

#define ART_FILTER_MAXIMUM_PIXEL				(5000000)

#define TAG_COLOR_SELECT_SCROLLVIEW_ITEM  8888

static const int	_thumbsPerRowForPad = 6;	//
static const int	_thumbLabelHeight = 11;		//
static const int	_thumbOffset = 5;			//
static const int	_thumbTopMargin = 5;
static const int	_thumbRim = 3;				//
static const int	_thumbShadowOffset= 10;		//

#define kThumbSizeMultiple  0.92

static const int kStampWidth = 70 * kThumbSizeMultiple;
static const float kStampSpace = 10;
static const int kStampWidthiPad = 110 * kThumbSizeMultiple;
static const float kStampSpaceiPad = 12;


#define kNavigationBarLandscapeHeight   32
#define kNavigationBarHeight            44

#define kStamp_Border_Button_Size       24
#define kStamp_Border_View_Size         100
#define kStamp_Border_View_Size_iPad    200

#define kPinchResizeOffset              3.0f
#define kPinchResizeOffset_iPad         3.0f

#define SIGN_STAMP_STAMP1_DELETE        0
#define SIGN_STAMP_STAMP2_HANDWRITING   11
#define SIGN_STAMP_STAMP3_INKAN         21
#define SIGN_STAMP_STAMP4_TEXT          22
#define SIGN_STAMP_LOGO1                31
#define SIGN_STAMP_LOGO2                41
#define SIGN_STAMP_LOGO3                51
#define SIGN_STAMP_LOGO4                61
#define SIGN_STAMP_LOGO5                71

#define SIGN_STAMP_SCROLL_BTN_TAG       100
#define SIGN_STAMP_BTN_LABEL_TAG        110

#define PHOTOSTORY_SCROLL_DELETE             0
#define PHOTOSTORY_SCROLL_BTN_TAG            555
#define PHOTOSTORY_SCROLL_BTN_LABEL_TAG      560


#define MAIN_BALLOON_BACKGROUND 1010
#define MAIN_BALLOON_LEFT       1011
#define MAIN_BALLOON_CENTER     1012
#define MAIN_BALLOON_RIGHT      1013

#define kStampBorderEditButtonType  @"StampBorderEditButtonType"

// 
#define TEXT_SIGN_SLIDER_TAG                777
#define kTextImageSize                      1024
#define kTextImageThumbnailSize             320
#define kThumbnailWhiteFrameSize            3.0f
#define kSaveShadowSize                     25.0f
#define kTextSaveSizeRate                   0.9f//0.85f
#define kTextSaveSizeRate2                  0.9f//0.80f
#define kTextSaveSizeRate2iOS7              0.75f
#define kTextSaveSizeRate2iOS7Snell         0.70f

#define kTextSaveSizeRate2iOS7DIN           0.68f
#define kTextSaveSizeRate2iOS7Marion        0.68f

#define kTextSaveSizeRate2iOS7Chalkduster   0.75f

#define kTextSaveSizeRate2iOS7Didot         0.82f
#define kTextSaveSizeRate2iOS7Euphemia      0.85f
#define kTextSaveSizeRate2iOS7Georgia       0.85f
#define kTextSaveSizeRate2iOS7GillSans      0.85f
#define kTextSaveSizeRate2iOS7TimesNewRoman 0.86f
#define kTextDrawOffsetiOS7                 0.50f

#define kTextSaveWidthOffSet        200.0f

#define kRestrictedLength           30
#define KFontSize                   15.0f/17.0f
#define kFontShadowOpacity          0.7
#define kNoFontType                 @"-----"

//--------------------------------------
// SIGN LOGO RESOURCE FILE NAME
//--------------------------------------
#define kSign_ArtFilter_Select_Thumbnail_Filename   @"00-21_thumbnail_frame"
#define kSign_Stamp_Select_Thumbnail_Filename       @"00-21_thumbnail_frame"
#define kSign_Stamp_Delete_Thumbnail_Filename       @"IE_thumb_diagonal"// DELETE

#define kSign_Stamp_Select_Thumbnail_color           @"07-33_text_color_frame"
#define kSign_Logo_11_Thumbnail_Filename    @"IE_thumb_new_handwriting" // HANDWRITING
#define kSign_Logo_21_Thumbnail_Filename    @"IE_thumb_new_image"       // IMAGE SIGN
#define kSign_Logo_22_Thumbnail_Filename    @"IE_thumb_new_text_sign"   // TEXT SIGN

// SIGN LOGO THUMBNAIL (TAG START FROM 31)
#define kSign_Logo_31_Thumbnail_Filename    @"07-02_logo_omd1_white"     // WHITE ALPHA
#define kSign_Logo_32_Thumbnail_Filename    @"07-02_logo_omd1_white_thin"   // WHITE
#define kSign_Logo_33_Thumbnail_Filename    @"07-02_logo_omd1_black"
#define kSign_Logo_34_Thumbnail_Filename    @"07-02_logo_omd1_black_thin"



#define kSign_Logo_41_Thumbnail_Filename    @"07-03_logo_omd2_white"
#define kSign_Logo_44_Thumbnail_Filename    @"07-03_logo_omd2_black_thin"
#define kSign_Logo_43_Thumbnail_Filename    @"07-03_logo_omd2_black"
#define kSign_Logo_42_Thumbnail_Filename    @"07-03_logo_omd2_white_thin"


#define kSign_Logo_51_Thumbnail_Filename    @"07-04_logo_pen_white"
#define kSign_Logo_54_Thumbnail_Filename    @"07-04_logo_pen_black_thin"
#define kSign_Logo_53_Thumbnail_Filename    @"07-04_logo_pen_black"
#define kSign_Logo_52_Thumbnail_Filename    @"07-04_logo_pen_white_thin"



#define kSign_Logo_61_Thumbnail_Filename    @"07-05_logo_stylus_white"
#define kSign_Logo_64_Thumbnail_Filename    @"07-05_logo_stylus_black_thin"
#define kSign_Logo_63_Thumbnail_Filename    @"07-05_logo_stylus_black"
#define kSign_Logo_62_Thumbnail_Filename    @"07-05_logo_stylus_white_thin"


#define kSign_Logo_71_Thumbnail_Filename    @"07-06_logo_esystem_white"
#define kSign_Logo_74_Thumbnail_Filename    @"07-06_logo_esystem_black_thin"
#define kSign_Logo_73_Thumbnail_Filename    @"07-06_logo_esystem_black"
#define kSign_Logo_72_Thumbnail_Filename    @"07-06_logo_esystem_white_thin"

#define kSign_Logo_81_Thumbnail_Filename    @"07-07_logo_tough_white"
#define kSign_Logo_84_Thumbnail_Filename    @"07-07_logo_tough_black_thin"
#define kSign_Logo_83_Thumbnail_Filename    @"07-07_logo_tough_black"
#define kSign_Logo_82_Thumbnail_Filename    @"07-07_logo_tough_white_thin"

// SIGN LOGO SAVE (TAG START FROM 31)
#define kSign_Logo_31_Original_FileName    @"07-82_logo_omd1_white"
#define kSign_Logo_34_Original_FileName    @"07-82_logo_omd1_black_thin"
#define kSign_Logo_33_Original_FileName    @"07-82_logo_omd1_black"
#define kSign_Logo_32_Original_FileName    @"07-82_logo_omd1_white_thin"


#define kSign_Logo_41_Original_FileName    @"07-83_logo_omd2_white"
#define kSign_Logo_44_Original_FileName    @"07-83_logo_omd2_black_thin"
#define kSign_Logo_43_Original_FileName    @"07-83_logo_omd2_black"
#define kSign_Logo_42_Original_FileName    @"07-83_logo_omd2_white_thin"


#define kSign_Logo_51_Original_FileName    @"07-84_logo_pen_white"
#define kSign_Logo_54_Original_FileName    @"07-84_logo_pen_black_thin"
#define kSign_Logo_53_Original_FileName    @"07-84_logo_pen_black"
#define kSign_Logo_52_Original_FileName    @"07-84_logo_pen_white_thin"

#define kSign_Logo_61_Original_FileName    @"07-85_logo_stylus_white"
#define kSign_Logo_64_Original_FileName    @"07-85_logo_stylus_black_thin"
#define kSign_Logo_63_Original_FileName    @"07-85_logo_stylus_black"
#define kSign_Logo_62_Original_FileName    @"07-85_logo_stylus_white_thin"

#define kSign_Logo_71_Original_FileName    @"07-86_logo_esystem_white"
#define kSign_Logo_74_Original_FileName    @"07-86_logo_esystem_black_thin"
#define kSign_Logo_73_Original_FileName    @"07-86_logo_esystem_black"
#define kSign_Logo_72_Original_FileName    @"07-86_logo_esystem_white_thin"

#define kSign_Logo_81_Original_FileName    @"07-87_logo_tough_white"
#define kSign_Logo_84_Original_FileName    @"07-87_logo_tough_black_thin"
#define kSign_Logo_83_Original_FileName    @"07-87_logo_tough_black"
#define kSign_Logo_82_Original_FileName    @"07-87_logo_tough_white_thin"

#define kEdit_btn_art               @"00-12_artfilter"
#define kEdit_btn_art_selected      @"00-12_artfilter_selected"

#define kEdit_btn_cropPicture       @"00-11_trimming"
#define kEdit_btn_cropPicture_select @"00-11_trimming_selected"

#define kEdit_btn_story             @"00-13_colorcreator"
#define kEdit_btn_story_selected    @"00-13_colorcreator_selected"

#define kEdit_btn_sign              @"00-15_sign"
#define kEdit_btn_sign_selected     @"00-15_sign_selected"

#define kEdit_btn_shadow            @"00-14_highlightshadow"
#define kEdit_btn_shadow_selected     @"00-14_highlightshadow_selected"

#define kEdit_btn_setting              @"00-16_settings"
#define kEdit_btn_setting_selected      @"00-16_settings_selected"


#define kArtFiter_Common_btn_selected    @"03-31_effect_off_selected"
#define kArtFiter_common_btn             @"03-31_effect_off"
#define kArtFiter_effect_softfocus_selected    @"03-32_effect_softfocus_selected"
#define kArtFilter_effect_softfocus            @"03-32_effect_softfocus"
#define kArtFilter_effect_pinhole_selected     @"03-33_effect_pinhole_selected"
#define kArtFilter_effect_pinhole              @"03-33_effect_pinhole"
#define kArtFilter_effect_whiteedge_selected   @"03-34_effect_whiteedge_selected"
#define kArtFilter_effect_whiteedge            @"03-34_effect_whiteedge"
#define kArtFilter_effect_Frame_select         @"03-35_effect_frame_selected"
#define kArtFilter_effect_Frame                @"03-35_effect_frame"
#define kArtFilter_effect_topbottomblur_selected  @"03-36_effect_topbottomblur_selected"
#define kArtFilter_effect_topbottomblur        @"03-36_effect_topbottomblur"
#define kArtFilter_effect_leftright_selected   @"03-37_effect_leftrightblur_selected"
#define kArtFilter_effect_leftright            @"03-37_effect_leftrightblur"
#define kArtFilter_effect_topbottom_selected   @"03-38_effect_topbottomshade_selected"
#define kArtFilter_effect_topbottom            @"03-38_effect_topbottomshade"
#define kArtFilter_effect_leftrightshade_selected   @"03-39_effect_leftrightshade_selected"
#define kArtFilter_effect_leftrightshade       @"03-39_effect_leftrightshade"

#define kArtFilter_bw_neutral_selected         @"03-51_bwfilter_neutral_selected"
#define kArtFilter_bw_neutral                  @"03-51_bwfilter_neutral"
#define kArtFilter_bw_yellow_selected          @"03-52_bwfilter_yellow_selected"
#define kArtFilter_bw_yellow                   @"03-52_bwfilter_yellow"
#define kArtFilter_bw_orange_selected          @"03-53_bwfilter_orange_selected"
#define kArtFilter_bw_orange                   @"03-53_bwfilter_orange"
#define kArtFilter_bw_red_selected             @"03-54_bwfilter_red_selected"
#define kArtFilter_bw_red                      @"03-54_bwfilter_red"
#define kArtFilter_bw_green_selected           @"03-55_bwfilter_green_selected"
#define kArtFilter_bw_green                    @"03-55_bwfilter_green"

#define kArtFilter_tone_neutral_selected       @"03-61_picttone_neutral_selected"
#define kArtFilter_tone_neutral                @"03-61_picttone_neutral"
#define kArtFilter_tone_sepia_selected         @"03-62_picttone_sepia_selected"
#define kArtFilter_tone_sepia                  @"03-62_picttone_sepia"
#define kArtFilter_tone_blue_selected          @"03-63_picttone_blue_selected"
#define kArtFilter_tone_blue                   @"03-63_picttone_blue"
#define kArtFilter_tone_purple_selected        @"03-64_picttone_purple_selected"
#define kArtFilter_tone_purple                 @"03-64_picttone_purple"
#define kArtFilter_tone_green_select           @"03-65_picttone_green_selected"
#define kArtFilter_tone_green                  @"03-65_picttone_green"

#define kArtFilterSpecialBtn_selected           @"03-26_btn_selected"
#define kArtFilterSpecialBtn                    @"03-26_btn"
#define kArtFilterSpecialTopBtn_selected        @"03-11_bwfilter_neutral_selected"
#define kArtFilterSpecialTopBtn                 @"03-11_bwfilter_neutral"

#define kArtFilterSpecial_state_neutral_selected @"03-11_bwfilter_neutral_selected"
#define kArtFilterSpecial_state_yellow_selected  @"03-12_bwfilter_yellow_selected"
#define kArtFilterSpecial_state_orange_selected  @"03-13_bwfilter_orange_selected"
#define kArtFilterSpecial_state_red_selected     @"03-14_bwfilter_red_selected"
#define kArtFilterSpecial_state_green_selected   @"03-15_bwfilter_green_selected"

#define kArtFilterSpecial_state_neutraltone_selected @"03-21_picttone_neutral_selected"
#define kArtFilterSpecial_state_sepiatone_selected   @"03-22_picttone_sepia_selected"
#define kArtFilterSpecial_state_bluetone_selected    @"03-23_picttone_blue_selected"
#define kArtFilterSpecial_state_purpletone_selected  @"03-24_picttone_purple_selected"
#define kArtFilterSpecial_state_greentone_selected   @"03-25_picttone_green_selected"

#endif
