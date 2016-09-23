//: ## Barrel Distortion Warp Filter

import UIKit
import CoreImage

//: ### Warp Kernel

class CRTWarpFilter: CIFilter
{
    var inputImage : CIImage?
    var bend: CGFloat = 3.2
    
    let crtWarpKernel = CIWarpKernel(string:
        "kernel vec2 crtWarp(vec2 extent, float bend)" +
            "{" +
            "   vec2 coord = ((destCoord() / extent) - 0.5) * 2.0;" +
            
            "   coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);" +
            "   coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);" +
            
            "   coord  = ((coord / 2.0) + 0.5) * extent;" +
            
            "   return coord;" +
        "}"
    )
    
    override var outputImage : CIImage!
        {
            if let inputImage = inputImage,
                let crtWarpKernel = crtWarpKernel
            {
                let arguments = [CIVector(x: inputImage.extent.size.width, y: inputImage.extent.size.height), bend] as [Any]
                let extent = inputImage.extent
                
                return crtWarpKernel.apply(withExtent: extent,
                    roiCallback:
                    {
                        (index, rect) in
         
                        return rect
                    },
                    inputImage: inputImage,
                    arguments: arguments)
            }
            return nil
    }
}

let ciContext = CIContext()

func imageFromCIImage(source: CIImage) -> UIImage
{
    let cgImage = ciContext.createCGImage(source,
                                          from: source.extent)
    
    return UIImage(cgImage: cgImage!)
}

//: ### Swift Implementation of barrel warp kernel

//: `x` and `y` are pixel coordinates
let x = 65.0
let y = 55.0

//: `width` and `height` are extent
let width = 900.0
let height = 300.0

//: `crtWarpKernel` mechanics in Swift
var coordX = ((x / width) - 0.5) * 2.0
var coordY = ((y / height) - 0.5) * 2.0

coordX *= 1 + pow((abs(coordY) / 3.2), 2.0)
coordY *= 1 + pow((abs(coordX) / 3.2), 2.0)

coordX  = ((coordX / 2.0) + 0.5) * width
coordY  = ((coordY / 2.0) + 0.5) * height

// ---- 

let backgroundImage = CIFilter(name: "CICheckerboardGenerator",
    withInputParameters: [
        "inputColor0": CIColor(red: 0.1, green: 0.1, blue: 0.1),
        "inputColor1": CIColor(red: 0.15, green: 0.15, blue: 0.15),
        "inputCenter": CIVector(x: 0, y: 0),
        "inputWidth": 50])!
    .outputImage!.cropping(to: CGRect(x: 1, y: 1, width: width - 2, height: height - 2))
    .compositingOverImage(CIImage(color: CIColor(red: 0, green: 0, blue: 0)))
    .cropping(to: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))

let blueBox = CIImage(color: CIColor(red: 0.5, green: 0.5, blue: 1, alpha: 0.7))
    .cropping(
        to: CGRect(origin: CGPoint(x: coordX - 5, y: coordY - 5), size: CGSize(width: 10, height: 10)))

let redBox = CIImage(color: CIColor(red: 1, green: 0, blue: 0, alpha: 0.7))
    .cropping(
        to: CGRect(origin: CGPoint(x: x - 5, y: y - 5), size: CGSize(width: 10, height: 10)))

let warpFilter = CRTWarpFilter()

warpFilter.inputImage = backgroundImage

let composite = CIFilter(name: "CIAdditionCompositing",
        withInputParameters: [
            kCIInputBackgroundImageKey: warpFilter.outputImage,
            kCIInputImageKey: blueBox])!
    .outputImage!
    .applyingFilter("CIAdditionCompositing",
        withInputParameters: [kCIInputBackgroundImageKey: redBox])

let result = composite






