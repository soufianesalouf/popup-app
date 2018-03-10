//
//  ViewController.swift
//  prop1
//
//  Created by Soufiane Salouf on 3/8/18.
//  Copyright © 2018 Soufiane Salouf. All rights reserved.
//

import UIKit
import WebKit

class MainVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var viewToAnimate: GradientView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var buttomImage: UIImageView!
    @IBOutlet weak var popupView: RoundedShadowView!
    @IBOutlet weak var closePopupBtn: UIButton!
    @IBOutlet weak var popupWebView: WKWebView!
    
    //var
    var timer: Timer!
    var firstPopupClosed = false
    var enablShowingButtomImage = false
    var buttomImageIsShowen = false
    
    let animator = UIViewPropertyAnimator(duration: 3, curve: .easeInOut)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: MAIN_URL)!))
        webView.isUserInteractionEnabled = false
        
        popupWebView.load(URLRequest(url: URL(string: FIRST_POPUP_URL)!))
        popupWebView.isUserInteractionEnabled = false
        popupWebView.layer.cornerRadius = 10
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimeCodeForPopup), userInfo: nil, repeats: false)
    }
    
    public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    @objc func runTimedCodeForButtomImage(){
        if enablShowingButtomImage {
            if buttomImageIsShowen {
                animate(thisView: self.buttomImage, toThePoint: CGPoint(x: self.buttomImage.bounds.width/2 ,y: self.view.bounds.height + self.buttomImage.bounds.height ))
                buttomImageIsShowen = false
            } else {
                animate(thisView: self.buttomImage, toThePoint: CGPoint(x: self.buttomImage.bounds.width/2 ,y: self.view.bounds.height - (self.buttomImage.bounds.height / 2) ))
                buttomImageIsShowen = true
            }
        }
    }
    
    @objc func runTimeCodeForPopup(){
        animate(thisView: popupView, toThePoint: CGPoint(x: self.view.bounds.width / 2 ,y: self.view.bounds.height / 2 ))
    }
    
    func animate ( thisView view: UIView, toThePoint point: CGPoint){
        animator.addAnimations {
            view.center = point
        }
        animator.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    @IBAction func closePopupBtnWasPressed(_ sender: Any) {
        if !firstPopupClosed {
            animate(thisView: popupView, toThePoint: CGPoint(x: 600 ,y: self.view.bounds.height / 2 ))
            popupWebView.load(URLRequest(url: URL(string: SECOND_POPUP_URL)!))
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimeCodeForPopup), userInfo: nil, repeats: false)
            firstPopupClosed = true
        } else {
            animate(thisView: popupView, toThePoint: CGPoint(x: -300 ,y: self.view.bounds.height / 2 ))
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber(inRange: 10...15)), target: self, selector: #selector(runTimedCodeForButtomImage), userInfo: nil, repeats: true)
            enablShowingButtomImage = true
        }
        
    }
    
    @IBAction func openPopupUrlBtnWasPressed(_ sender: Any) {
        UIApplication.shared.open(popupWebView.url!, options: [:], completionHandler: nil)
    }
    
    
}

