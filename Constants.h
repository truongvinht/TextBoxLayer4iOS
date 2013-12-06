/*
 
 Constants.h
 This Constants file is only an example
 
 Copyright (c) 2013 Truong Vinh Tran
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#ifndef iMonster_Constants_h
#define iMonster_Constants_h

//tags for the scene
#define kMainMenuTagValue 10
#define kSettingMenuTagValue 11
#define kSceneMenuTagValue 20
#define kBoxLayerTagValue 30
#define kBoxLayerGridTagValue 31
#define kBoxBGLayerTagValue 32
#define kTextBoxLayerTagValue 33
#define kTextBoxButtonLayerTagValue 34

//length of the text
#define iMonster_TEXT_LENGTH 22
#define iMonster_TEXTBOX_LENGTH 32
#define iMonster_TEXTBOX_BATTLE_LENGTH 12

//flag wether it is iphone 5 screen
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//check wether is retina
#define IS_RETINA [[UIScreen mainScreen] scale] > 1.0f

//enum for every scene
typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kSettingScene=2,
    kCreditsScene=3,
    kIntroScene=4,
    kFightCompleteScene=5
}SceneTypes;

#endif
