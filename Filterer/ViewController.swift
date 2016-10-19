//
//  ViewController.swift
//  Filterer
//
//  Created by Weyland Joyner on 10/17/16.
//  Copyright © 2016 madlab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var imageToggle: UIButton!
    
    @IBAction func onImageToggle(sender: UIButton) {
        let image = UIImage(named: "lena")
        if imageToggle.selected {
            imageView.image = image
            imageToggle.selected = false
        } else {
            imageView.image = filteredImage
            imageToggle.selected = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("start")
        
        let image = UIImage(named: "lena")!
        print("set image")
        var myRGBA = RGBAImage(image: image)!
        print("myRGBA")
        
        func grayScale(var image: RGBAImage) -> RGBAImage {
            print("ggg")
            for y in 0..<image.height {
                for x in 0..<image.width {
                    let index = y * image.width + x
                    var pixel = image.pixels[index]
                    let avg = Int(pixel.red) + Int(pixel.green) + Int(pixel.blue) / 3
                    pixel.red = UInt8(max(0, min(255, avg)))
                    pixel.green = UInt8(max(0, min(255, avg)))
                    pixel.blue = UInt8(max (0, min(255, avg)))
                    image.pixels[index] = pixel
                }
            }
            return image
        }
        
        func kernel(var image: RGBAImage, x: Int, y: Int) -> () {
            let index = y * image.width + x
            let left = y * image.width + x - 1
            let right = y * image.width + x + 1
            let top = (y + 1) * image.width + x
            let bottom = (y - 1) * image.width + x
            let tl = (y + 1) * image.width + x - 1
            let tr = (y + 1) * image.width + x + 1
            let bl = (y - 1) * image.width + x - 1
            let br = (y - 1) * image.width + x + 1
            var sum = 0
            for x in [tl, top, tr, left, index, right, bl, bottom, br] {
                if image.pixels.indices.contains(x) {
                    // r,g,b all the same. this is grayscale
                    sum += Int(image.pixels[x].red)
                }
            }
            let avg = sum / 9
            image.pixels[index].red = UInt8(max(0, min(255, avg)))
            image.pixels[index].green = UInt8(max(0, min(255, avg)))
            image.pixels[index].blue = UInt8(max(0, min(255, avg)))
        }

        var convolutions = 0
        func convolve(var image: RGBAImage) -> RGBAImage {
            convolutions += 1
            print("conv", convolutions)
            for y in 0..<image.height {
                print("y", y)
                for x in 0..<image.width {
                    kernel(image, x: x, y: y)
                }
                print("done y", y)
            }
            return image
        }
        
        let newRGBA = grayScale(myRGBA)
        print("grayscale")
        let blurredRGBA = convolve(newRGBA)
        print("convolve")
        filteredImage = blurredRGBA.toUIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

