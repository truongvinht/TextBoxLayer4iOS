/*
 
 TextBoxLayer.h
 
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


#ifndef TEXTBOXLAYER_H
#define TEXTBOXLAYER_H

#import "CCAutoTypeLabelBM.h"
#import "cocos2d.h"


typedef enum{
    TextBoxLayoutText,  //show only text
    TextBoxLayoutBattle //show 4 buttons with text label
}TextBoxLayout;

//enum for the button mode
typedef enum{
    TextBoxButtonTopLeft,
    TextBoxButtonTopRight,
    TextBoxButtonBottomLeft,
    TextBoxButtonBottomRight,
    TextBoxButtonCancel
}TextBoxButton;

/** Protocol for calling parent after finish typing*/
@protocol TextBoxLayerDelegate <NSObject>

@optional
/** Method will be called after finished typing chosen text in TextBoxLayoutText
 */
- (void)finishedTyping;

/** Method will be called after finished showing text and user touched within box*/
- (void)didTouchEndOfText;

/** Method to notify after button touched*/
- (void)buttonWithLabel:(TextBoxButton)button;

@end


/** TextBoxLayer to display box with text. It is used during the game for displaying any text and during battle.*/
@interface TextBoxLayer : CCLayer<CCAutoTypeLabelBMDelegate>

//sprite for showing the box
@property(nonatomic,strong) CCSprite *boxBackground;

//delay between the next text page - default = 2 sec
@property(nonatomic,readwrite) float delayToNextPage;

//target responds to the finished typing
@property(nonatomic,weak) id<TextBoxLayerDelegate> delegate;

//default text auto continue to next page;
@property(nonatomic,readwrite) BOOL isAutoContinue;

//allow touch (default = true)
@property(nonatomic,readwrite) BOOL allowTouches;


/** Method to set the box layout
 *
 *  @param layout set the target layout
 */
- (void)setBoxMode:(TextBoxLayout)layout;

/** Method to type target text in text mode
 *
 *  @param text is the text which will be displayed
 *  @param delay is the duration how long the text needs for typing
 *  @param willHide if it is true then the text will hide after finish typing
 */
- (void) typeText:(NSString*)text withDelay:(float) delay withHide:(BOOL)willHide;

/** Method to init and set the button labels
 *
 *  @param tLeft is the label for the top left button
 *  @param tRight is the label for the top right button
 *  @param bLeft is the label for the bottom left button
 *  @param bRight is the label for the bottom right button
 */
- (void)initButtonLabelsForTopLeft:(NSString*)tLeft andTopRight:(NSString*)tRight andBottomLeft:(NSString*)bLeft andBottomRight:(NSString*)bRight;

@end

#endif