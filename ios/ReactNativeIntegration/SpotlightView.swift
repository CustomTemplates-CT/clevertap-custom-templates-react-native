//import UIKit
//
//enum SpotlightShape {
//    case circle
//    case rectangle
//    case roundedRect(cornerRadius: CGFloat)
//}
//
//struct SpotlightStep {
//    let targetView: UIView
//    let title: String
//    let subtitle: String
//    let shape: SpotlightShape
//}
//
//@MainActor
//class SpotlightView: UIView {
//
//    private var step: SpotlightStep
//    private var targetFrameInWindow: CGRect = .zero
//    private var shapeFrame: CGRect = .zero
//
//    let titleLabel = UILabel()
//    let subtitleLabel = UILabel()
//    var onDismiss: (() -> Void)?
//
//    private var maskLayer: CAShapeLayer = CAShapeLayer()
//
//    init(step: SpotlightStep) {
//        self.step = step
//        super.init(frame: UIScreen.main.bounds)
//        isUserInteractionEnabled = true
//        backgroundColor = UIColor.black.withAlphaComponent(0.7)
//
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        subtitleLabel.numberOfLines = 0
//        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
//
//        addSubview(titleLabel)
//        addSubview(subtitleLabel)
//
//        titleLabel.text = step.title
//        subtitleLabel.text = step.subtitle
//
//        layer.mask = maskLayer
//        maskLayer.fillRule = .evenOdd
//
//        // Capture target frame in window coordinates
//        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
//            self.targetFrameInWindow = step.targetView.convert(step.targetView.bounds, to: window)
//        } else {
//            self.targetFrameInWindow = step.targetView.convert(step.targetView.bounds, to: nil)
//        }
//
//        print("🔹 [SpotlightView] Initialized for target: \(step.targetView) frame: \(targetFrameInWindow)")
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let padding: CGFloat = 12
//        switch step.shape {
//        case .circle:
//            let diameter = max(targetFrameInWindow.width, targetFrameInWindow.height) + padding * 2
//            shapeFrame = CGRect(x: targetFrameInWindow.midX - diameter/2,
//                                y: targetFrameInWindow.midY - diameter/2,
//                                width: diameter, height: diameter)
//        case .rectangle:
//            shapeFrame = targetFrameInWindow.insetBy(dx: -padding, dy: -padding)
//        case .roundedRect(let radius):
//            shapeFrame = targetFrameInWindow.insetBy(dx: -padding, dy: -padding)
//            _ = radius
//        }
//
//        let path = UIBezierPath(rect: bounds)
//        switch step.shape {
//        case .circle:
//            path.append(UIBezierPath(ovalIn: shapeFrame))
//        case .rectangle:
//            path.append(UIBezierPath(rect: shapeFrame))
//        case .roundedRect(let radius):
//            path.append(UIBezierPath(roundedRect: shapeFrame, cornerRadius: radius))
//        }
//        path.usesEvenOddFillRule = true
//        maskLayer.path = path.cgPath
//
//        print("🔹 [SpotlightView] layoutSubviews updated, shapeFrame: \(shapeFrame)")
//
//        positionLabels()
//    }
//
//    private func positionLabels() {
//        let screenBounds = bounds
//        let padding: CGFloat = 12
//        let maxWidth = screenBounds.width * 0.8
//
//        let titleSize = titleLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
//        let subtitleSize = subtitleLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
//        let totalHeight = titleSize.height + 8 + subtitleSize.height
//
//        var startY = shapeFrame.maxY + padding
//        if startY + totalHeight > screenBounds.height {
//            startY = shapeFrame.minY - padding - totalHeight
//        }
//
//        let screenMidX = screenBounds.midX
//        var titleX: CGFloat = 0
//        var subtitleX: CGFloat = 0
//        let screenLeftThreshold = screenMidX * 0.7
//        let screenRightThreshold = screenMidX * 1.3
//
//        if shapeFrame.midX < screenLeftThreshold {
//            titleX = max(padding, shapeFrame.minX)
//            subtitleX = titleX
//            titleLabel.textAlignment = .left
//            subtitleLabel.textAlignment = .left
//        } else if shapeFrame.midX > screenRightThreshold {
//            titleX = min(screenBounds.width - titleSize.width - padding, shapeFrame.maxX - titleSize.width)
//            subtitleX = min(screenBounds.width - subtitleSize.width - padding, shapeFrame.maxX - subtitleSize.width)
//            titleLabel.textAlignment = .right
//            subtitleLabel.textAlignment = .right
//        } else {
//            titleX = max(padding, shapeFrame.midX - titleSize.width/2)
//            subtitleX = max(padding, shapeFrame.midX - subtitleSize.width/2)
//            titleLabel.textAlignment = .center
//            subtitleLabel.textAlignment = .center
//        }
//
//        titleLabel.frame = CGRect(x: titleX, y: startY, width: min(titleSize.width, maxWidth), height: titleSize.height)
//        subtitleLabel.frame = CGRect(x: subtitleX, y: titleLabel.frame.maxY + 8, width: min(subtitleSize.width, maxWidth), height: subtitleSize.height)
//
//        print("🔹 [SpotlightView] Labels positioned, titleFrame: \(titleLabel.frame), subtitleFrame: \(subtitleLabel.frame)")
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeFromSuperview()
//        onDismiss?()
//    }
//}


