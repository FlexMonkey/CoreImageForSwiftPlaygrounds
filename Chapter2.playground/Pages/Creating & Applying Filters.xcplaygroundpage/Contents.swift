//: [Previous](@previous)

//: ## Creating & Applying Filters

import UIKit
import CoreImage

//: ### Executing Filters

let carMascot = CIImage(image: UIImage(named: "carmascot.jpg")!)!

//: Setting parameters in constuctor

let bloomFilteOne = CIFilter(name: "CIBloom",
    withInputParameters: [
        kCIInputRadiusKey: 8,
        kCIInputIntensityKey: 1.25,
        kCIInputImageKey: carMascot])!

//: Setting parameters after creating using `setValue()`

let bloomFilterTwo = CIFilter(name: "CIBloom")!

bloomFilterTwo.setValue(8, forKey: kCIInputRadiusKey)
bloomFilterTwo.setValue(1.25, forKey: kCIInputIntensityKey)
bloomFilterTwo.setValue(carMascot, forKey: kCIInputImageKey)

//: Final image using `outputImage`

let finalImageOne = bloomFilteOne.outputImage!

//: Final image using `valueForKey()`

let finalImageTwo = bloomFilteOne
    .valueForKey(kCIOutputImageKey) as! CIImage

//: Final image using `imageByApplyingFilter()`

let finalImageThree = carMascot.imageByApplyingFilter("CIBloom",
    withInputParameters: [
        kCIInputRadiusKey: 8,
        kCIInputIntensityKey: 1.25
    ])

//: ### Chaining Filters

//: Setting parameters in constuctor

let noirFilterOne = CIFilter(name: "CIPhotoEffectNoir",
    withInputParameters: [kCIInputImageKey: finalImageOne])!

//: Setting parameters after creating using `setValue()`

let noirFilter = CIFilter(name: "CIPhotoEffectNoir")!

noirFilter.setValue(finalImageOne, forKey: kCIInputImageKey)

//: Final image using `outputImage`

let finalNoirImageOne = noirFilter.outputImage!

//: Final image using `imageByApplyingFilter()`

let finalNoirImageTwo = carMascot
    .imageByApplyingFilter("CIBloom",
        withInputParameters: [
            kCIInputRadiusKey: 8,
            kCIInputIntensityKey: 1.25])
    .imageByApplyingFilter("CIPhotoEffectNoir",
        withInputParameters: nil)

//: ### Composite & Blend Filters

let stripesImage = CIFilter(name: "CIStripesGenerator")!
    .outputImage!
    .imageByCroppingToRect(carMascot.extent)

let negativeImage = carMascot
    .imageByApplyingFilter("CIColorInvert",
        withInputParameters: nil)

//: Final composite using `setValue`

let compositeFilter = CIFilter(name: "CIBlendWithMask")!

compositeFilter.setValue(carMascot,
    forKey: kCIInputImageKey)
compositeFilter.setValue(negativeImage,
    forKey: kCIInputBackgroundImageKey)
compositeFilter.setValue(stripesImage,
    forKey: kCIInputMaskImageKey)

let compositeImageOne = compositeFilter.outputImage!

//: Final composite using `imageByApplyingFilter()`

let compositeImageTwo = carMascot
    .imageByApplyingFilter("CIBlendWithMask",
        withInputParameters: [
            kCIInputBackgroundImageKey: negativeImage,
            kCIInputMaskImageKey: stripesImage])


//: [Next](@next)
