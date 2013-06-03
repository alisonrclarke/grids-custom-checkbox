//
//  ViewController.m
//  DataGridCustomCheckBoxDemo
//
//  Created by Jan Akerman on 10/04/2013.
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

#import "ViewController.h"

#import <ShinobiGrids/ShinobiDataGrid.h>
#import <ShinobiGrids/SDataGridDataSourceHelper.h>
#import <ShinobiGrids/SDataGridCoord.h>
#import <ShinobiGrids/SDataGridRow.h>
#import <ShinobiGrids/SDataGridCellStyle.h>
#import <ShinobiGrids/SDataGridColumn.h>
#import "Student.h"
#import "MyCheckBoxCell.h"

@interface ViewController () <SDataGridDataSourceHelperDelegate, MyCheckBoxDelegate> {
    ShinobiDataGrid *_grid;
    SDataGridDataSourceHelper *_dataSourceHelper;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create our grid.
    _grid = [[ShinobiDataGrid alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80)];
    [self.view addSubview:_grid];
    
    _grid.licenseKey = @""; // TODO: add your trial licence key here!
    
    // Style grid.
    _grid.backgroundColor = [UIColor whiteColor];
    UIColor *backgroundColor = [UIColor darkGrayColor];
    UIColor *textColor = [UIColor whiteColor];
    _grid.defaultCellStyleForHeaderRow = [[SDataGridCellStyle alloc] initWithBackgroundColor:backgroundColor withTextColor:textColor withTextAlignment:NSTextAlignmentCenter withVerticalTextAlignment:UIControlContentVerticalAlignmentCenter withFont:nil];

    // Disable grid events (select & edit).
    _grid.singleTapEventMask = SDataGridEventNone;
    _grid.doubleTapEventMask = SDataGridEventNone;

    // Disable row/column dragging.
    _grid.canReorderRows = NO;

    // Add our three columns.
    SDataGridColumn *nameColumn = [[SDataGridColumn alloc] initWithTitle:@"Name" forProperty:@"name"];
    nameColumn.width = @255;
    [_grid addColumn:nameColumn];

    SDataGridColumn *creditColumn = [[SDataGridColumn alloc] initWithTitle:@"Credits" forProperty:@"credits"];
    creditColumn.width = @255;
    [_grid addColumn:creditColumn];

    SDataGridColumn *tickColumn = [[SDataGridColumn alloc] initWithTitle:@"Can Graduate" forProperty:@"canGraduate" cellType:[MyCheckBoxCell class] headerCellType:nil];
    tickColumn.width = @255;
    [_grid addColumn:tickColumn];
    
    
    // Create our data-source helper and give it some mock students.
    _dataSourceHelper = [[SDataGridDataSourceHelper alloc] initWithDataGrid:_grid];
    _dataSourceHelper.delegate = self;
    _dataSourceHelper.data = [self createMockStudentArray];
}

// This method gives us a chance to change the style about to be applied to a cell before it is actually applied to the cell.
-(void)shinobiDataGrid:(ShinobiDataGrid *)grid alterStyle:(SDataGridCellStyle *)styleToApply beforeApplyingToCellAtCoordinate:(SDataGridCoord *)coordinate {
    Student *student = _dataSourceHelper.data[coordinate.row.rowIndex];
    
    // Style the cell red or green depending on whether the student is allowed to graduate or not.
    if (student.canGraduate) {
        styleToApply.backgroundColor = [UIColor colorWithRed:225./255. green:252./255. blue:225./255. alpha:1];
    } else {
        styleToApply.backgroundColor = [UIColor colorWithRed:252./255. green:225./255. blue:225./255. alpha:1];
    }
}

// This method gives us a chance to do cell population manually, which we need for our custom cells.
// Returning YES tells our data-source helper that we have populated the cell and it doesn't need to worry about it.
-(BOOL)dataGridDataSourceHelper:(SDataGridDataSourceHelper *)helper populateCell:(SDataGridCell *)cell withValue:(id)value forProperty:(NSString *)propertyKey sourceObject:(id)object {
    
    // I know the objects associated with my grid are of type student so it is safe to cast it.
    Student *student = (Student *)object;
    
    // I only want to populate the third column (our checkbox column) manually.
    if ([propertyKey isEqualToString:@"canGraduate"]) {
        
        MyCheckBoxCell *checkCell = (MyCheckBoxCell *)cell;
        
        // As the datasource-helper handles the cell reuse we need to set the check box's delegate here.
        checkCell.myCheckCellDelegate = self;
        
        // Make the checkbox show whether the student can graduate.
        checkCell.checked = student.canGraduate;
        
        // Return YES to tell the data-source helper that we have manually populated this cell.
        return YES;
    }
    
    // For all other cell types (other than our custom checkbox) we want to return NO to let the data-source helper know it needs to handle the cell population.
    return NO;
}

// This is the delegate we created for our checkbox, letting us know when its state has changed.
-(void)myCheckBoxCellDidChange:(MyCheckBoxCell *)checkBox {
    
    // Get the student object that corresponds to the checkbox's row and update whether he can graduate or not.
    Student *student = _dataSourceHelper.data[checkBox.coordinate.row.rowIndex];
    student.canGraduate = [checkBox checked];
    
    // Reload the row so that the change in row style can take place.
    [_grid reloadRows:@[checkBox.coordinate.row]];
}

// This method creates an array of mock students for this example.
- (NSArray *)createMockStudentArray {
    return @[[[Student alloc] initWithName:@"Bill"      andCredits:@40  canGraduate:NO],
             [[Student alloc] initWithName:@"Rob"       andCredits:@80  canGraduate:YES],
             [[Student alloc] initWithName:@"James"     andCredits:@80  canGraduate:YES],
             [[Student alloc] initWithName:@"Harry"     andCredits:@30  canGraduate:NO],
             [[Student alloc] initWithName:@"Sue"       andCredits:@90  canGraduate:YES],
             [[Student alloc] initWithName:@"Rachel"    andCredits:@120 canGraduate:YES],
             [[Student alloc] initWithName:@"Annie"     andCredits:@70  canGraduate:NO],
             [[Student alloc] initWithName:@"Daniel"    andCredits:@80  canGraduate:YES],
             [[Student alloc] initWithName:@"Harry"     andCredits:@80  canGraduate:YES],
             [[Student alloc] initWithName:@"Tom"       andCredits:@90  canGraduate:YES],
             [[Student alloc] initWithName:@"Fred"      andCredits:@40  canGraduate:NO],
             [[Student alloc] initWithName:@"Andy"      andCredits:@10  canGraduate:NO],
             [[Student alloc] initWithName:@"Sarah"     andCredits:@60  canGraduate:NO],
             [[Student alloc] initWithName:@"Elliot"    andCredits:@80  canGraduate:YES],
             [[Student alloc] initWithName:@"Babra"     andCredits:@75  canGraduate:YES],
             [[Student alloc] initWithName:@"Sam"       andCredits:@110 canGraduate:YES],
             [[Student alloc] initWithName:@"William"   andCredits:@120 canGraduate:YES],
             [[Student alloc] initWithName:@"Helen"     andCredits:@90  canGraduate:YES],
             [[Student alloc] initWithName:@"Jim"       andCredits:@100 canGraduate:YES],
             [[Student alloc] initWithName:@"Oleg"      andCredits:@90  canGraduate:YES],
             [[Student alloc] initWithName:@"Andrew"    andCredits:@110 canGraduate:YES]];
}

@end