import UIKit

enum SpotlightShape {
    case circle
    case rectangle
    case roundedRect(cornerRadius: CGFloat)
}

struct SpotlightStep {
    let targetView: UIView
    let title: String
    let subtitle: String
    let shape: SpotlightShape
}

@MainActor
class SpotlightView: UIView {
    
    private var step: SpotlightStep
    private var targetFrame: CGRect = .zero
    private var shapeFrame: CGRect = .zero
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    // Callback for moving to next step
    var onDismiss: (() -> Void)?
    
    init(step: SpotlightStep) {
        self.step = step
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            self.targetFrame = step.targetView.convert(step.targetView.bounds, to: window)
        }
        
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        isUserInteractionEnabled = true
        
        setupLabels(title: step.title, subtitle: step.subtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels(title: String, subtitle: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
    }
    
    private func positionLabels() {
        let screenBounds = UIScreen.main.bounds
        let padding: CGFloat = 12
        
        let maxWidth = screenBounds.width * 0.8
        let titleSize = titleLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let subtitleSize = subtitleLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let totalHeight = titleSize.height + 8 + subtitleSize.height
        
        // Place below shape by default
        var startY = shapeFrame.maxY + padding
        
        // If not enough space → move above
        if startY + totalHeight > screenBounds.height {
            startY = shapeFrame.minY - padding - totalHeight
        }
        
        // Alignment logic
        let screenMidX = screenBounds.midX
        var titleX: CGFloat = 0
        var subtitleX: CGFloat = 0
        
        if shapeFrame.midX < screenMidX * 0.7 { // Left
            titleX = shapeFrame.minX
            subtitleX = shapeFrame.minX
            titleLabel.textAlignment = .left
            subtitleLabel.textAlignment = .left
        } else if shapeFrame.midX > screenMidX * 1.3 { // Right
            titleX = shapeFrame.maxX - titleSize.width
            subtitleX = shapeFrame.maxX - subtitleSize.width
            titleLabel.textAlignment = .right
            subtitleLabel.textAlignment = .right
        } else { // Center
            titleX = shapeFrame.midX - titleSize.width/2
            subtitleX = shapeFrame.midX - subtitleSize.width/2
            titleLabel.textAlignment = .center
            subtitleLabel.textAlignment = .center
        }
        
        // Apply frames
        titleLabel.frame = CGRect(x: titleX, y: startY, width: titleSize.width, height: titleSize.height)
        subtitleLabel.frame = CGRect(x: subtitleX, y: titleLabel.frame.maxY + 8, width: subtitleSize.width, height: subtitleSize.height)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(rect: rect)
        
        switch step.shape {
        case .circle:
            let diameter = max(targetFrame.width, targetFrame.height) + 24
            shapeFrame = CGRect(
                x: targetFrame.midX - diameter/2,
                y: targetFrame.midY - diameter/2,
                width: diameter,
                height: diameter
            )
            path.append(UIBezierPath(ovalIn: shapeFrame))
            
        case .rectangle:
            shapeFrame = targetFrame.insetBy(dx: -12, dy: -12)
            path.append(UIBezierPath(rect: shapeFrame))
            
        case .roundedRect(let radius):
            shapeFrame = targetFrame.insetBy(dx: -12, dy: -12)
            path.append(UIBezierPath(roundedRect: shapeFrame, cornerRadius: radius))
        }
        
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        layer.mask = maskLayer
        
        // Position labels now
        positionLabels()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
        onDismiss?()
    }
}

@MainActor
class Spotlight {
    
    private static var steps: [SpotlightStep] = []
    private static var currentIndex = 0
    
    static func show(steps: [SpotlightStep]) {
        guard !steps.isEmpty else { return }
        self.steps = steps
        self.currentIndex = 0
        showStep()
    }
    
    private static func showStep() {
        guard currentIndex < steps.count else { return }
        let step = steps[currentIndex]
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let spotlight = SpotlightView(step: step)
            spotlight.onDismiss = {
                currentIndex += 1
                showStep()
            }
            window.addSubview(spotlight)
        }
    }
    
    // Convenience for single step
    static func show(over view: UIView, title: String, subtitle: String, shape: SpotlightShape = .circle) {
        let step = SpotlightStep(targetView: view, title: title, subtitle: subtitle, shape: shape)
        show(steps: [step])
    }
}
