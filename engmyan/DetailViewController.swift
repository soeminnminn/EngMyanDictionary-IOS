//
//  DetailViewController.swift
//  engmyan
//
//  Created by New Wave Technology on 1/8/18.
//  Copyright © 2018 Soe Minn Minn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var navItemTitle: UINavigationItem!
    @IBOutlet weak var webViewDetail: UIWebView!
    @IBOutlet weak var actionSound: UIBarButtonItem!
    @IBOutlet weak var actionImage: UIBarButtonItem!
    
    var recId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let itemData = DBManager.shared.queryDefinition(id: recId) {
            navItemTitle.title = itemData.word
            
            let html = getDefinitionHtml(itemData: itemData)
            webViewDetail.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            
            actionSound.descriptiveValue = itemData.word
            actionImage.descriptiveValue = itemData.filename
            
            if itemData.picture == false {
                navigationItem.rightBarButtonItems?.remove(at: 0)
            }
        }
        webViewDetail.delegate = self
        ProgressView.shared.showProgressView(self.view)
    }

    @IBAction func showImage(_ sender: Any) {
        let target = sender as! UIBarButtonItem
        if let text = target.descriptiveValue {
            
            let bundleUrl = Bundle.main.resourceURL?.appendingPathComponent("pics").appendingPathComponent(text + ".png")
            if FileManager.default.fileExists(atPath: (bundleUrl?.path)!) {
                let alert = CustomAlertView()
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 290))
                
                let imageView = UIImageView(frame: CGRect(x: 8, y: 58, width: containerView.frame.width, height: 200))
                imageView.center = CGPoint(x: containerView.frame.width / 2, y: containerView.frame.height / 2)
                imageView.image = UIImage(contentsOfFile: bundleUrl!.path)
                containerView.addSubview(imageView)
                
                alert.containerView = containerView
                alert.delegate = self
                alert.show()
            }
        }
    }
    
    @IBAction func playSound(_ sender: Any) {
        let target = sender as! UIBarButtonItem
        if let text = target.descriptiveValue {
            let textToSpeech = TextToSpeech()
            textToSpeech.speak(text)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDefinitionHtml(itemData: DictionaryItem) -> String {
        var html = "<!DOCTYPE html>"
        html += "<html lang=\"en\">"
        html += "<head>"
        html += "<meta content=\"text/html; charset=utf-8\" http-equiv=\"content-type\">"
        html += "<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=yes, width=device-width\" />"
        html += "<meta name=\"Keywords\" content=\"\">"
        //html += "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">"
        //html += "<script type=\"text/javascript\" src=\"script.js\"></script>"
        html += "<style type=\"text/css\">"
        html += "body,div,h1,h2,h3,input,textarea {"
        html += "font-family:\"Zawgyi\";"
        html += "-webkit-font-smoothing: antialiased!important;"
        html += "text-rendering: optimizeLegibility;"
        html += "}"
        html += "p {"
        html += "margin:0pt;"
        html += "line-height:180%;"
        html += "font-size:12.0pt;"
        html += "}"
        html += "p.desc , p.synonym {"
        html += "margin-left:10pt;"
        html += "}"
        html += "h2 {"
        html += "color: red;"
        html += "font-weight: bold;"
        html += "font-size: 16pt;"
        html += "}"
        html += "h3 {"
        html += "color: #8080C0;"
        html += "font-weight: bold;"
        html += "font-size: 12pt;"
        html += "}"
        html += "a {"
        html += "color: #000;"
        html += "text-decoration: none;"
        html += "border-bottom: 1px dotted #808080;"
        html += "}"
        html += "</style>"
        if itemData.title != "" {
            html += "<title>" + itemData.title + "</title>"
        } else {
            html += "<title>Untitled</title>"
        }
        html += "</head>"
        html += "<body>"
        html += itemData.definition
        
        if itemData.synonym != "" {
            html += "<hr />"
            html += "<h3>Synonym</h3>"
            html += "<p class=\"synonym\">"
            html += itemData.synonym
            html += "</p>"
        }
        
        html += "</html>"
        return html
    }
}

extension DetailViewController : UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ProgressView.shared.hideProgressView()
    }
}

extension DetailViewController : CustomAlertViewDelegate {
    func customAlertViewButtonTouchUpInside(alertView: CustomAlertView, buttonIndex: Int) {
        alertView.close()
    }
}

extension UIBarButtonItem {
    private struct AssociatedKeys {
        static var DescriptiveValue = "nsh_DescriptiveValue"
    }
    
    @IBInspectable var descriptiveValue: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveValue) as? String
        }
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.DescriptiveValue, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
