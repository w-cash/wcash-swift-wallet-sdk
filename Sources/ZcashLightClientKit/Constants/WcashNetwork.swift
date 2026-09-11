//
//  WcashNetwork.swift
//  ZcashLightClientKit
//

import Foundation

/// Immutable identity metadata for a Wcash network whose consensus values are frozen.
///
/// Only public Testnet and process-local Regtest are represented. Wcash Mainnet is deliberately
/// absent until its genesis block and transaction-signature domain have been finalized and
/// independently reviewed.
///
/// This metadata does not make the Zcash synchronizer or its Rust backend Wcash-aware. In
/// particular, a ``WcashNetwork`` must never be translated into a ``NetworkType``: those values
/// currently select Zcash consensus parameters in the native backend.
public enum WcashNetwork: String, CaseIterable, Codable, Hashable, Sendable {
    /// Public Wcash Testnet v5.
    case testnet

    /// Process-local Wcash Regtest v5.
    case regtest

    /// Exact name accepted by the Wcash node's network configuration.
    public var nodeNetworkName: String {
        switch self {
        case .testnet: return "WcashTestnet"
        case .regtest: return "WcashRegtest"
        }
    }

    /// Chain name currently reported by the Wcash compact-block server.
    ///
    /// Both networks currently report the inherited BIP-70 testing-chain name. Native wallet
    /// integration must therefore attest ``genesisBlockHash`` and ``consensusBranchID`` before
    /// trusting or persisting server data; this value alone is not a Wcash chain discriminator.
    public var compactServerChainName: String { "test" }

    /// Stable, versioned prefix applications must use for per-chain wallet and cache storage.
    ///
    /// The node rotates this namespace whenever pre-launch consensus changes, preventing an
    /// updated client from trusting state indexed under an incompatible prototype.
    public var storageNamespace: String {
        switch self {
        case .testnet: return "wcashtestnet-v5"
        case .regtest: return "wcashregtest-v5"
        }
    }

    /// Ticker for valueless funds on Wcash testing networks.
    public var currencyTicker: String { "TWC" }

    /// Frozen genesis block hash in display order.
    public var genesisBlockHash: String {
        switch self {
        case .testnet:
            return "0271b5b0a10b2838f43cccdec9ca2f72aa72a7c103830082bac8f82f47f0593a"
        case .regtest:
            return "70bf0bab17eff361a6331bb825b3b7253c8c96ff96407f948161d2912658bb1c"
        }
    }

    /// Consensus branch ID for Wcash V6 transactions.
    public var consensusBranchID: ConsensusBranchID {
        switch self {
        case .testnet: return Int32(bitPattern: 0xb3cf_d27e)
        case .regtest: return Int32(bitPattern: 0xc3a6_678a)
        }
    }

    /// Consensus branch ID in the eight-character hexadecimal form reported by the server.
    public var consensusBranchIDHex: String {
        String(format: "%08x", UInt32(bitPattern: consensusBranchID))
    }

    /// Height at which Wcash's Ironwood-only transaction rules activate.
    public var ironwoodActivationHeight: BlockHeight { 1 }

    /// Human-readable prefix for Wcash Unified Addresses.
    public var unifiedAddressHRP: String {
        switch self {
        case .testnet: return "wutest"
        case .regtest: return "wuregtest"
        }
    }

    /// Human-readable prefix for Wcash transparent-source-only addresses.
    public var texAddressHRP: String {
        switch self {
        case .testnet: return "wtextest"
        case .regtest: return "wtexregtest"
        }
    }

    /// Two-byte P2PKH Base58Check version in display-order hexadecimal.
    public var transparentP2PKHVersionHex: String {
        switch self {
        case .testnet: return "1095"
        case .regtest: return "1090"
        }
    }

    /// Two-byte P2SH Base58Check version in display-order hexadecimal.
    public var transparentP2SHVersionHex: String {
        switch self {
        case .testnet: return "1098"
        case .regtest: return "1093"
        }
    }
}
