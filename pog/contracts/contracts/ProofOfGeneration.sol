// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ProofOfGeneration is ERC721URIStorage, Ownable {
    struct PoGMeta {
        bytes32 promptHash;
        string modelId;
        uint256 createdAt;
        address minter;
    }

    uint256 private _nextId = 1;
    mapping(uint256 => PoGMeta) private _metas;

    event Minted(uint256 indexed tokenId, address indexed to, bytes32 promptHash, string modelId, string tokenURI);

    constructor(address initialOwner) ERC721("ProofOfGeneration", "POG") Ownable(initialOwner) {}

    function mint(address to, string calldata tokenURI_, bytes32 promptHash, string calldata modelId)
        external
        returns (uint256 tokenId)
    {
        tokenId = _nextId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI_);
        _metas[tokenId] = PoGMeta({promptHash: promptHash, modelId: modelId, createdAt: block.timestamp, minter: msg.sender});
        emit Minted(tokenId, to, promptHash, modelId, tokenURI_);
    }

    function viewToken(uint256 tokenId)
        external
        view
        returns (bytes32 promptHash, string memory modelId, uint256 createdAt, address minter, string memory tokenURI_)
    {
        require(_ownerOf(tokenId) != address(0), "POG: nonexistent token");
        PoGMeta memory p = _metas[tokenId];
        return (p.promptHash, p.modelId, p.createdAt, p.minter, tokenURI(tokenId));
    }
}
