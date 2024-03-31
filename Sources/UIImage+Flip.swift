//
//  UIImage+Flip.swift
//  MultiSlider
//

import Foundation
public extension UIImage {
    struct FlipOptions: OptionSet {
        public typealias RawValue = Int

        public let rawValue: RawValue

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        /// Converts "↲" to "↲". Does nothing.
        public static let none = FlipOptions([])

        /// Converts "↲" to "↳". Flips like around **vertical** line (Y-axis).
        public static let horizontal = FlipOptions(rawValue: 1 << 0)

        /// Converts "↲" to "↰". Flips like around **horizontal** (X-axis).
        public static let vertical = FlipOptions(rawValue: 1 << 1)

        /// Converts "↲" to "↱". Flips in both directions.
        public static let both = FlipOptions([.horizontal, .vertical])
    }

    func flipped(options: FlipOptions) -> UIImage {
        guard !options.isEmpty, let cgImage = cgImage else {
            return self
        }

        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(size: rect.size).image(actions: { ctx in

            // Reset transformation matrix to default
            // https://stackoverflow.com/questions/469505/how-to-reset-to-identity-the-current-transformation-matrix-with-some-cgcontext
            ctx.cgContext.concatenate(ctx.cgContext.ctm.inverted())

            // Set original scale
            ctx.cgContext.scaleBy(x: scale, y: scale)

            if options.contains(.vertical) {
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                ctx.cgContext.translateBy(x: 0.0, y: -size.height)
            }
            if options.contains(.horizontal) {
                ctx.cgContext.scaleBy(x: -1.0, y: 1.0)
                ctx.cgContext.translateBy(x: -size.width, y: 0.0)
            }

            ctx.cgContext.draw(cgImage, in: rect)
        })
    }
}
