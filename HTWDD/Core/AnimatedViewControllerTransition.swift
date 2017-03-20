//
//  ModalPopTransition.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol AnimatedViewControllerTransitionDataSource: class {
    func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView
}

protocol AnimatedViewControllerTransitionAnimator: class {
    func animate(source: CGRect, duration: TimeInterval, direction: Direction, completion: @escaping (Bool) -> Void)
}

enum Direction {
    case present, dismiss
}

class AnimatedViewControllerTransition: NSObject {

    fileprivate weak var back: AnimatedViewControllerTransitionDataSource?
    fileprivate weak var front: AnimatedViewControllerTransitionAnimator?

    fileprivate var direction = Direction.present

    init?(back: UIViewController, front: UIViewController) {
        let _ = front.view

        guard
            let back = back as? AnimatedViewControllerTransitionDataSource,
            let front = front as? AnimatedViewControllerTransitionAnimator
        else {
            return nil
        }

        self.back = back
        self.front = front
    }

}

extension AnimatedViewControllerTransition: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.direction = .present
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.direction = .dismiss
        return self
    }

}

extension AnimatedViewControllerTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated ?? false ? 0.3 : 0.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        var cancelled = false

        defer {
            if cancelled {
                transitionContext.completeTransition(false)
            }
        }

        guard let views = transitionContext.views else {
            cancelled = true
            return
        }

        guard let sourceView = self.back?.viewForTransition(self) else {
            cancelled = true
            return
        }

        if self.direction == .present {
            views.container.addSubview(views.to)
        } else {
            views.container.insertSubview(views.to, at: 0)
        }

        views.to.frame = views.container.bounds

        let duration = self.transitionDuration(using: transitionContext)

        self.front?.animate(source: sourceView.frame, duration: duration, direction: self.direction, completion: { fininshed in
            transitionContext.completeTransition(fininshed)
        })
    }
}

fileprivate extension UIViewControllerContextTransitioning {

    var views: (from: UIView, to: UIView, container: UIView)? {
        guard
            let fromView = self.view(forKey: .from),
            let toView = self.view(forKey: .to)
        else {
            return nil
        }

        return (fromView, toView, self.containerView)
    }

}
