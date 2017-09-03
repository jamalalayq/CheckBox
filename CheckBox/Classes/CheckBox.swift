//: Playground - noun: a place where people can play

import UIKit


@IBDesignable
public final class CheckBox: UIControl {
    
    // MARK:- Variables
    
    @IBInspectable
    public var title: String? { didSet { setupTitleLabel() } }
    
    @IBInspectable
    public var titleColor: UIColor = UIColor.black { didSet { setupTitleLabel() } }
    
    @IBInspectable
    public var font: UIFont = UIFont.systemFont(ofSize: 14) { didSet { setupTitleLabel() } }
    
    @IBInspectable
    public var titleAlignment: NSTextAlignment = NSTextAlignment.left { didSet { setupTitleLabel() } }
    
    @IBInspectable
    public var isChecked: Bool = false { didSet { DispatchQueue.main.asyncAfter(deadline: .now()+0.00000001) { [weak self] in
        self?.checkBoxConfigurations()
        } } }
    
    @IBInspectable
    public var borderWidth: CGFloat = 1.6 { didSet { checkPanel.layer.borderWidth = borderWidth } }
    
    @IBInspectable
    public var selectedColor: UIColor = UIColor.blue { didSet {
        if (selectedColor == .clear) {
            checkPanel.layer.borderColor = unSelectedColor.cgColor
        } else {
            checkPanel.layer.borderColor = selectedColor.cgColor
            checkPanel.backgroundColor = selectedColor
        }
        } }
    
    @IBInspectable
    public var unSelectedColor: UIColor = UIColor.darkGray { didSet {
        checkPanel.backgroundColor = backgroundColor
        checkPanel.layer.borderColor = unSelectedColor.cgColor
        } }
    
    @IBInspectable
    public var markWidth: CGFloat = 3.0 { didSet { shapLayer.lineWidth = markWidth } }
    
    @IBInspectable
    public var dimensions: CGFloat = 40.0 { didSet { setCheckPanelConstraints() } }
    
    @IBInspectable
    public var markColor: UIColor = UIColor.white { didSet { shapLayer.strokeColor = markColor.cgColor } }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 3.0 { didSet { checkPanel.layer.cornerRadius = cornerRadius } }
    
    public var onClick: ((CheckBox)->())?
    private var shapLayer: CAShapeLayer!, path: UIBezierPath!
    
    // MARK:- Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK:- Overridden functions
    
    
    // MARK:- UIs
    
    private lazy var checkPanel: UIView = { [weak self] in
        let mark = UIView()
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.backgroundColor = self?.backgroundColor
        return mark
        }()
    
    private lazy var lblTitle: UILabel = { [weak self] in
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 1
        lbl.minimumScaleFactor = 0.5
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
        }()
    
    
    // MARK:- Functions
    
    private func setup() -> Void {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
        addSubview(checkPanel)
        addSubview(lblTitle)
        setTitleLabelConstraints()
        shapLayer = CAShapeLayer()
        path = UIBezierPath()
        
    }
    
    @objc private func onClick(_ gesture: UITapGestureRecognizer) {
        isChecked = !isChecked
        sendActions(for: .touchUpInside)
        sendActions(for: .valueChanged)
        onClick?(self)
    }
    
    private func setTitleLabelConstraints() -> Void {
        lblTitle.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        lblTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: checkPanel.trailingAnchor, constant: 8).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
    }
    
    private func setCheckPanelConstraints() -> Void {
        checkPanel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        checkPanel.heightAnchor.constraint(equalToConstant: dimensions).isActive = true
        checkPanel.widthAnchor.constraint(equalToConstant: dimensions).isActive = true
        checkPanel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
    }
    
    private func checkBoxConfigurations() -> Void {
        checkPanel.layer.borderWidth = borderWidth
        checkPanel.layer.cornerRadius = cornerRadius
        checkPanel.layer.masksToBounds = true
        if (isChecked) {
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                guard let this = self else { return }
                this.checkPanel.layer.borderColor = (this.selectedColor == .clear) ? this.unSelectedColor.cgColor : this.selectedColor.cgColor
                this.checkPanel.backgroundColor = this.selectedColor
                }, completion: nil)
            check()
        } else {
            UIView.animate(withDuration: 0.03, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                guard let this = self else { return }
                this.checkPanel.backgroundColor = this.backgroundColor
                this.checkPanel.layer.borderColor = this.unSelectedColor.cgColor
                }, completion: nil)
            uncheck()
        }
    }
    
    private func setupTitleLabel() -> Void {
        lblTitle.text = title
        lblTitle.textColor = titleColor
        lblTitle.font = font
        lblTitle.textAlignment = titleAlignment
    }
    
    
    private func check() -> Void {
        path.move(to: CGPoint(x: checkPanel.bounds.width/2 * 0.35, y: checkPanel.bounds.height/2)) //27
        path.addLine(to: CGPoint(x: checkPanel.bounds.width/2 - checkPanel.bounds.width/2 * 0.3, y: checkPanel.bounds.height * 0.80)) //4
        path.addLine(to: CGPoint(x: checkPanel.bounds.width - 5, y: 5)) //5
        shapLayer.path = path.cgPath
        shapLayer.strokeColor = markColor.cgColor
        shapLayer.fillColor = UIColor.clear.cgColor
        shapLayer.lineWidth = markWidth
        shapLayer.lineCap = kCALineCapRound
        shapLayer.strokeStart = 0
        shapLayer.strokeEnd = 1
        checkPanel.layer.addSublayer(shapLayer)
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 0.6
        basicAnimation.fromValue = 0.0
        basicAnimation.toValue = 1.0
        basicAnimation.fillMode = kCAFillModeBoth
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapLayer.add(basicAnimation, forKey: basicAnimation.keyPath)
        
    }
    
    private func uncheck() -> Void {
        if (shapLayer != nil) {
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.duration = 0.4
            basicAnimation.fromValue = 1.0
            basicAnimation.toValue = 0.0
            basicAnimation.fillMode = kCAFillModeBoth
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            shapLayer.add(basicAnimation, forKey: basicAnimation.keyPath)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4) { [weak self] in
                self?.path.removeAllPoints()
                self?.shapLayer.removeAllAnimations()
                self?.shapLayer.removeFromSuperlayer()
            }
        }
    }
    
}

