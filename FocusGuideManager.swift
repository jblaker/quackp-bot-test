import UIKit

class FocusGuideManager {
    
    // Sorts the views by their origin coordinates (top-left point)
    func sortViewsByPosition(views: [UIView]) -> [UIView] {
        return views.sorted { view1, view2 in
            if view1.frame.origin.y == view2.frame.origin.y {
                return view1.frame.origin.x < view2.frame.origin.x
            } else {
                return view1.frame.origin.y < view2.frame.origin.y
            }
        }
    }
    
    // Sets up UIFocusGuides to navigate through a sorted array of UIViews
    func setupFocusGuides(forSortedViews sortedViews: [UIView]) {
        for (index, view) in sortedViews.enumerated() {
            let focusGuide = UIFocusGuide()
            view.superview?.addLayoutGuide(focusGuide)
            
            // Anchor the focus guide to the current view
            focusGuide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            focusGuide.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            focusGuide.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            
            // Find adjacent views
            let viewAbove = sortedViews.last(where: { $0.frame.maxY <= view.frame.minY })
            let viewBelow = sortedViews.first(where: { $0.frame.minY >= view.frame.maxY })
            let viewToLeft = sortedViews.last(where: { $0.frame.maxX <= view.frame.minX && $0.frame.origin.y == view.frame.origin.y })
            let viewToRight = sortedViews.first(where: { $0.frame.minX >= view.frame.maxX && $0.frame.origin.y == view.frame.origin.y })

            // Set preferred focus environments for the focus guide
            focusGuide.preferredFocusEnvironments = [
                (direction: "up", view: viewAbove),
                (direction: "down", view: viewBelow),
                (direction: "left", view: viewToLeft),
                (direction: "right", view: viewToRight)
            ].compactMap { pair in
                guard let view = pair.view else { return nil }
                return (pair.direction, view)
            }.reduce([:]) { dict, tuple in
                var dict = dict
                dict[tuple.0] = tuple.1
                return dict
            }
            
            // Activate/deactivate focus guides based on adjacent views
            focusGuide.isEnabled = focusGuide.preferredFocusEnvironments.count > 0
        }
    }
}
