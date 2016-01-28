//: [Previous](@previous)

//: ## Setting Filter Parameters

import UIKit
import CoreImage

let cropRect = CGRect(origin: CGPointZero,
    size: CGSize(width: 200, height: 200))

//: ### `CIColor` - Core Image Color

let inputColor0 = CIColor(red: 1, green: 1, blue: 0)
let inputColor1 = CIColor(color: UIColor.purpleColor())

let gradientFilter = CIFilter(name: "CILinearGradient",
    withInputParameters: ["inputColor0": inputColor0,
        "inputColor1": inputColor1])!


let gradientImage = gradientFilter.outputImage?
    .imageByCroppingToRect(cropRect)

//: ### `CIImage` - Core Image Image

let redImage = CIImage(color: CIColor(red: 1, green: 0, blue: 0))
    .imageByCroppingToRect(cropRect)

let sunflowerImage = CIImage(image: UIImage(named: "sunflower.jpg")!)!

//: Filtering an image

let tonalFilter = CIFilter(name: "CIPhotoEffectTonal",
    withInputParameters: [kCIInputImageKey: sunflowerImage])

let tonalImage = tonalFilter?.outputImage

//: Chaining two filters

let blurFilter = CIFilter(name: "CIGaussianBlur",
    withInputParameters: [kCIInputImageKey: sunflowerImage])!

let monochrome = CIFilter(name: "CIColorMonochrome",
    withInputParameters: [kCIInputImageKey: blurFilter.outputImage!])

let monochromeImage = monochrome?.outputImage

//: ### `CIVector` - Core Image Vector

CIVector(CGPoint: CGPoint(x: 10, y: 10))

CIVector(CGRect: CGRect(x: 10,
    y: 10,
    width: 100,
    height: 100))

let convolutionFilter = CIFilter(name: "CIConvolution5X5")!
let weightsAttribute = convolutionFilter.attributes[kCIInputWeightsKey]
    as! [String : AnyObject]

let defaultValue = weightsAttribute[kCIAttributeDefault]
    as! CIVector

let newValues = [CGFloat](count: defaultValue.count,
    repeatedValue: 0.0)
let newVector = CIVector(values: newValues,
    count: newValues.count)

convolutionFilter.setValue(newVector,
    forKey: kCIInputWeightsKey)

//: ### `NSNumber` - Numeric Types

let width: Int = 25
let angle: Double = M_PI
let sharpness: UInt = 16
let gcr: Float = 2.6
let ucr: CGFloat = 5.4

let cmykHalftoneFilter = CIFilter(name: "CICMYKHalftone",
    withInputParameters: [kCIInputWidthKey: width,
        kCIInputAngleKey: angle,
        kCIInputSharpnessKey: sharpness,
        "inputGCR": gcr,
        "inputUCR": ucr])!

//: ### `NSData` - Data Objects

//: Barcode

let message = "Core Image for Swift"

let data = message.dataUsingEncoding(NSASCIIStringEncoding)!

let barcodeGeneratorFilter = CIFilter(name: "CICode128BarcodeGenerator",
    withInputParameters: ["inputMessage": data])!

let barcodeImage = barcodeGeneratorFilter.outputImage!

//: Color Cube

let cubeArray: [Double] = [
    0.7, 0.5, 1.0, 0.6,
    0.0, 1.0, 0.0, 1.0,
    0.9, 0.6, 0.8, 0.2,
    1.0, 0.4, 0.0, 1.0]

let cubeData = NSData(bytes: cubeArray,
    length: sizeof(Double) * cubeArray.count)

let colorCubeFilter = CIFilter(name: "CIColorCube",
    withInputParameters: [kCIInputImageKey: sunflowerImage,
        "inputCubeData": cubeData])!

let colorCubeImage = colorCubeFilter.outputImage

//: ### `NSObject` - Data Objects

let colorSpace = CGColorSpaceCreateDeviceRGB()!

let colorCubeWithColorSpace = CIFilter(name: "CIColorCubeWithColorSpace",
    withInputParameters: [kCIInputImageKey: sunflowerImage,
        "inputColorSpace": colorSpace])


//: ### `NSString` - Strings

let codeGenerator_L = CIFilter(name: "CIQRCodeGenerator",
    withInputParameters: [
        "inputMessage": data,
        "inputCorrectionLevel": "L"])!

let codeGenerator_L_image = codeGenerator_L.outputImage

let codeGenerator_H = CIFilter(name: "CIQRCodeGenerator",
    withInputParameters: [
        "inputMessage": data,
        "inputCorrectionLevel": "H"])!

let codeGenerator_H_image = codeGenerator_H.outputImage


//: [Next](@next)
