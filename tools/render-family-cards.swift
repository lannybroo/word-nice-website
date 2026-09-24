// Run from the site root: swift tools/render-family-cards.swift
// Uses the existing otter artwork and the app's palette. No third-party packages.
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let output = root.appendingPathComponent("images/families")
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
let otter = NSImage(contentsOf: root.appendingPathComponent("images/otter.png"))!
func color(_ hex: UInt32) -> NSColor {
    NSColor(srgbRed: CGFloat((hex >> 16) & 255) / 255,
            green: CGFloat((hex >> 8) & 255) / 255,
            blue: CGFloat(hex & 255) / 255, alpha: 1)
}
func rounded(_ rect: NSRect, _ radius: CGFloat, _ fill: UInt32) {
    color(fill).setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}
func text(_ value: String, x: CGFloat, y: CGFloat, size: CGFloat,
          weight: NSFont.Weight = .bold, ink: UInt32 = 0x1F2D2E, centeredIn width: CGFloat? = nil) {
    let system = NSFont.systemFont(ofSize: size, weight: weight)
    let font = NSFont(descriptor: system.fontDescriptor.withDesign(.rounded) ?? system.fontDescriptor, size: size)!
    let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color(ink)]
    let measuredWidth = (value as NSString).size(withAttributes: attributes).width
    let originX = width.map { x + ($0 - measuredWidth) / 2 } ?? x
    (value as NSString).draw(at: NSPoint(x: originX, y: y), withAttributes: attributes)
}
for number in 1...100 {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 1200, pixelsHigh: 630,
                                 bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
                                 isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    NSGradient(colors: [color(0xEAF6FF), color(0xFFF9F1), color(0xFFE6EE)])!
        .draw(in: NSRect(x: 0, y: 0, width: 1200, height: 630), angle: 65)
    rounded(NSRect(x: 36, y: 36, width: 1128, height: 558), 38, 0xFFFDFA)
    // Left: a legible invitation even in a small message preview.
    text("Word", x: 82, y: 478, size: 58)
    text("Nice", x: 247, y: 478, size: 58, ink: 0x3A7FB0)
    rounded(NSRect(x: 82, y: 378, width: 380, height: 76), 30, 0xFFE6EE)
    text("FAMILY \(number)", x: 107, y: 390, size: 44, weight: .semibold)
    text("All smiles.", x: 78, y: 270, size: 76)
    text("Your turn?", x: 78, y: 182, size: 76, ink: 0x3A7FB0)
    text("A little good in every word.", x: 83, y: 107, size: 27, weight: .medium, ink: 0x52636A)
    // Right: the familiar mascot and four happy letter tiles; no puzzle spoilers.
    otter.draw(in: NSRect(x: 711, y: 229, width: 353, height: 281))
    for (index, letter) in Array("NICE").enumerated() {
        let x = CGFloat(708 + index * 96)
        rounded(NSRect(x: x, y: 112, width: 84, height: 102), 21, index % 2 == 0 ? 0xDDEFFC : 0xFFE6EE)
        text(String(letter), x: x, y: 149, size: 44, centeredIn: 84)
        let smile = NSBezierPath()
        smile.move(to: NSPoint(x: x + 32, y: 135))
        smile.curve(to: NSPoint(x: x + 52, y: 135), controlPoint1: NSPoint(x: x + 37, y: 125), controlPoint2: NSPoint(x: x + 47, y: 125))
        smile.lineWidth = 3
        smile.lineCapStyle = .round
        color(0x3A7FB0).setStroke()
        smile.stroke()
    }
    NSGraphicsContext.restoreGraphicsState()
    let data = bitmap.representation(using: .png, properties: [:])!
    try data.write(to: output.appendingPathComponent("\(number).png"))
}
print("Rendered 100 family cards (1200 × 630).")
