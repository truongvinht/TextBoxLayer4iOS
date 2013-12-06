TextBoxLayer
==============

A cocos2d iOS class to get auto-typing box and Battle box for RPG-Games.

Require: cocos2d for iOS & CCAutoTypeLabelBM & iOS 6 or higher

#Example

Typing:
```Objective-C
TextBoxLayer *box = [TextBoxLayer node];
box.delegate = self;
box.isAutoContinue = YES;
[self addChild:self.box];
[self.box typeText:@"OMG, the class is awesome!" withDelay:0.1f withHide:NO];
```
Battle Mode with 4 buttons:
```Objective-C
TextBoxLayer *box = [TextBoxLayer node];
box.delegate = self;
box.isAutoContinue = YES;
[self addChild:self.box];
[box initButtonLabelsForTopLeft:@"Fight" andTopRight:@"Items" andBottomLeft:@"Switch" andBottomRight:@"Escape"];
[box setBoxMode:TextBoxLayoutBattle];
```

To handle touch events in battle mode you need to implement the protocol TextBoxLayerDelegate and add
```Objective-C
- (void)buttonWithLabel:(TextBoxButton)button{
    //any button pressed
}
```

#License
MIT License (MIT)

