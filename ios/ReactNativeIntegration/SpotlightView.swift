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
    private var targetFrameInWindow: CGRect = .zero
    private var shapeFrame: CGRect = .zero

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    var onDismiss: (() -> Void)?

    private var maskLayer: CAShapeLayer = CAShapeLayer()

    init(step: SpotlightStep) {
        self.step = step
        super.init(frame: UIScreen.main.bounds)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black.withAlphaComponent(0.7)

        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)

        addSubview(titleLabel)
        addSubview(subtitleLabel)

        titleLabel.text = step.title
        subtitleLabel.text = step.subtitle

        layer.mask = maskLayer
        maskLayer.fillRule = .evenOdd

        // Capture target frame in window coordinates
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            self.targetFrameInWindow = step.targetView.convert(step.targetView.bounds, to: window)
        } else {
            self.targetFrameInWindow = step.targetView.convert(step.targetView.bounds, to: nil)
        }

        print("🔹 [SpotlightView] Initialized for target: \(step.targetView) frame: \(targetFrameInWindow)")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()

        let padding: CGFloat = 12
        switch step.shape {
        case .circle:
            let diameter = max(targetFrameInWindow.width, targetFrameInWindow.height) + padding * 2
            shapeFrame = CGRect(x: targetFrameInWindow.midX - diameter/2,
                                y: targetFrameInWindow.midY - diameter/2,
                                width: diameter, height: diameter)
        case .rectangle:
            shapeFrame = targetFrameInWindow.insetBy(dx: -padding, dy: -padding)
        case .roundedRect(let radius):
            shapeFrame = targetFrameInWindow.insetBy(dx: -padding, dy: -padding)
            _ = radius
        }

        let path = UIBezierPath(rect: bounds)
        switch step.shape {
        case .circle:
            path.append(UIBezierPath(ovalIn: shapeFrame))
        case .rectangle:
            path.append(UIBezierPath(rect: shapeFrame))
        case .roundedRect(let radius):
            path.append(UIBezierPath(roundedRect: shapeFrame, cornerRadius: radius))
        }
        path.usesEvenOddFillRule = true
        maskLayer.path = path.cgPath

        print("🔹 [SpotlightView] layoutSubviews updated, shapeFrame: \(shapeFrame)")

        positionLabels()
    }

    private func positionLabels() {
        let screenBounds = bounds
        let padding: CGFloat = 12
        let maxWidth = screenBounds.width * 0.8

        let titleSize = titleLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let subtitleSize = subtitleLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let totalHeight = titleSize.height + 8 + subtitleSize.height

        var startY = shapeFrame.maxY + padding
        if startY + totalHeight > screenBounds.height {
            startY = shapeFrame.minY - padding - totalHeight
        }

        let screenMidX = screenBounds.midX
        var titleX: CGFloat = 0
        var subtitleX: CGFloat = 0
        let screenLeftThreshold = screenMidX * 0.7
        let screenRightThreshold = screenMidX * 1.3

        if shapeFrame.midX < screenLeftThreshold {
            titleX = max(padding, shapeFrame.minX)
            subtitleX = titleX
            titleLabel.textAlignment = .left
            subtitleLabel.textAlignment = .left
        } else if shapeFrame.midX > screenRightThreshold {
            titleX = min(screenBounds.width - titleSize.width - padding, shapeFrame.maxX - titleSize.width)
            subtitleX = min(screenBounds.width - subtitleSize.width - padding, shapeFrame.maxX - subtitleSize.width)
            titleLabel.textAlignment = .right
            subtitleLabel.textAlignment = .right
        } else {
            titleX = max(padding, shapeFrame.midX - titleSize.width/2)
            subtitleX = max(padding, shapeFrame.midX - subtitleSize.width/2)
            titleLabel.textAlignment = .center
            subtitleLabel.textAlignment = .center
        }

        titleLabel.frame = CGRect(x: titleX, y: startY, width: min(titleSize.width, maxWidth), height: titleSize.height)
        subtitleLabel.frame = CGRect(x: subtitleX, y: titleLabel.frame.maxY + 8, width: min(subtitleSize.width, maxWidth), height: subtitleSize.height)

        print("🔹 [SpotlightView] Labels positioned, titleFrame: \(titleLabel.frame), subtitleFrame: \(subtitleLabel.frame)")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
        onDismiss?()
    }
}
