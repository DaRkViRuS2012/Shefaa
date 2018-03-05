import UIKit

class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
        
        _ = vibrancyView.anchor(self.topAnchor, left: self.leadingAnchor, bottom: self.bottomAnchor, right: self.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndictor.Center(self)
       // label.CenterX(activityIndictor, Constant: 16)
        label.CenterY(self, Constant: 0)
        _ = label.anchor(nil, left: activityIndictor.trailingAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
//
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            _ = self.anchor(superview.topAnchor, left: superview.leadingAnchor, bottom: nil, right: nil, topConstant: superview.frame.height / 2 - height / 2, leftConstant: superview.frame.size.width / 2 - width / 2, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
//            vibrancyView.frame = self.bounds
//            
 //           let activityIndicatorSize: CGFloat = 40
//            activityIndictor.frame = CGRect(x: 5,
//                                            y: height / 2 - activityIndicatorSize / 2,
//                                            width: activityIndicatorSize,
//                                            height: activityIndicatorSize)
//            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
//            label.frame = CGRect(x: activityIndicatorSize + 5,
//                                 y: 0,
//                                 width: width - activityIndicatorSize - 15,
//                                 height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}