//
//  EosioSwiftEccSignTests.swift
//  EosioSwiftEccTests

//  Created by Todd Bowden on 3/8/19
//  Copyright (c) 2018-2019 block.one
//


import Foundation

import XCTest
@testable import EosioSwiftEcc

class EosioSwiftEccsignTests: XCTestCase {
    
    let publicKeyHex = "04257784a3d0aceef73ea365ce01febaec1b671b971b9c9feb3f4901e7b773bd4366c7451a736e2921b3dfeefc2855e984d287d58a0dfb995045f339a0e8a2fd7a"
    let privateKeyHex = "c057a9462bc219abd32c6ca5c656cc8226555684d1ee8d53124da40330f656c1"
    
    let message = "Hello World".data(using: .utf8)!

    let recover = EccRecoverKey()
    let sign = EosioEccSign()
    
    
    func test_signWithK1() {
        do {
            let publicKey = try Data(hex: publicKeyHex)
            let privateKey = try Data(hex: privateKeyHex)
            for _ in 1...10 {
                let sig = try sign.signWithK1(publicKey: publicKey, privateKey: privateKey, data: message)
                guard sig.count == 65 else {
                    return XCTFail()
                }
                let derSig = EcdsaSignature(r: sig[1...32], s: sig[33...64]).der
                let recid = Int(sig[0] - 31)
                
                let recoveredPubKey = try recover.recoverPublicKey(signatureDer: derSig, message: message.sha256, recid: recid, curve: "K1")
                XCTAssertEqual(recoveredPubKey.hex, publicKeyHex)
            }
            
        } catch {
            XCTFail()
        }
        
    }
    
    
    
}
