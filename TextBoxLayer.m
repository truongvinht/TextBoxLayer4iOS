/*
 
 TextBoxLayer.m
 
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

#import "TextBoxLayer.h"

//import for splitting string into new rows
#import "NSString+Newliner.h"

//import for global constants
#import "Constants.h"

//constants
#define TEXT_SPEED 0.1f
#define TEXT_FADEOUT_SPEED 2.0f
#define TEXT_MAX_ROWS_PER_PAGE 5
#define TEXT_BOTTOM_OFFSET 30.0f

@interface TextBoxLayer ()


//label for displaying text
@property(nonatomic,strong) CCAutoTypeLabelBM *textLabel;

//flag to register the right display mode
@property(nonatomic,readwrite) TextBoxLayout boxLayout;

//flag for hiding text after completion
@property(nonatomic,readwrite) BOOL willHide;

//array to store tempory the text pages
@property(nonatomic,strong) NSMutableArray *textPages;

//store delayTime for multiple pages
@property(nonatomic,readwrite) float delayForTypeAnimation;

//buttons for the menu
@property(nonatomic,strong) CCMenuItem *nextPage;

//grid box for splitting the view into 4 section
@property(nonatomic,strong) CCSprite *gridBox;

//buttons for the battle system
@property(nonatomic,strong) CCLabelBMFont *topLeft;
@property(nonatomic,strong) CCLabelBMFont *topRight;
@property(nonatomic,strong) CCLabelBMFont *bottomLeft;
@property(nonatomic,strong) CCLabelBMFont *bottomRight;

@end

@implementation TextBoxLayer

- (id)init{
    self = [super init];
    
    if (self) {
        
        //init the background box
        self.boxBackground = [CCSprite spriteWithFile:@"textbox.png"];
        [self.boxBackground setAnchorPoint:ccp(0.0f, 0.0f)];
        [self addChild:self.boxBackground z:kBoxLayerTagValue];
        
        self.gridBox = [CCSprite spriteWithFile:@"BoxbuttonGrid.png"];
        [self.gridBox setAnchorPoint:ccp(0.0f, 0.0f)];
        
        //get the screen size
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        if (IS_RETINA) {
            self.textLabel = [CCAutoTypeLabelBM labelWithfntFile:@"TextBoxText@2x.fnt"];
        }else{
            self.textLabel = [CCAutoTypeLabelBM labelWithfntFile:@"TextBoxText.fnt"];
        }
        
        [self.textLabel setPosition:ccp(screenSize.width/2, self.boxBackground.contentSize.height/2)];
        
        //add to current layer
        [self addChild:self.textLabel z:kTextBoxLayerTagValue];
        
        //layer responds to the finished text typing
        self.textLabel.delegate = self;
        
        //default text box layout
        _boxLayout = TextBoxLayoutText;
        _willHide = NO;
        
        //set default delay
        self.delayToNextPage = 2.0f;
        
        //auto continue text
        self.isAutoContinue = YES;
        
        //allow touch
        self.allowTouches = YES;
        self.touchEnabled = YES;
        
        //create the forward button
        NSString *arrowLabel = @"»";
        CCLabelBMFont *buttonLabel = nil;
        
        if (IS_RETINA) {
            buttonLabel = [CCLabelBMFont labelWithString:arrowLabel fntFile:@"TextBoxText@2x.fnt"];
        }else{
            buttonLabel = [CCLabelBMFont labelWithString:arrowLabel fntFile:@"TextBoxText.fnt"];
        }
        
        //init arrow indicator
        self.nextPage = [CCMenuItemLabel itemWithLabel:buttonLabel target:nil selector:nil];
        [self.nextPage setPosition:ccp(screenSize.width-TEXT_BOTTOM_OFFSET, TEXT_BOTTOM_OFFSET)];
        
    }
    return self;
}

#pragma mark - Touch Event Delegates

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //skip touch events as long as text is running
    if (![self.nextPage isRunning]&&self.boxLayout == TextBoxLayoutText) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    //single tap
    if (touch.tapCount == 1) {
        CGPoint tapLocation = [self convertTouchToNodeSpace:touch];
        
        
        switch (self.boxLayout) {
            case TextBoxLayoutText:{ //text box
                
                //check wether tap is within the box
                if (CGRectContainsPoint(self.boxBackground.boundingBox, tapLocation)) {
                    [self removeChild:self.nextPage];
                    [self continueTypeNextPage];
                }else{
                    //ignore touch events outside of the box / maybe use it as cancel event
                }
            }break;
            case TextBoxLayoutBattle:{ //battle box with 4 buttons
                if (CGRectContainsPoint(self.boxBackground.boundingBox, tapLocation)) {
                    //touch within the box
                    
                    //check which area
                    if (tapLocation.y >= self.boxBackground.boundingBox.size.height/2) {
                        //top item
                        if (tapLocation.x <= self.boxBackground.boundingBox.size.width/2) {
                            //left top
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.topLeft) {
                                    [self.delegate buttonWithLabel:TextBoxButtonTopLeft];
                                }
                            }
                        }else{
                            //right top
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.topRight) {
                                    [self.delegate buttonWithLabel:TextBoxButtonTopRight];
                                }
                            }
                        }
                    }else{
                        //bottom item
                        if (tapLocation.x <= self.boxBackground.boundingBox.size.width/2) {
                            //left bottom
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.bottomLeft) {
                                    [self.delegate buttonWithLabel:TextBoxButtonBottomLeft];
                                }
                            }
                        }else{
                            //right bottom
                            if (_delegate) {
                                if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]&&self.bottomRight) {
                                    [self.delegate buttonWithLabel:TextBoxButtonBottomRight];
                                }
                            }
                        }
                    }
                    
                }else{
                    //cancel touch
                    if (_delegate) {
                        if ([self.delegate respondsToSelector:@selector(buttonWithLabel:)]) {
                            [self.delegate buttonWithLabel:TextBoxButtonCancel];
                        }
                    }
                }
            }break;
            default:
                CCLOG(@"TextBoxLayer#Bad Touch, unknown event");
                break;
        }
        
    }else{
        //unknown handling for multiple touches
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //skip touch events as long as text is running
    if (![self.nextPage isRunning]) {
        return;
    }
    //CCLOG(@"Moved");
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //skip touch events as long as text is running
    if (![self.nextPage isRunning]) {
        return;
    }
    //CCLOG(@"Canceled");
}

#pragma mark - CCAutoTypeLabelBM Delegate

- (void)runNextItem{
    if ([self.textPages count]>0) {
        NSString *text = [[self.textPages objectAtIndex: 0] copy];
        [self.textPages removeObjectAtIndex:0];
        
        [self.textLabel typeText:text withDelay:self.delayForTypeAnimation];
    }else{
        
        //perform finished into the call object
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(finishedTyping)]) {
                [self.delegate performSelector:@selector(finishedTyping) withObject:nil];
            }
        }
    }
}

-(void)fadeInAndReplace{
    
    //write empty string
    [self.textLabel setString:@""];
    
    //fade in the text
    [self.textLabel runAction:[CCFadeIn actionWithDuration:0.0f]];
    
    if (self.textPages) {
        [self performSelector:@selector(runNextItem) withObject:nil afterDelay:self.delayToNextPage];
    }
}

- (void)continueTypeNextPage{
    
    if (_willHide) {
        CCCallFunc *fadeInAndReplace = [CCCallFunc actionWithTarget:self selector:@selector(fadeInAndReplace)];
        
        CCSequence *sequence = [CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCFadeOut actionWithDuration:TEXT_FADEOUT_SPEED],fadeInAndReplace, nil];
        [self.textLabel runAction:sequence];
    }else{
        if (self.textPages) {
            [self performSelector:@selector(runNextItem) withObject:nil afterDelay:self.delayToNextPage];
        }else{
            
            //ignore this block if battle mode
            if (self.boxLayout == TextBoxLayoutText) {
                //no more pages available
                
                //perform finished into the call object
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(finishedTyping)]) {
                        [self.delegate performSelector:@selector(finishedTyping) withObject:nil];
                    }
                }
            }
        }
    }
}

- (void)typingFinished:(CCAutoTypeLabelBM *)sender{
    
    //user needs to tap for continue
    if (!self.isAutoContinue) {
        //show next button
        [self addChild:self.nextPage z:kTextBoxButtonLayerTagValue];
        return;
    }
    
    //continue type next page
    [self continueTypeNextPage];
}

#pragma mark - Public Method implementations

- (void)setBoxMode:(TextBoxLayout)layout{
    switch (layout) {
        case TextBoxLayoutText:
            if (layout!=self.boxLayout) {
                
                //any item is available, so remove them
                if (self.topLeft) {
                    [self removeChild:self.topLeft];
                }
                
                if (self.topRight) {
                    [self removeChild:self.topRight];
                }
                
                if (self.bottomLeft) {
                    [self removeChild:self.bottomLeft];
                }
                
                if (self.bottomRight) {
                    [self removeChild:self.bottomRight];
                }
                [self removeChild:self.gridBox];
            }
            break;
        case TextBoxLayoutBattle:
            
            if (layout!=self.boxLayout) {
                //hide any string
                [self.textLabel setString:@""];
                [self addChild:self.gridBox z:kBoxLayerGridTagValue];
                
                //add all buttons
                [self addChild:self.topLeft z:kTextBoxButtonLayerTagValue tag:kTextBoxButtonLayerTagValue];
                [self addChild:self.topRight z:kTextBoxButtonLayerTagValue tag:kTextBoxButtonLayerTagValue];
                [self addChild:self.bottomLeft z:kTextBoxButtonLayerTagValue tag:kTextBoxButtonLayerTagValue];
                [self addChild:self.bottomRight z:kTextBoxButtonLayerTagValue tag:kTextBoxButtonLayerTagValue];
            }
            break;
        default:
            break;
    }
    self.boxLayout = layout;
}

- (void) typeText:(NSString*)text withDelay:(float) delay withHide:(BOOL)willHide{
    
    //update hide flag
    self.willHide = willHide;
    
    //convert string to string with line breaks to show only in visible part of the display
    NSString *textWithLineBreaks =[text stringSplitByNumOfSymbols:iMonster_TEXTBOX_LENGTH];
    
    //check rows
    NSInteger numberOfRows = [textWithLineBreaks numberOfLines];
    
    if (numberOfRows > TEXT_MAX_ROWS_PER_PAGE) {
        //too many rows, try to split into next page
        self.textPages = [NSMutableArray arrayWithArray:[textWithLineBreaks componentsSeparatedByString:@"\n" withBundleSize:TEXT_MAX_ROWS_PER_PAGE]];
        
        self.delayForTypeAnimation = delay;
        [self runNextItem];
    }else{
        //text is short enough
        self.textPages = nil;
        
        //start typing text
        [self.textLabel typeText:textWithLineBreaks withDelay:delay];
    }
}

- (void)initButtonLabelsForTopLeft:(NSString*)tLeft andTopRight:(NSString*)tRight andBottomLeft:(NSString*)bLeft andBottomRight:(NSString*)bRight{
    
    //get the font for the text in the box
    NSString *fntFile = nil;
    
    if (IS_RETINA) {
        fntFile = @"TextBoxText@2x.fnt";
    }else{
        fntFile = @"TextBoxText.fnt";
    }
    
    const int fixedInsets = 9;
    
    //get box size to fix the position
    CGSize boxSize = self.boxBackground.boundingBox.size;
    
    //top left button
    if (tLeft) {
        self.topLeft = [CCLabelBMFont labelWithString:[tLeft stringSplitByNumOfSymbols:iMonster_TEXTBOX_BATTLE_LENGTH] fntFile:fntFile];
        [self.topLeft setAlignment:kCCTextAlignmentCenter];
        [self.topLeft setPosition:ccp(boxSize.width*1/4, boxSize.height*3/4-fixedInsets)];
    }
    
    //top right button
    if (tRight) {
        self.topRight = [CCLabelBMFont labelWithString:[tRight stringSplitByNumOfSymbols:iMonster_TEXTBOX_BATTLE_LENGTH] fntFile:fntFile];
        [self.topRight setAlignment:kCCTextAlignmentCenter];
        [self.topRight setPosition:ccp(boxSize.width*3/4, boxSize.height*3/4-fixedInsets)];
    }
    
    //bottom left button
    if (bLeft) {
        self.bottomLeft = [CCLabelBMFont labelWithString:[bLeft stringSplitByNumOfSymbols:iMonster_TEXTBOX_BATTLE_LENGTH] fntFile:fntFile];
        [self.bottomLeft setAlignment:kCCTextAlignmentCenter];
        [self.bottomLeft setPosition:ccp(boxSize.width*1/4, boxSize.height*1/4+fixedInsets)];
    }
    
    //bottom right button
    if (bRight) {
        self.bottomRight = [CCLabelBMFont labelWithString:[bRight stringSplitByNumOfSymbols:iMonster_TEXTBOX_BATTLE_LENGTH] fntFile:fntFile];
        [self.bottomRight setAlignment:kCCTextAlignmentCenter];
        [self.bottomRight setPosition:ccp(boxSize.width*3/4, boxSize.height*1/4+fixedInsets)];
    }
}

@end
