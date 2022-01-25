//
//  GalleryPhotoViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol GalleryPhotoProtocolInput {
}

protocol GalleryPhotoProtocolOutput: class {
    var didFetchListImageSuccess: (() -> Void)? { get set }

}

protocol GalleryPhotoProtocol: GalleryPhotoProtocolInput, GalleryPhotoProtocolOutput {
    var input: GalleryPhotoProtocolInput { get }
    var output: GalleryPhotoProtocolOutput { get }
}

class GalleryPhotoViewModel: GalleryPhotoProtocol, GalleryPhotoProtocolOutput {
    
    var input: GalleryPhotoProtocolInput { return self }
    var output: GalleryPhotoProtocolOutput { return self }
    
    // MARK: - Properties
    private var vc: GalleryPhotoViewController
    
    //ImageStation
    public var listImageStation: [String] = []
    
    init(
        vc: GalleryPhotoViewController
    ) {
        self.vc = vc
    }
    
    // MARK - Data-binding OutPut
    var didFetchListImageSuccess: (() -> Void)?
    
}
