//
//  UIView+Extensions.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import UIKit

extension UIView {
    
    static func fadeIn(view: UIView, fadeInTime: TimeInterval, alphaValue: TimeInterval, delay: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { Timer in
            UIView.animate(withDuration: fadeInTime) {
                view.alpha = CGFloat(alphaValue)
            }
        }
    }
    
    static func fadeOut(view: UIView, fadeOutTime: TimeInterval, delay: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { Timer in
            UIView.animate(withDuration: fadeOutTime) {
                view.alpha = 0
            }
        }
    }
    
    static func fadeInOut(view: UIView,fadeInDelay: TimeInterval, fadeInTime: TimeInterval, alphaValue: TimeInterval, fadeOutDelay: TimeInterval, fadeOutTime: TimeInterval) {
        fadeIn(view: view, fadeInTime: fadeInTime, alphaValue: alphaValue, delay: fadeInDelay )
        fadeOut(view: view, fadeOutTime: fadeOutTime, delay: fadeOutDelay + fadeInDelay)
    }
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
