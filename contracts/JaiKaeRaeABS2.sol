// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract JaiKaeRae is ERC721, Ownable {

    // config
    constructor(address initialOwner) ERC721("JKR Paymaster Edition", "JKR2") Ownable(initialOwner) {}
    uint256 public MAX_SUPPLY = 10_000;
    uint256 public MAX_MINT_PER_WALLET = 10;
    uint256 private _tokenIds = 0;

    bool public mintEnabled = true;
    string public baseURI = "https://jigsaw-fam.github.io/jkr/assets/abs2.png";

    // metadata
    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory jsonPreImage = string.concat(
            string.concat(
                string.concat('{"name": "JKR Paymaster #', Strings.toString(tokenId)),
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

    // toggle sale
    function toggleSale() external onlyOwner {
        mintEnabled = !mintEnabled;
    }

    // mint
    function mint(uint quantity, bytes32[] calldata _merkleProof) external {
        require(mintEnabled, "Sale is not enabled");
        require(balanceOf(msg.sender) + quantity <= MAX_MINT_PER_WALLET, "Over wallet limit");
        
        _checkSupplyAndMint(msg.sender, quantity);
    }
    function adminMint(uint quantity) external onlyOwner {
        _checkSupplyAndMint(msg.sender, quantity);
    }
    function _checkSupplyAndMint(address to, uint256 quantity) private {
        require(totalSupply() + quantity <= MAX_SUPPLY, "Over supply");

        for (uint256 i = 0; i < quantity; i++) {
            _tokenIds += 1;
            _safeMint(to, _tokenIds);
        }
    }

    // aliases
    function numberMinted(address owner) external view returns (uint256) {
        return balanceOf(owner);
    }
    function remainingSupply() external view returns (uint256) {
        return MAX_SUPPLY - totalSupply();
    }
    function totalSupply() public view returns (uint256) {
        return _tokenIds;
    }

}
