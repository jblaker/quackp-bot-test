#import "FocusGuideManager.h"

@implementation FocusGuideManager

- (void)setupFocusGuidesForViews:(NSArray<UIView *> *)views {
    // Sort views by their x and y positions
    NSArray<UIView *> *sortedViews = [views sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        if (view1.frame.origin.y < view2.frame.origin.y) {
            return NSOrderedAscending;
        } else if (view1.frame.origin.y > view2.frame.origin.y) {
            return NSOrderedDescending;
        } else {
            if (view1.frame.origin.x < view2.frame.origin.x) {
                return NSOrderedAscending;
            } else if (view1.frame.origin.x > view2.frame.origin.x) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }];
    
    for (UIView *view in sortedViews) {
        // Create a focus guide
        UIFocusGuide *focusGuide = [[UIFocusGuide alloc] init];
        [view.superview addLayoutGuide:focusGuide];
        
        // Set the focus guide to the same size as the view
        [focusGuide.widthAnchor constraintEqualToAnchor:view.widthAnchor].active = YES;
        [focusGuide.heightAnchor constraintEqualToAnchor:view.heightAnchor].active = YES;
        
        // Attach the focus guide to the view
        [focusGuide.topAnchor constraintEqualToAnchor:view.topAnchor].active = YES;
        [focusGuide.leftAnchor constraintEqualToAnchor:view.leftAnchor].active = YES;
        
        // Find adjacent views and set preferredFocusEnvironments
        for (UIView *adjacentView in sortedViews) {
            if (adjacentView != view) {
                // Check view above
                if (CGRectGetMaxY(adjacentView.frame) <= view.frame.origin.y) {
                    focusGuide.preferredFocusEnvironments = @[adjacentView];
                    [focusGuide.bottomAnchor constraintEqualToAnchor:adjacentView.topAnchor].active = YES;
                }
                // Check view below
                else if (CGRectGetMinY(adjacentView.frame) >= CGRectGetMaxY(view.frame)) {
                    focusGuide.preferredFocusEnvironments = @[adjacentView];
                    [focusGuide.topAnchor constraintEqualToAnchor:adjacentView.bottomAnchor].active = YES;
                }
                // Check view to the left
                else if (CGRectGetMaxX(adjacentView.frame) <= view.frame.origin.x) {
                    focusGuide.preferredFocusEnvironments = @[adjacentView];
                    [focusGuide.rightAnchor constraintEqualToAnchor:adjacentView.leftAnchor].active = YES;
                }
                // Check view to the right
                else if (CGRectGetMinX(adjacentView.frame) >= CGRectGetMaxX(view.frame)) {
                    focusGuide.preferredFocusEnvironments = @[adjacentView];
                    [focusGuide.leftAnchor constraintEqualToAnchor:adjacentView.rightAnchor].active = YES;
                }
            }
        }
    }
}

@end
