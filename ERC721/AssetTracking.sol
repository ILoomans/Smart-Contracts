pragma solidity ^0.6.2;



import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/EnumerableSet.sol';


contract Tracker is ERC721{
    
    using EnumerableSet for EnumerableSet.AddressSet;
    address public owner;
    EnumerableSet.AddressSet Minters;
    
    
    struct minter{
        string  Name;
        string Location;
        uint256 Time;
    }
    
    struct distributor{
        string Name;
        string Location;
        string Website;
        uint256 Time;
        bool isDist;
    }
    
    
    struct product{
        string Name;
        address Creator;
        uint256 Time;
    }
    

    mapping (uint256 => product) public Product;
    mapping (address => minter) public MintInfo;
    mapping (address => EnumerableSet.AddressSet) Distributors;
    mapping (address => EnumerableSet.AddressSet) DistMinters; 
    mapping (address => distributor) DistInfo;
    
    event checkUp(uint256 indexed _tokenId, address _dist, uint256 _time);
    
    
    constructor()ERC721('biketracker','tracker')public {
        owner =msg.sender;
    }
    
    function getOwner()public view  returns(address){
        return owner;
    }
    
    
    function setMinter(address to,string memory name,string memory location) public {
        require(msg.sender==owner,'You do not have the permission to do this');
        require(Minters.contains(to)==false, "Minter Already Exists");
        Minters.add(to);
        MintInfo[to] = minter(name,location,now);
 
    }
    
    function removeMinter(address to) public {
        require(msg.sender==owner,'You do not have the permission to do this');
        require(Minters.contains(to)==true, "ERC721: mint to the zero address");
        Minters.remove(to);
    }
    
    function getMinters() public view returns(uint256){
        return Minters.length();
    }
    
    function getMinter(uint256 id) public view returns(address){
        return Minters.at(id);
    }
    
    
    function create(address to, uint256 tokenId, string memory assetName) public {
        require(Minters.contains(msg.sender)==true,"You do not have permission to create");
        Product[tokenId] = product(assetName, msg.sender, now);
        _safeMint(to,tokenId);
    }
    
    
    
    
    
    
    /** Test that you arent overriding anything **/
    function addDist(address to) public {
        //require that they exist
        require(Minters.contains(msg.sender)==true,"You do not have the permission to add a distributor");
        require(DistInfo[to].isDist==true,"This distributor does not exist yet, you must use the createDist function");
        Distributors[msg.sender].add(to);
        DistMinters[to].add(msg.sender);
    }
    
    //Only removes this dist for you
    function removeDist(address to) public {
        require(Minters.contains(msg.sender)==true,"You do not have the permission to add a distributor");
        //require that they exist
        Distributors[msg.sender].remove(to);
        DistMinters[to].remove(msg.sender);
    }
    
    function isDist(address dist, address mint) public view returns(bool){
        return Distributors[mint].contains(dist);
    }
    
    //Give everyone access to viewing distributors
    function viewDists(address mint) public view returns(uint256){
        return Distributors[mint].length();
    }
    
    //Give everyone access to viewing distributors 
    function viewDist(uint256 pos, address mint) public view returns(address){
        return Distributors[mint].at(pos);
    }
        
    // add an event for the minting of  token 
    function checkToken(uint256 _tokenId) public{
        //Backing that the bike is in good conndition 
        // Check that the person doing the checking is a distributor of the product minter
        //    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
       require(Distributors[Product[_tokenId].Creator].contains(msg.sender),'You are not a licensed distributor to complete a checkup on this bike');
       require(ownerOf(_tokenId)!=msg.sender,'You cannot check a token that you own');
       emit checkUp(_tokenId,msg.sender,now);
       
        
    }
    
    
    function viewDMinters(address _to) public view returns(address[] memory){
        uint256 length = DistMinters[_to].length();
        address [] memory minters = new address[](length);
        for (uint i = 0; i < length;  i++) {
          minters[i] = DistMinters[_to].at(i);
      }
      return minters;
        
    }
    
    
    function createDist(address _to, string memory _name, string memory _location, string memory _website) public {
        require(Minters.contains(msg.sender)==true,'You do not habe the permission to add a distributor');
        require(DistInfo[_to].isDist==false,'This user has already been used as a distributor, use the addDist function');
        DistInfo[_to]  = distributor(_name,_location,_website,now,true);
        DistMinters[_to].add(msg.sender);
        Distributors[msg.sender].add(_to);
    }
    
    
    
    function dName (address _to) public view returns(string memory){
        return DistInfo[_to].Name;
    }
    
    function dLocation (address _to) public view returns(string memory){
        return DistInfo[_to].Location;
    }
    function dWebsite (address _to) public view returns(string memory){
        return DistInfo[_to].Website;
    }
    
    
    function sendValueToken(address payable _to,uint256 _tokenId) public payable{
        //First call the transfer function to make sure this passes before value is sendValueToken
        safeTransferFrom(msg.sender,_to,_tokenId);
        _to.transfer(msg.value);
    }
    
    function isRDist(address _to) public view returns(bool){
        return DistInfo[_to].isDist;
    }
    
    
    //isRDist was used to check iit was already in the list, this is dual ledger so maybe get rid of 
    
    //Marked an asset as stolen ~ test that they are the owner of the asset
        
        
}   
