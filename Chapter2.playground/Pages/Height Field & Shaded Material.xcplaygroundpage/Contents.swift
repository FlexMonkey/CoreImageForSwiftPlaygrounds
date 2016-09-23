//: [Previous](@previous)

//: ## Height Field & Shaded Material

import UIKit
import CoreImage

//: ### Height Field Filter

let coreImageForSwift = UIImage(named: "coreImageForSwift.png")!

let image = CIImage(image: coreImageForSwift)!

let colorInvert = CIFilter(name: "CIColorInvert",
    withInputParameters: [kCIInputImageKey: image])!

let maskToAlpha = CIFilter(name: "CIMaskToAlpha",
    withInputParameters: [
        kCIInputImageKey: colorInvert.outputImage!])!

let heightField = CIFilter(name: "CIHeightFieldFromMask",
    withInputParameters: [
        kCIInputImageKey: maskToAlpha.outputImage!])!

let heightFieldImage = heightField.outputImage!

//: ### Shaded Material Filter

let sphere = UIImage(named: "sphere.jpg")!

let shadingImage = CIImage(image: sphere)!

let shadedMaterial = CIFilter(name: "CIShadedMaterial",
    withInputParameters: [
        kCIInputImageKey: heightField.outputImage!,
        kCIInputShadingImageKey: shadingImage])!

let shadedImage = shadedMaterial.outputImage!

//: ### Alternatives for Height Field Source

//: `UILabel`

let label = UILabel(frame:
    CGRect(x: 0, y: 0, width: 640, height: 160))
label.text = "Core Image\nfor Swift"
label.font = UIFont.boldSystemFont(ofSize: 200)
label.adjustsFontSizeToFitWidth = true
label.numberOfLines = 2
label.textAlignment = .center

UIGraphicsBeginImageContextWithOptions(
    CGSize(width: label.frame.width,
        height: label.frame.height), false, 1)

label.layer.render(in: UIGraphicsGetCurrentContext()!)

let textImage = UIGraphicsGetImageFromCurrentImageContext()

UIGraphicsEndImageContext()

let labelColorInvert = CIFilter(name: "CIColorInvert",
    withInputParameters: [kCIInputImageKey: CIImage(image: textImage!)!])!

let labelMaskToAlpha = CIFilter(name: "CIMaskToAlpha",
    withInputParameters: [
        kCIInputImageKey: labelColorInvert.outputImage!])!

let labelHeightField = CIFilter(name: "CIHeightFieldFromMask",
    withInputParameters: [
        kCIInputImageKey: labelMaskToAlpha.outputImage!])!

let shadedLabelMaterial = CIFilter(name: "CIShadedMaterial",
    withInputParameters: [
        kCIInputImageKey: labelHeightField.outputImage!,
        kCIInputShadingImageKey: shadingImage])!

let shadedLabelImage = shadedLabelMaterial.outputImage!

//: Edge Work filter

let thisSideDown = CIImage(image: UIImage(named: "thisSideDown.png")!)!

let edgeWork = CIFilter(name: "CIEdgeWork",
    withInputParameters: [kCIInputImageKey: thisSideDown,
        kCIInputRadiusKey: 2])!

let edgeWorkImage = edgeWork.outputImage!

let thisSideDownHeightField = CIFilter(name: "CIHeightFieldFromMask",
    withInputParameters: [
        kCIInputImageKey: edgeWorkImage])!

let thisSideDownShadedMaterial = CIFilter(name: "CIShadedMaterial",
    withInputParameters: [
        kCIInputImageKey: thisSideDownHeightField.outputImage!,
        kCIInputShadingImageKey: shadingImage])!

let shadedThisSideDownImage = thisSideDownShadedMaterial.outputImage!

