//
//  MyCheckBoxCell.m
//  CustomCheckBoxCellDemo
//
//  Created by Jan Akerman on 09/04/2013.
//  
//  Copyright 2013 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MyCheckBoxCell.h"

#define CHECKBOX_IMAGE_SIZE CGSizeMake(32, 32)

@implementation MyCheckBoxCell {
    UIImageView *_checkBox;
    UIImage *_onImage;
    UIImage *_offImage;
    
    BOOL _checked;
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    if (self = [super initWithReuseIdentifier:identifier]) {
        
        // Load in tick images.
        // Checkbox images courtesy of http://www.visualpharm.com
        _onImage = [UIImage imageNamed:@"checked-box.png"];
        _offImage = [UIImage imageNamed:@"unchecked-box.png"];
        
        // Initialise the checkbox with the off image and the correct size.
        _checkBox = [[UIImageView alloc] initWithImage:_offImage];
        _checkBox.frame = CGRectMake(0, 0, CHECKBOX_IMAGE_SIZE.width, CHECKBOX_IMAGE_SIZE.height);
        _checkBox.userInteractionEnabled = YES;
        [self addSubview:_checkBox];
        
        // Add a tap gesture recognizer that will toggle our check box on and off.
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)];
        [_checkBox addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

// This method is called when the cell is added to the grid. We need to take this opportunity to position our check box where we want it - in the center of our cell.
-(void)layoutSubviews {
    _checkBox.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

// This is the method that will be called by our tap gesture recognizer on our check box.
- (void)toggle {
    
    // Toggle the check box's state.
    [self setChecked:!_checked];

    // If our custom cell has a delegate then we need to notify it that the cell has changed.
    if ([self.myCheckCellDelegate respondsToSelector:@selector(myCheckBoxCellDidChange:)]) [self.myCheckCellDelegate myCheckBoxCellDidChange:self];
}

#pragma -Public Methods

// Set the check box's state according to the given parameter.
-(void)setChecked:(BOOL)checked {
    _checked = checked;
    
    if (_checked) {
        _checkBox.image = _onImage;
    } else {
        _checkBox.image = _offImage;
    }
}

@end
