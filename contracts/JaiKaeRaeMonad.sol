// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract JaiKaeRae is ERC721A, Ownable {

    // config
    constructor(address initialOwner) ERC721A("Jai Kae Rae", "JKR") Ownable(initialOwner) {}
    uint256 public MAX_MINT_PER_WALLET = 1;
    uint256 public START_ID = 1;
    string public baseURI = "https://jigsaw-fam.github.io/jkr/assets/monad.png";

    // start token id
    function _startTokenId() internal view virtual override returns (uint256) {
        return START_ID;
    }

    // metadata
    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory jsonPreImage = string.concat(
            string.concat(
                string.concat('{"name": "Jai Kae Rae Monad Edition #', Strings.toString(tokenId)),
                '","description":"I\'m a little boy, flow on a wild world.","image":"'
            ),
            baseURI
        );
        string memory jsonPostImage = '"}';
        return
            string.concat(
                "data:application/json;utf8,",
                string.concat(jsonPreImage, jsonPostImage)
            );
    }

    // mint
    function mint(uint quantity, bytes32[] calldata _merkleProof) external {
        require(_numberMinted(msg.sender) + quantity <= MAX_MINT_PER_WALLET, "Over wallet limit");
        _mint(msg.sender, quantity);
    }
    function adminMint(uint quantity) external onlyOwner {
        _mint(msg.sender, quantity);
    }

    // aliases
    function numberMinted(address owner) external view returns (uint256) {
        return _numberMinted(owner);
    }

}
