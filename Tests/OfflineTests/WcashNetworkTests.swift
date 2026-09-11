//
//  WcashNetworkTests.swift
//  ZcashLightClientKit
//

import XCTest
@testable import ZcashLightClientKit

final class WcashNetworkTests: XCTestCase {
    func testOnlyFrozenNonMainnetNetworksAreExposed() {
        XCTAssertEqual(WcashNetwork.allCases, [.testnet, .regtest])
        XCTAssertNil(WcashNetwork(rawValue: "mainnet"))
    }

    func testTestnetIdentityMatchesWcashNode() {
        let network = WcashNetwork.testnet

        XCTAssertEqual(network.nodeNetworkName, "WcashTestnet")
        XCTAssertEqual(network.compactServerChainName, "test")
        XCTAssertEqual(network.storageNamespace, "wcashtestnet-v5")
        XCTAssertEqual(network.currencyTicker, "TWC")
        XCTAssertEqual(
            network.genesisBlockHash,
            "0271b5b0a10b2838f43cccdec9ca2f72aa72a7c103830082bac8f82f47f0593a"
        )
        XCTAssertEqual(network.consensusBranchID, Int32(bitPattern: 0xb3cf_d27e))
        XCTAssertEqual(network.consensusBranchIDHex, "b3cfd27e")
        XCTAssertEqual(network.ironwoodActivationHeight, 1)
        XCTAssertEqual(network.unifiedAddressHRP, "wutest")
        XCTAssertEqual(network.texAddressHRP, "wtextest")
        XCTAssertEqual(network.transparentP2PKHVersionHex, "1095")
        XCTAssertEqual(network.transparentP2SHVersionHex, "1098")
    }

    func testRegtestIdentityMatchesWcashNode() {
        let network = WcashNetwork.regtest

        XCTAssertEqual(network.nodeNetworkName, "WcashRegtest")
        XCTAssertEqual(network.compactServerChainName, "test")
        XCTAssertEqual(network.storageNamespace, "wcashregtest-v5")
        XCTAssertEqual(network.currencyTicker, "TWC")
        XCTAssertEqual(
            network.genesisBlockHash,
            "70bf0bab17eff361a6331bb825b3b7253c8c96ff96407f948161d2912658bb1c"
        )
        XCTAssertEqual(network.consensusBranchID, Int32(bitPattern: 0xc3a6_678a))
        XCTAssertEqual(network.consensusBranchIDHex, "c3a6678a")
        XCTAssertEqual(network.ironwoodActivationHeight, 1)
        XCTAssertEqual(network.unifiedAddressHRP, "wuregtest")
        XCTAssertEqual(network.texAddressHRP, "wtexregtest")
        XCTAssertEqual(network.transparentP2PKHVersionHex, "1090")
        XCTAssertEqual(network.transparentP2SHVersionHex, "1093")
    }

    func testSupportedNetworksHaveDisjointConsensusAndAddressIdentity() {
        let testnet = WcashNetwork.testnet
        let regtest = WcashNetwork.regtest

        XCTAssertNotEqual(testnet.nodeNetworkName, regtest.nodeNetworkName)
        XCTAssertNotEqual(testnet.storageNamespace, regtest.storageNamespace)
        XCTAssertNotEqual(testnet.genesisBlockHash, regtest.genesisBlockHash)
        XCTAssertNotEqual(testnet.consensusBranchID, regtest.consensusBranchID)
        XCTAssertNotEqual(testnet.unifiedAddressHRP, regtest.unifiedAddressHRP)
        XCTAssertNotEqual(testnet.texAddressHRP, regtest.texAddressHRP)
        XCTAssertNotEqual(testnet.transparentP2PKHVersionHex, regtest.transparentP2PKHVersionHex)
        XCTAssertNotEqual(testnet.transparentP2SHVersionHex, regtest.transparentP2SHVersionHex)
    }

    func testWcashAddressNamespacesDoNotOverlapZcash() {
        let zcashUnifiedAddressHRPs = ["u", "utest", "uregtest"]
        let zcashTexAddressHRPs = ["tex", "textest", "texregtest"]
        let zcashTransparentVersions = ["1cb8", "1cbd", "1d25", "1cba"]

        for network in WcashNetwork.allCases {
            XCTAssertNotEqual(network.consensusBranchID, ZcashSDK.nu63ConsensusBranchID)
            XCTAssertFalse(zcashUnifiedAddressHRPs.contains(network.unifiedAddressHRP))
            XCTAssertFalse(zcashTexAddressHRPs.contains(network.texAddressHRP))
            XCTAssertFalse(zcashTransparentVersions.contains(network.transparentP2PKHVersionHex))
            XCTAssertFalse(zcashTransparentVersions.contains(network.transparentP2SHVersionHex))
        }
    }

    func testInheritedCompactServerNameIsNotTreatedAsChainIdentity() {
        XCTAssertEqual(WcashNetwork.testnet.compactServerChainName, WcashNetwork.regtest.compactServerChainName)
        XCTAssertNotEqual(WcashNetwork.testnet.genesisBlockHash, WcashNetwork.regtest.genesisBlockHash)
        XCTAssertNotEqual(WcashNetwork.testnet.consensusBranchID, WcashNetwork.regtest.consensusBranchID)
    }
}
