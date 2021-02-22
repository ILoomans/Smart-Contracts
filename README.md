# Smart-Contracts 

## ERC-20 Fungible Token 

This is a smart contract for issuing and selling tickets in a decentralized manner. It is a unique smart contract in that it works on 3 contract layers. To clarify the Host contract is the basis of this platform. The createEvent function in the host contract is used to iniate an event, represented through the Event.sol smart contract. Calling this function creates an event, with certain amounts of a given ERC20 ticket. The ERC20 standard is however limited in the fact that the price and quanitity are fixed, meaning that there can only be one type of ticket issued!

This is addressed by then allowing the Event.sol contract to add another ERC20 contract with its own amount and its own price. This smart contract infrastructure is designed to make it as easy as possible for someone to issue multiple contracts without having to compile and deploy multiple smart contracts. 

### Host.sol

As Mentioned before the Host.sol provides and enterancy for different users to issue smart contracts. It has one key function which is createEvent, which in turn creates an Event.sol smart contract representing the event and the first set of tickets the event owner would like to issue. 

The other functions are very simple view function that get the details of an event. There is a mapping where users can see all the events created by an account. This could be used to establish trust and credibility of the event issuer, if they have a history of succesfull events.

### Event.sol

When the Event.sol contract is initialized by the Host.sol contract, it immediately issues an ERC20 contract represting the first class of tickets. After this new ticket classes can be issued with the addContract function, which issues a new ERC20 contract representing the new contract class. Ofcourse restraints are put on this function that only the event owner can issue new tickets. The different ticket types (ERC20 contracts) are then tracked in the tAddresses array, while the info of the different ticket types is held in a mapping that points to a struct with their respective info (typeName, symbol, totalSupply, and price).

### ERC20.sol

The ERC20 contract seemed like the most appropriate and gas efficient contract to use for this purpose. Ther ERC-20 contract creates fungible tokens, which means that there is no distinction between the tokens. The contract assumes that there are multiple tickets of the same type which are grouped in a contract. The different ticket types are then handled by the various ERC-20 contracts under event contract. One parameter of the ERC-20 contract had to be overwritten and that was the decimals parameter. The decimals parameter allows for the user to own a fraction of a token, say half or a tenth of a token. The decimal parameter in essence multiplies the amount of tokens you own when you purchase a token, so say you purchase one token, the smart contract will record that you have 100, allowing you to sell 50 and still own 0.5 of a token. This however is undesirable for the purpose of this contract as you cannot own half a ticket. Therefore the decimal value was set to 0. 


## ERC-721 Non-Fungible Token
This smart contract is for the tracking and tracing the ownership of unique goods, allowing for the owner to prove ownership of the asset, and elimating any information assymetry in the sale/resale of these goods.
