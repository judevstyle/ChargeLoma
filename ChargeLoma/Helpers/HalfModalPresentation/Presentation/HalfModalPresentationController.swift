//
//  HalfModalPresentationController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 10/1/2565 BE.
//

import Foundation
import UIKit

public enum ModalScaleState {
    case adjustedOnce
    case normal
}

public class HalfModalPresentationController : UIPresentationController {
    public var isMaximized: Bool = false
    
    public var _dimmingView: UIView?
    public var panGestureRecognizer: UIPanGestureRecognizer
    public var direction: CGFloat = 0
    public var fristDirection: CGFloat? = nil
    public var state: ModalScaleState = .normal
    public static var heightModal: CGFloat = 300
    
    
    public var fristTapPosition: CGFloat? = nil
    
    public var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            return dimmedView
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
        
        _dimmingView = view
        
        return view
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.panGestureRecognizer = UIPanGestureRecognizer()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) -> Void {
        let relativeLocation = pan.location(in: presentedView)
        
        if self.fristTapPosition == nil {
            self.fristTapPosition = relativeLocation.y
        }
        
        let endPoint = pan.translation(in: pan.view?.superview)
        
        switch pan.state {
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height
        case .changed:
            let velocity = pan.velocity(in: pan.view?.superview)
            
            if self.fristDirection == nil {
                self.fristDirection = velocity.y
            }
//
            if self.fristTapPosition ?? 0.0 <= HalfModalPresentationController.heightModal {
                switch state {
                case .normal:
                    presentedView!.frame.origin.y = endPoint.y + (containerView!.frame.height - HalfModalPresentationController.heightModal)
                case .adjustedOnce:
                    presentedView!.frame.origin.y = endPoint.y
                }
                direction = velocity.y
            }
            
            break
        case .ended:
            if self.fristTapPosition ?? 0.0 <= HalfModalPresentationController.heightModal {
                if case .Up = pan.verticalDirection(target: presentedView!) {
                    print("Swiping up")
                    changeScale(to: .adjustedOnce)
                    callbackTransition(isHalfEnd: false)
                } else {
                    if state == .adjustedOnce {
                        changeScale(to: .normal)
                        callbackTransition(isHalfEnd: true)
                    } else {
                        presentedViewController.dismiss(animated: true, completion: nil)
                    }
                }
            }
            self.fristTapPosition = nil
            break
        default:
            break
        }
    }
    
    func callbackTransition(isHalfEnd: Bool) {
        if let vc = presentedViewController as? DetailStationViewController {
            if  isHalfEnd == true {
                vc.transitionHalfScreenEnd()
            } else {
                vc.transitionFullScreenEnd()
            }
        }
    }
    
    func changeScale(to state: ModalScaleState) {
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { () -> Void in
                presentedView.frame = containerView.frame
                let containerFrame = containerView.frame
                let halfFrame = CGRect(origin: CGPoint(x: 0, y: containerFrame.height - HalfModalPresentationController.heightModal),
                                       size: CGSize(width: containerFrame.width, height: HalfModalPresentationController.heightModal))
                let frame = state == .adjustedOnce ? containerView.frame : halfFrame
                
                presentedView.frame = frame
                
                if let navController = self.presentedViewController as? UINavigationController {
                    self.isMaximized = true
                    
                    navController.setNeedsStatusBarAppearanceUpdate()
                    
                    // Force the navigation bar to update its size
                    navController.isNavigationBarHidden = true
                    navController.isNavigationBarHidden = false
                }
            }, completion: { (isFinished) in
                self.state = state
            })
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        
        return CGRect(x: 0, y: containerView!.bounds.height - HalfModalPresentationController.heightModal, width: containerView!.bounds.width, height: HalfModalPresentationController.heightModal)
    }
    
    public override func presentationTransitionWillBegin() {
        let dimmedView = dimmingView
        setupHandleTapCancelsTouchesInView()
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            
            dimmedView.alpha = 0
            containerView.addSubview(dimmedView)
            dimmedView.addSubview(presentedViewController.view)
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                dimmedView.alpha = 0.5
                self.presentingViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    
    func setupHandleTapCancelsTouchesInView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapCancelsTouchesInView))
        tap.cancelsTouchesInView = false
        self.dimmingView.addGestureRecognizer(tap)
    }
    
    @objc func handleTapCancelsTouchesInView() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.dimmingView.alpha = 0
                self.presentingViewController.view.transform = CGAffineTransform.identity
            }, completion: { (completed) -> Void in
                print("done dismiss animation")
            })
            
        }
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        print("dismissal did end: \(completed)")
        
        if completed {
            dimmingView.removeFromSuperview()
            _dimmingView = nil
            
            isMaximized = false
        }
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        
    }
}

protocol HalfModalPresentable {}

extension HalfModalPresentable where Self: UIViewController {
    func maximizeToFullScreen() -> Void {
        if let presetation = navigationController?.presentationController as? HalfModalPresentationController {
            presetation.changeScale(to: .adjustedOnce)
        }
    }
}

extension HalfModalPresentable where Self: UINavigationController {
    func isHalfModalMaximized() -> Bool {
        if let presentationController = presentationController as? HalfModalPresentationController {
            return presentationController.isMaximized
        }
        
        return false
    }
}
