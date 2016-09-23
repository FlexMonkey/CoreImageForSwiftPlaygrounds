//: [Previous](@previous)

//: # Core Image for Swift

//: ##  Color Map Filter

import UIKit
import CoreImage

//: ### Introduction

let monaLisa = CIImage(image: UIImage(named: "monalisa.jpg")!)!
let blueYellowWhite = CIImage(image: UIImage(named: "blueYellowWhite.png")!)!

let final = monaLisa.applyingFilter("CIColorMap",
    withInputParameters: [kCIInputGradientImageKey: blueYellowWhite])

//: ### Creating a Color Map

let window = CIImage(image: UIImage(named: "window.jpg")!)!

struct RGB
{
    let a:UInt8 = 255
    let r:UInt8
    let g:UInt8
    let b:UInt8
    
    init(r: UInt8, g: UInt8, b: UInt8)
    {
        self.r = r
        self.g = g
        self.b = b
    }
    
    var luma: UInt8
        {
            return UInt8((Double(r) * 0.2126) +
                (Double(g) * 0.7152) +
                (Double(b) * 0.0722))
    }
}

func colorMapGradientFromColors(colors:[RGB]) -> CIImage
{
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo:CGBitmapInfo = CGBitmapInfo(
        rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
    
    let bitsPerComponent = 8
    let bitsPerPixel = 32
    
    var sortedColors = colors
        .sorted(by: { $0.luma < $1.luma })
        .flatMap({ [RGB](repeating: $0, count: 16) })
    
    let width = sortedColors.count
    
    let dataProvider = CGDataProvider(
        data: NSData(bytes: &sortedColors,
            length: sortedColors.count * MemoryLayout<RGB>.size))
    
    let cgImage = CGImage(
        width: width,
        height: 1,
        bitsPerComponent: bitsPerComponent,
        bitsPerPixel: bitsPerPixel,
        bytesPerRow: width * MemoryLayout<RGB>.size,
        space: rgbColorSpace,
        bitmapInfo: bitmapInfo,
        provider: dataProvider!,
        decode: nil,
        shouldInterpolate: true,
        intent: .defaultIntent
    )
    
    return CIImage(cgImage: cgImage!)
}

let blueYellowWhiteColors = [
    RGB(r: 0, g: 0, b: 255),
    RGB(r: 255, g: 255, b: 0),
    RGB(r: 255, g: 255, b: 255)]

let blueYellowWhiteColorMap = colorMapGradientFromColors(colors: blueYellowWhiteColors)

let blueYellowWhiteWindow = window
    .applyingFilter("CIColorMap",
        withInputParameters: [
            kCIInputGradientImageKey: blueYellowWhiteColorMap])

//: ### Alternative Mapping Palettes

func eightBitFromColorPalette(sourceImage: CIImage,
    colors: [RGB]) -> CIImage
{
    let colorMapGradient = colorMapGradientFromColors(colors: colors)
    
    return sourceImage
        .applyingFilter("CIPixellate",
            withInputParameters: nil)
        .applyingFilter("CIColorMap",withInputParameters: [
            kCIInputGradientImageKey: colorMapGradient])
}

//: #### ZX Spectrum Dim

let dimSpectrumColors = [
    RGB(r: 0x00, g: 0x00, b: 0x00),
    RGB(r: 0x00, g: 0x00, b: 0xCD),
    RGB(r: 0xCD, g: 0x00, b: 0x00),
    RGB(r: 0xCD, g: 0x00, b: 0xCD),
    RGB(r: 0x00, g: 0xCD, b: 0x00),
    RGB(r: 0x00, g: 0xCD, b: 0xCD),
    RGB(r: 0xCD, g: 0xCD, b: 0x00),
    RGB(r: 0xCD, g: 0xCD, b: 0xCD)]

let spectrumDim = eightBitFromColorPalette(sourceImage: monaLisa, colors: dimSpectrumColors)

//: #### ZX Spectrum Bright

let brightSpectrumColors = [
    RGB(r: 0x00, g: 0x00, b: 0x00),
    RGB(r: 0x00, g: 0x00, b: 0xFF),
    RGB(r: 0xFF, g: 0x00, b: 0x00),
    RGB(r: 0xFF, g: 0x00, b: 0xFF),
    RGB(r: 0x00, g: 0xFF, b: 0x00),
    RGB(r: 0x00, g: 0xFF, b: 0xFF),
    RGB(r: 0xFF, g: 0xFF, b: 0x00),
    RGB(r: 0xFF, g: 0xFF, b: 0xFF)]

let spectrumBright = eightBitFromColorPalette(sourceImage: monaLisa, colors: brightSpectrumColors)

//: #### VIC-20
let vic20Colors = [
    RGB(r: 0, g: 0, b: 0),
    RGB(r: 255, g: 255, b: 255),
    RGB(r: 141, g: 62, b: 55),
    RGB(r: 114, g: 193, b: 200),
    RGB(r: 128, g: 52, b: 139),
    RGB(r: 85, g: 160, b: 73),
    RGB(r: 64, g: 49, b: 141),
    RGB(r: 170, g: 185, b: 93),
    RGB(r: 139, g: 84, b: 41),
    RGB(r: 213, g: 159, b: 116),
    RGB(r: 184, g: 105, b: 98),
    RGB(r: 135, g: 214, b: 221),
    RGB(r: 170, g: 95, b: 182),
    RGB(r: 148, g: 224, b: 137),
    RGB(r: 128, g: 113, b: 204),
    RGB(r: 191, g: 206, b: 114)
]

let vic20 = eightBitFromColorPalette(sourceImage: monaLisa, colors: vic20Colors)

//: #### C-64

let c64Colors = [
    RGB(r: 0, g: 0, b: 0),
    RGB(r: 255, g: 255, b: 255),
    RGB(r: 136, g: 57, b: 50),
    RGB(r: 103, g: 182, b: 189),
    RGB(r: 139, g: 63, b: 150),
    RGB(r: 85, g: 160, b: 73),
    RGB(r: 64, g: 49, b: 141),
    RGB(r: 191, g: 206, b: 114),
    RGB(r: 139, g: 84, b: 41),
    RGB(r: 87, g: 66, b: 0),
    RGB(r: 184, g: 105, b: 98),
    RGB(r: 80, g: 80, b: 80),
    RGB(r: 120, g: 120, b: 120),
    RGB(r: 148, g: 224, b: 137),
    RGB(r: 120, g: 105, b: 196),
    RGB(r: 159, g: 159, b: 159)
]

let c64 = eightBitFromColorPalette(sourceImage: monaLisa, colors: c64Colors)

//: #### Apple II
let appleIIColors = [
    RGB(r: 0, g: 0, b: 0),
    RGB(r: 114, g: 38, b: 64),
    RGB(r: 64, g: 51, b: 127),
    RGB(r: 228, g: 52, b: 254),
    RGB(r: 14, g: 89, b: 64),
    RGB(r: 128, g: 128, b: 128),
    RGB(r: 27, g: 154, b: 254),
    RGB(r: 191, g: 179, b: 255),
    RGB(r: 64, g: 76, b: 0),
    RGB(r: 228, g: 101, b: 1),
    RGB(r: 128, g: 128, b: 128),
    RGB(r: 241, g: 166, b: 191),
    RGB(r: 27, g: 203, b: 1),
    RGB(r: 191, g: 204, b: 128),
    RGB(r: 141, g: 217, b: 191),
    RGB(r: 255, g: 255, b: 255)
]

let appleII = eightBitFromColorPalette(sourceImage: monaLisa, colors: appleIIColors)

//: [Next](@next)
