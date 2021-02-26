// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/**
 * @dev Library for managing uint set
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checkExistenceed for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 */
 library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        }
        return false;
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        }
        return false;
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet
    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet
    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title escrow contract that handles safe trading between seller and buyer
 *
 * @author Alexandr Martirosyan
 */
contract Escrow {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;

    /// @dev Emitted when contract is stopped or resumed
    event ContractConditionChanged(bool stopped);
    /// @dev Emitted when decision maker changed for {seller}
    event DecisionMakerChanged(address indexed seller, address indexed from, address indexed to);
    /// @dev Emmited when escrow time changed for {seller}
    event EscrowTimeChanged(address indexed seller, uint from, uint to);
    /// @dev Emitted when payment is created by buyer  
    event PaymentCreated(address indexed seller, address indexed buyer, uint paymentId, uint amount);
    /// @dev Emitted when buyer approved payment of `paymentId`
    event ApprovedByBuyer(address indexed seller, address indexed buyer, uint paymentId);
    /// @dev Emmited when seller approved payment of `paymentId`
    event ApprovedBySeller(address indexed seller, address indexed buyer, uint paymentId);
    /// @dev Emmited when seller called {getTokenFromContract} method 
    event TokenTransferredToSeller(address indexed seller, address indexed buyer, uint paymentId, uint amount);
    /// @dev Emmited when buyer called {withdraw} method when payment time is expired
    event Withdrawed(address indexed seller, address indexed buyer, uint paymentId, uint amount);
    /// @dev Emmited when decision maker maked decision transfer token to `buyer` or to `seller`
    event DecisionMaked(address indexed decisionMaker, address indexed seller, address indexed buyer, uint paymentId, uint amount, bool transferredToBuyer);

    struct Payment {
        uint _amount;
        uint _endTime;
        address _decisionMaker;
        bool _deliveryApproved;
        bool _provisionApproved;
    }

    struct SellerInfo {
        address _decisionMaker;
        uint _escrowTime;
        EnumerableSet.AddressSet _buyerAddresses;
        mapping(address => EnumerableSet.UintSet) _buyerPaymentIds;
    }

    // id counter
    uint private _idCounter = 0;
    // minimum escrow time
    uint public minEscrowTime;
    // condition of contract
    bool public stopped;
    // the address of contract owner
    address public contractOwner;
    // the address of erc20 token
    IERC20 public currency;

    mapping(address => SellerInfo) _sellers;
    mapping(uint => Payment) public payments;

    /**
     * @notice Sets the value for {currency} and {minEscrowTime}, initializes 
     * {contractOwner} with a {msg.sender}
     */
    constructor(IERC20 currency_, uint minEscrowTime_) {
        require(minEscrowTime_ > 0, "Escrow time cannot be 0");
        currency = currency_;
        minEscrowTime = minEscrowTime_;
        contractOwner = msg.sender;
    }

    /**
     * @notice Required that function caller must be contract Owner
     */
    modifier onlyOwner() {
        require(msg.sender == contractOwner, "This function can call only owner of contract");
        _;
    }

    /**
     * @notice Required that seller must contain a buyer address
     * and buyer must contain paymentId
     *
     * @param seller - the address of seller
     * @param buyer - the address of buyer
     * @param paymentId - the id of payment
     */
    modifier checkExistence(address seller, address buyer, uint paymentId) {
        require(_sellers[seller]._buyerAddresses.contains(buyer), "Buyer does not exist for this seller");
        require(_sellers[seller]._buyerPaymentIds[buyer].contains(paymentId), "Id does not exist in buyer payment id set");
        _;
    }

    /**
     * @notice returns address of decision maker of {seller}
     * 
     * @param seller - address of seller
     * @return address of decision maker
     */
    function sellerDecisionMaker(address seller) external view returns(address) {
        return _sellers[seller]._decisionMaker;
    }

    /**
     * @notice returns escrow time of {seller}
     * 
     * @param seller - address of seller
     * @return escrowTime of seller 
     */
    function sellerEscrowTime(address seller) external view returns (uint) {
        return _sellers[seller]._escrowTime;
    }

    /**
     * @notice returns boolean value that represents whether seller 
     * contains a buyer address or not
     *
     * @param seller - the address of seller
     * @param buyer - the addres of buyer
     * @return `true` if seller contains buyer address otherwise `false`
     */
    function sellerBuyersContains(address seller, address buyer) external view returns (bool) {
        return _sellers[seller]._buyerAddresses.contains(buyer);
    }

    /**
     * @notice returns the number of buyer addresses that contains seller
     *
     * @param seller - the address of seller
     * @return the length of buyer addresses set  
     */
    function sellerBuyersLength(address seller) external view returns (uint) {
        return _sellers[seller]._buyerAddresses.length();
    }

    /**
     * @notice returns the buyer address at index `index`
     * @dev if index is not less than length of buyer address set throws
     * index out of bounds exception
     *
     * @param seller - the address of seller
     * @param index - the index of buyer addresses set
     * @return address of buyer at given `index` 
     */
    function sellerBuyersAt(address seller, uint index) external view returns (address) {
        return _sellers[seller]._buyerAddresses.at(index);
    }
    
    /**
     * @notice returns boolean value that represents whether `buyer` 
     * inside a sellerInfo contains payment with `paymentId` or not
     *
     * @param seller - the address of seller
     * @param buyer - the addres of buyer
     * @param paymentId - the id of payment
     * @return `true` if `buyer` inside sellerinfo contains payment
     * with given paymentId otherwise `false`
     */
    function buyerPaymentIdsContains(address seller, address buyer, uint paymentId) external view returns (bool) {
        return _sellers[seller]._buyerPaymentIds[buyer].contains(paymentId);
    }

    /**
     * @notice returns the number of payments that contains buyer inside
     * of sellerInfo
     *
     * @param seller - the address of seller
     * @param buyer - the address of buyer
     * @return the length of buyer payments  
     */
    function buyerPaymentIdsLength(address seller, address buyer) external view returns (uint) {
        return _sellers[seller]._buyerPaymentIds[buyer].length();
    }

    /**
     * @notice returns the id of Payment at index `index` inside sellerinfo buyer
     * @dev if index is not less than length of buyer payments set throws
     * index out of bounds exception
     *
     * @param seller - the address of seller
     * @param buyer - the address of buyer
     * @param index - the index of payment
     * @return id of payment at given `index` 
     */
    function buyerPaymentIdsAt(address seller, address buyer, uint index) external view returns (uint) {
        return _sellers[seller]._buyerPaymentIds[buyer].at(index);
    }

    /**
     * @notice stopped the contract(buyer cannot create payment)
     */
    function stopContract() external onlyOwner {
        require(!stopped, "Contract already stopped");
        stopped = true;
        emit ContractConditionChanged(stopped);
    }

    /**
     * @notice resumed the contract(new buyer can create a payment)
     */
    function resumeContract() external onlyOwner {
        require(stopped, "Contract already resumed");
        stopped = false;
        emit ContractConditionChanged(stopped);
    }

    /**
     * @notice changed decision maker for seller (seller is msg.sender)
     *
     * @param newDecisionMaker - the address of new decisionMaker
     */
    function changeDecisionMaker(address newDecisionMaker) external {
        require(newDecisionMaker != address(0), "DecisionMaker cannot be 0 address");
        address seller = msg.sender;
        require(_sellers[seller]._decisionMaker != newDecisionMaker, "This decision maker already setted for this seller");
        emit DecisionMakerChanged(seller, _sellers[seller]._decisionMaker, newDecisionMaker);
        _sellers[seller]._decisionMaker = newDecisionMaker;
    }

    /**
     * @notice changed escrow time for seller (seller is msg.sender)
     *
     * @param newEscrowTime - new escrow time for seller
     */
    function changeEscrowTime(uint newEscrowTime) external {
        require(newEscrowTime >= minEscrowTime, "Escrow time must be greater or equal than minimum escrow time");
        address seller = msg.sender;
        require(_sellers[seller]._escrowTime != newEscrowTime, "This escrow time is already setted for this seller");
        emit EscrowTimeChanged(seller, _sellers[seller]._escrowTime, newEscrowTime);
        _sellers[seller]._escrowTime = newEscrowTime;
    }

    /**
     * @notice creates payment by buyer and transfer {amount} token 
     * from buyer to contract address
     * @dev Requires that the currency transferred successfully
     *
     * @param seller - the address of seller 
     * @param amount - amount of tokens that will be transfer
     */
    function createPayment(address seller, uint amount) external {
        address buyer = msg.sender;
        SellerInfo storage sellerInfo = _sellers[seller];
        require(!stopped, "Payment cannot be created beacuse Escrow now stopped");
        require(sellerInfo._decisionMaker != address(0), "Decision maker is 0 address");
        require(sellerInfo._escrowTime > 0, "Escrow time cannot be 0");
        require(currency.transferFrom(buyer, address(this), amount));
        payments[_idCounter] = Payment({
            _amount: amount,
            _endTime: block.timestamp + sellerInfo._escrowTime,
            _decisionMaker: sellerInfo._decisionMaker,
            _deliveryApproved: false,
            _provisionApproved: false
        });
        sellerInfo._buyerAddresses.add(buyer);
        sellerInfo._buyerPaymentIds[buyer].add(_idCounter);
        emit PaymentCreated(seller, buyer, _idCounter, amount);
        _idCounter++;
    }
    
    /**
     * @notice buyer approved delivery by calling this function 
     * @dev check contract requirements in {checkExistence} modifier.
     * Required that buyer never approved this payment and time of paymant isn't up
     *
     * @param seller - the address of seller
     * @param paymentId - the id of payment
     */
    function approveDelivery(address seller, uint paymentId) external checkExistence(seller, msg.sender, paymentId) {
        Payment storage payment = payments[paymentId];
        require(!payment._deliveryApproved, "Buyer already approve this payment");
        payment._deliveryApproved = true;
        emit ApprovedByBuyer(seller, msg.sender, paymentId);
    }

    /**
     * @notice seller approved provision by calling this function 
     * @dev check contract requirements in {checkExistence} modifier.
     * Required that seller never approved this payment and time of paymant isn't up
     *
     * @param buyer - the address of buyer
     * @param paymentId - the id of payment
     */
    function approveProvision(address buyer, uint paymentId) external checkExistence(msg.sender, buyer, paymentId) {
        Payment storage payment = payments[paymentId];
        require(payment._endTime > block.timestamp, "Time is up");
        require(!payment._provisionApproved, "Seller already approve this payment");
        payment._provisionApproved = true;
        emit ApprovedBySeller(msg.sender, buyer, paymentId);
    }

    /** 
     * @notice seller called this function to get tokens from contract 
     * to his/her address
     * @dev requires that buyer and seller approved the payment
     * Requires that the currency transferred successfully
     * Requires that buyer approve delivery
     * Check contract requirements in {checkExistence} modifier.
     *
     * @param buyer - the address of buyer
     * @param paymentId - the Id of payment
     */
    function getTokenFromContract(address buyer, uint paymentId) external checkExistence(msg.sender, buyer, paymentId) {
        address seller = msg.sender;
        Payment storage payment = payments[paymentId];
        require(payment._deliveryApproved, "Buyer does not approve delivery");
        require(currency.transfer(seller, payment._amount), "currency transfer from contract to seller failed");
        _deletePayment(seller, buyer, paymentId);
        emit TokenTransferredToSeller(seller, buyer, paymentId, payment._amount);
    }
    
    /**
     * @notice buyer called this function to get his/her tokens back if time is up
     * @dev requires that time is up
     * Requires that the currency transferred successfully
     * Requires that buyer does not approve delivery
     * Requires that seller does not approve provision
     * Check contract requirements in {checkExistence} modifier.
     * 
     * @param seller - the address of seller
     * @param paymentId - the Id of payment
     */
    function withdraw(address seller, uint paymentId) external checkExistence(seller, msg.sender, paymentId) {
        address buyer = msg.sender;
        Payment storage payment = payments[paymentId];
        require(payment._endTime <= block.timestamp, "Time isn't up");
        require(!payment._deliveryApproved, "Buyer already approved delivery");
        require(!payment._provisionApproved, "Seller approved provision, If you want to get money plese contact to decision maker of this payment");
        require(currency.transfer(buyer, payment._amount), "currency transfer from contract to buyer failed");
        _deletePayment(seller, buyer, paymentId);
        emit Withdrawed(seller, buyer, paymentId, payment._amount);
    }
    
    /**
     * @notice Owner of contract call this function when buyer and seller disagree 
     * and make decision transfer money to buyer or seller
     * @dev 
     * Requires that buyer does not approve delivery
     * Requires that seller approve provision
     * Requires that function caller is secision maker for that payment
     * Require that time is up
     * Requires that the currency transferred successfully
     * Check contract requirements in {checkExistence} modifier.
     *
     * @param seller - the address of seller 
     * @param buyer - the address of buyer
     * @param paymentId - the id of payment
     * @param transferToBuyer - `true` if monkey will be transferred to buyer and false 
     * if will be transferred to seller
     */
    function makeDecision(address seller, address buyer, uint paymentId, bool transferToBuyer) external checkExistence(seller, buyer, paymentId) {
        Payment storage payment = payments[paymentId];
        require(msg.sender == payment._decisionMaker, "The function caller (msg.sender) is not decision maker for this payment");
        require(payment._endTime <= block.timestamp, "Time isn't up");
        require(!payment._deliveryApproved, "You cannot make a decision because buyer already approved delivery");
        require(payment._provisionApproved, "You cannot make a decision because seller does not approve provision");
        address recipient = transferToBuyer ? buyer : seller;
        require(currency.transfer(recipient, payment._amount), "currency transfer from contract to recipient failed");
        _deletePayment(seller, buyer, paymentId);
        emit DecisionMaked(payment._decisionMaker, seller, buyer, paymentId, payment._amount, transferToBuyer);
    }

    /**
     * @notice function deletes paymentId from buyer address set and 
     * deletes payment from payments mapping
     * If the address of buyer has only one payment for this 
     * `seller`(and that payment removed in function call) then function removes 
     * buyer address from sellerInfo
     * 
     * @param seller - the address of seller
     * @param buyer - the address of buyer 
     * @param paymentId - the Id of paymentId
     */
    function _deletePayment(address seller, address buyer, uint paymentId) private {
        SellerInfo storage sellerInfo = _sellers[seller];
        sellerInfo._buyerPaymentIds[buyer].remove(paymentId);
        if (sellerInfo._buyerPaymentIds[buyer].length() == 0) {
            sellerInfo._buyerAddresses.remove(buyer);
        }
        delete payments[paymentId];
    }
}