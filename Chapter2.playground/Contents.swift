//: # Core Image for Swift

import UIKit
import CoreImage

//: ##  Querying Core Image for Filters

//: ### Filter Categories

kCICategoryHalftoneEffect

CIFilter.localizedNameForCategory(kCICategoryHalftoneEffect)

//: ### Querying for Filters

CIFilter.filterNamesInCategory(kCICategoryHalftoneEffect)

CIFilter.filterNamesInCategories(nil)

CIFilter.filterNamesInCategories([kCICategoryVideo,
    kCICategoryStillImage])

CIFilter.filterNamesInCategories([kCICategoryBlur,
    kCICategorySharpen])

//: ### Using the Filter Name

CIFilter.localizedNameForFilterName("CICMYKHalftone")

CIFilter.localizedDescriptionForFilterName("CICMYKHalftone")

CIFilter(name: "xyz")

CIFilter(name: "CICMYKHalftone")

//: ### Interrogating the Filter

let filter = CIFilter(name: "CICMYKHalftone")!
let inputKeys = filter.inputKeys

filter.attributes.filter({ !inputKeys.contains($0.0) })

filter.attributes.filter({ inputKeys.contains($0.0) })

if let
    attribute = filter
        .attributes["inputGCR"] as? [String: AnyObject],
    minimum = attribute[kCIAttributeSliderMin] as? Float,
    maximum = attribute[kCIAttributeSliderMax] as? Float,
    defaultValue = attribute[kCIAttributeDefault] as? Float where
    (attribute[kCIAttributeClass] as? String) == "NSNumber"
{
    let slider = UISlider()
    
    slider.minimumValue = minimum
    slider.maximumValue = maximum
    slider.value = defaultValue
}

Set<String>(CIFilter.filterNamesInCategory(nil).flatMap {
    CIFilter(name: $0)!
        .attributes[kCIAttributeFilterCategories] as! [String]
    }).sort()


//: ## Creating & Applying Filters

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




