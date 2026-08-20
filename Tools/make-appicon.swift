// アプリアイコンを生成する。リポジトリのルートから実行する:
//   swift Tools/make-appicon.swift Shirube/Assets.xcassets/AppIcon.appiconset
// 見本と同じ Klee One SemiBold で製品名の「導」を描き、light / dark / tinted の3種を書き出す。
// 第2引数で字を差し替えられる（例: swift Tools/make-appicon.swift <out> し）。

import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let size: CGFloat = 1024
let fontURL = URL(fileURLWithPath: "Shirube/Resources/Fonts/KleeOne-SemiBold.ttf")
guard CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil) else {
    fatalError("font register failed")
}

struct RGB { let r: CGFloat, g: CGFloat, b: CGFloat }
func c(_ hex: UInt32) -> RGB {
    RGB(r: CGFloat((hex >> 16) & 0xff) / 255,
        g: CGFloat((hex >> 8) & 0xff) / 255,
        b: CGFloat(hex & 0xff) / 255)
}

enum Variant: String {
    case light, dark, tinted

    var paperTop: RGB {
        switch self {
        case .light: return c(0xFBF6EA)
        case .dark: return c(0x201D1A)
        case .tinted: return c(0x000000)
        }
    }
    var paperBottom: RGB {
        switch self {
        case .light: return c(0xF0E6D2)
        case .dark: return c(0x141210)
        case .tinted: return c(0x000000)
        }
    }
    var ink: RGB {
        switch self {
        case .light: return c(0x231F1C)
        case .dark: return c(0xF3EDE1)
        case .tinted: return c(0xFFFFFF)
        }
    }
    var guideColor: RGB {
        switch self {
        case .light: return c(0xC0392B)
        case .dark: return c(0xD9705F)
        case .tinted: return c(0xFFFFFF)
        }
    }
    var guideAlpha: CGFloat { self == .tinted ? 0.22 : 0.24 }
    var frameAlpha: CGFloat { self == .tinted ? 0.26 : 0.32 }
}

func render(_ v: Variant) -> CGImage {
    let cs = CGColorSpaceCreateDeviceRGB()
    let ctx = CGContext(data: nil, width: Int(size), height: Int(size),
                        bitsPerComponent: 8, bytesPerRow: 0, space: cs,
                        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    ctx.setAllowsAntialiasing(true)
    ctx.interpolationQuality = .high

    func color(_ p: RGB, _ a: CGFloat = 1) -> CGColor {
        CGColor(colorSpace: cs, components: [p.r, p.g, p.b, a])!
    }

    // 和紙のような紙面。ごく浅い縦グラデーションで平板さを避ける
    let grad = CGGradient(colorsSpace: cs,
                          colors: [color(v.paperTop), color(v.paperBottom)] as CFArray,
                          locations: [0, 1])!
    ctx.drawLinearGradient(grad, start: CGPoint(x: 0, y: size),
                           end: CGPoint(x: 0, y: 0), options: [])

    // マス目枠（半紙のマス）
    let inset: CGFloat = 128
    let frame = CGRect(x: inset, y: inset, width: size - inset * 2, height: size - inset * 2)
    ctx.setStrokeColor(color(v.guideColor, v.frameAlpha))
    ctx.setLineWidth(12)
    ctx.stroke(frame)

    // 十字ガイド（アプリ内のガイドと同じ発想の破線）
    ctx.saveGState()
    ctx.setStrokeColor(color(v.guideColor, v.guideAlpha))
    ctx.setLineWidth(10)
    ctx.setLineDash(phase: 0, lengths: [38, 30])
    ctx.move(to: CGPoint(x: frame.minX, y: size / 2))
    ctx.addLine(to: CGPoint(x: frame.maxX, y: size / 2))
    ctx.move(to: CGPoint(x: size / 2, y: frame.minY))
    ctx.addLine(to: CGPoint(x: size / 2, y: frame.maxY))
    ctx.strokePath()
    ctx.restoreGState()

    // 製品名の字 — Klee One SemiBold。見本と同じ書体で統一する
    let glyphFont = CTFontCreateWithName("KleeOne-SemiBold" as CFString, 512, nil)
    let path = CGMutablePath()
    let attributed = CFAttributedStringCreate(
        nil, glyph as CFString, [kCTFontAttributeName: glyphFont] as CFDictionary)!
    let line = CTLineCreateWithAttributedString(attributed)
    for run in CTLineGetGlyphRuns(line) as! [CTRun] {
        let count = CTRunGetGlyphCount(run)
        var glyphs = [CGGlyph](repeating: 0, count: count)
        var positions = [CGPoint](repeating: .zero, count: count)
        CTRunGetGlyphs(run, CFRangeMake(0, count), &glyphs)
        CTRunGetPositions(run, CFRangeMake(0, count), &positions)
        for i in 0..<count {
            guard let gp = CTFontCreatePathForGlyph(glyphFont, glyphs[i], nil) else { continue }
            let move = CGAffineTransform(translationX: positions[i].x, y: positions[i].y)
            path.addPath(gp, transform: move)
        }
    }

    // 実際の字面でマス目に対して中央に据える
    let box = path.boundingBoxOfPath
    let target: CGFloat = 660
    let scale = target / max(box.width, box.height)
    var fit = CGAffineTransform.identity
        .translatedBy(x: size / 2, y: size / 2)
        .scaledBy(x: scale, y: scale)
        .translatedBy(x: -box.midX, y: -box.midY)
    ctx.addPath(path.copy(using: &fit)!)
    ctx.setFillColor(color(v.ink))
    ctx.fillPath()

    return ctx.makeImage()!
}

func write(_ image: CGImage, to path: String) {
    let url = URL(fileURLWithPath: path)
    let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(dest, image, nil)
    guard CGImageDestinationFinalize(dest) else { fatalError("write failed: \(path)") }
}

let outDir = CommandLine.arguments[1]
let glyph = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "導"
for v in [Variant.light, .dark, .tinted] {
    write(render(v), to: "\(outDir)/AppIcon-\(v.rawValue).png")
}
print("done")
