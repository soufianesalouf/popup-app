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
    var firstTimer: Timer!
    var secondTimer: Timer!
    var index = 0
    var enablShowingButtomImage = false
    var buttomImageIsShowen = false
    
    let animator = UIViewPropertyAnimator(duration: 3, curve: .easeInOut)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: MAIN_URL)
        let request = URLRequest(url: url!)
        webView.load(request)
        popupWebView.load(URLRequest(url: URL(string: FIRST_POPUP_URL)!))
        webView.isUserInteractionEnabled = false
        popupWebView.isUserInteractionEnabled = false
        
        secondTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimeCodeForFirstPopup), userInfo: nil, repeats: false)
    }
    
    public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    @objc func runTimedCodeForButtomImage(){
        if enablShowingButtomImage == true {
            if buttomImageIsShowen == true {
                buttomImageIsShowen = false
                animator.addAnimations {
                    self.buttomImage.center = CGPoint(x: self.buttomImage.bounds.width/2 ,y: self.view.bounds.height + self.buttomImage.bounds.height )
                }
                animator.startAnimation()
            } else {
                buttomImageIsShowen = true
                animator.addAnimations {
                    self.buttomImage.center = CGPoint(x: self.buttomImage.bounds.width/2 ,y: self.view.bounds.height - (self.buttomImage.bounds.height / 2) )
                }
                animator.startAnimation()
            }
        }
    }
    
    @objc func runTimeCodeForFirstPopup(){
        animator.addAnimations {
            self.popupView.center = CGPoint(x: self.view.bounds.width / 2 ,y: self.view.bounds.height / 2 )
        }
        animator.startAnimation()
    }
    
    @objc func runTimeCodeForSecondPopup(){
        animator.addAnimations {
            self.popupView.center = CGPoint(x: self.view.bounds.width / 2 ,y: self.view.bounds.height / 2 )
        }
        animator.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firstTimer.invalidate()
    }

    @IBAction func closePopupBtnWasPressed(_ sender: Any) {
        if index == 0 {
            index += 1
            animator.addAnimations {
                self.popupView.center = CGPoint(x: 600 ,y: self.view.bounds.height / 2 )
            }
            animator.startAnimation()
            popupWebView.load(URLRequest(url: URL(string: SECOND_POPUP_URL)!))
            secondTimer.invalidate()
            secondTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimeCodeForSecondPopup), userInfo: nil, repeats: false)
        } else {
            animator.addAnimations {
                self.popupView.center = CGPoint(x: -300 ,y: self.view.bounds.height / 2 )
            }
            animator.startAnimation()
            secondTimer.invalidate()
            enablShowingButtomImage = true
            firstTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber(inRange: 10...15)), target: self, selector: #selector(runTimedCodeForButtomImage), userInfo: nil, repeats: true)
        }
        
    }
    
    
}

