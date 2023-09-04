//SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

// File: @openzeppelin/contracts/utils/Context.sol
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

}

// File: @openzeppelin/contracts/access/Ownable.sol
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/Address.sol
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
   
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }


    

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
// OpenZeppelin Contracts (last updated v4.9.3) (token/ERC20/utils/SafeERC20.sol)


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }


    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

}

// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        if (_status == _ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    
}


/// @title Presale Vesting
/// @notice vesting contract for presale user
/// user can set amount, vesting which can't be modified
contract PresaleVesting is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    
    //// CUSTOM ERRORS ////
    error ZeroAddress();
    error AlreadyClaimed();
    error ZeroAmount();
    error ArrayLengthMismatch();
    error ClaimNotStartedYet();
    error UserAlreadyHasVesting();
    error CannotClaimNativeToken();


    /// @notice token address
    IERC20 private immutable token;
    /// @notice cliffTime
    uint256 private immutable cliffTime;
    /// @notice vesting duration for linear vesting
    uint256 private immutable vestingDuration;
    /// @notice initial unlock percentage
    uint256 private immutable initialUnlockPercentage;
    
    
    
    /// @notice struct user information
    /// totalTokens: total tokens allocated 
    /// vestedTokens; tokens to be vested linearly
    /// initialTokens: tokens to be availabel for initial claim
    /// totalClaimed: total tokens claimed by user
    /// vesting start: linear vest start time
    /// vesting End: linear vest end time
    /// initialClaimed: return true or false based on initial unlock 
    struct User{
     uint256 totalTokens;   
     uint256 vestedTokens;
     uint256 initialTokens;
     uint256 totalClaimed;
     uint256 vestingStart;
     uint256 vestingEnd;
     bool initialClaimed;
    }
    
    /// @notice mapping for users struct
    mapping (address => User) public users;

    /// events
    event TokensClaimed (address indexed user, uint256 indexed amount);
    event VestingAdded (address indexed user, uint256 indexed amount);
    event MultipleVestingAdded (address[] indexed users, uint256 []indexed tokenAmounts);

    
    /// @dev create presale vesting smartcontract using OZ ownable, safeERC20.
    /// initialized the immutable variables values like token, cliffTime, 
    /// vesting duration, initialUnlockPercentage
    constructor (address _token) {
        if(address(_token) == address(0)){
            revert ZeroAddress();
        }
        token = IERC20(_token);
        cliffTime = 30 days;
        vestingDuration = 180 days;
        initialUnlockPercentage = 25;
    
    }
    
    /// modifiers ///
    ///@notice check if input is nonZero
    modifier zeroAddressCheck(address user) {
        if(user == address(0)){
            revert ZeroAddress();
        }
        _;
    }

    /// @notice check if input amount is greator than zero
    modifier zeroAmountCheck (uint256 amount){
        if(amount == 0){
            revert ZeroAmount();
        }
        _;
    }
     
    /// @notice owner set vesting for account
    /// @param account: user address
    /// @param amount: total tokens to be alloted
    function addVesting (address account, uint256 amount) zeroAddressCheck(account) zeroAmountCheck(amount) external nonReentrant onlyOwner {
         User storage user = users[account];
         if(user.totalTokens > 0){
            revert UserAlreadyHasVesting();
         }
        uint256 tokensToVest = (amount*75) / 100;
        uint256 initialUnlock = amount - tokensToVest;
        uint256 vestStart = block.timestamp + cliffTime;
        uint256 vestEnd = vestStart + vestingDuration;
        users[account] = User({
            totalTokens: amount,
            vestedTokens: tokensToVest,
            initialTokens: initialUnlock,
            totalClaimed: 0,
            vestingStart: vestStart,
            vestingEnd: vestEnd,
            initialClaimed: false
        });

        token.safeTransferFrom(msg.sender, address(this), amount);
        emit VestingAdded(account, amount);
    }
    

    /// @notice add vesting to multiple accounts
    /// @param accounts: users address array
    /// @param amounts: amounts array to alloted for each user 
    function addVestingMultiple  (address[] calldata accounts, uint256[] calldata amounts) external nonReentrant onlyOwner {
        uint256 accountsLength = accounts.length;
        uint256 amountsLength = amounts.length;
        if(accountsLength != amountsLength){
          revert ArrayLengthMismatch();
          }
        uint256 sum = 0;
        for (uint256 i = 0; i < accountsLength; ++i) {
          address account = accounts[i];
          uint256 amount = amounts[i];

          if(account == address(0)){
            revert ZeroAddress();
           }
          if(amount == 0){
            revert ZeroAmount();
          }

           User storage user = users[account];
         if(user.totalTokens > 0){
            revert UserAlreadyHasVesting();
         }

         sum = sum + amount;

        uint256 tokensToVest = (amount * 75) / 100;
        uint256 initialUnlock = amount - tokensToVest;
        uint256 vestStart = block.timestamp + cliffTime;
        uint256 vestEnd = vestStart + vestingDuration;

        users[account] = User({
            totalTokens: amount,
            vestedTokens: tokensToVest,
            initialTokens: initialUnlock,
            totalClaimed: 0,
            vestingStart: vestStart,
            vestingEnd: vestEnd,
            initialClaimed: false
        });
       }
       token.safeTransferFrom(msg.sender, address(this), sum);
       emit MultipleVestingAdded(accounts,amounts);
    }

    /// @dev owner can claim any other erc20 tokens 
    /// @param _token: token to claim
    /// Requirements- RebelsRevolt tokens can't be claimed by owner
    function claimOtherERC20Tokens(address _token) zeroAddressCheck(_token) external onlyOwner {
        if(_token == address(token)){
            revert CannotClaimNativeToken();
        }
        IERC20 otherERC20 = IERC20(_token);
        uint256 balance = otherERC20.balanceOf(address(this));
        otherERC20.safeTransfer(owner(), balance);
    }

    ///@notice  users can claim there tokens using this function
    function claim () external nonReentrant {
       
        User storage user = users[msg.sender];
        if(block.timestamp <= user.vestingStart - cliffTime){
            revert ClaimNotStartedYet();
        }
        if(user.totalClaimed == user.totalTokens){
            revert AlreadyClaimed();
        }
        uint256 unlockedTokens = 0;
        if(block.timestamp > user.vestingStart - cliffTime){
            if(!user.initialClaimed){
                unlockedTokens = user.initialTokens;
                user.initialClaimed = true;
            }
            
            
            if(block.timestamp > user.vestingEnd){
                unlockedTokens = user.totalTokens - user.totalClaimed;
            }
                
            if(block.timestamp >= user.vestingStart && block.timestamp <= user.vestingEnd) {  
                  uint256 timeElapsed = block.timestamp - user.vestingStart;
            
                  uint256 releasedAmount = (timeElapsed * user.vestedTokens) / vestingDuration;
                  unlockedTokens = releasedAmount + user.initialTokens - user.totalClaimed;    
            }
            
         user.totalClaimed = user.totalClaimed + unlockedTokens;   
         token.safeTransfer(msg.sender, unlockedTokens);
         emit TokensClaimed (msg.sender, unlockedTokens);
        }
         
         
    }
    
    
    
    /// @return global cliff time
    function getGlobalCliffTime () public view returns (uint256){
        return cliffTime;
    }
    
    /// @return rebelsRevolt token address
    function getTokenAddress() public view returns (address){
        return address(token);
    }
    
    /// @return global vesting duration
    function getGlobalVestingDuration () public view returns (uint256) {
        return vestingDuration;
    }
    
    /// @return global initial unlocked percentage
    function getInitialUnlock () public view returns (uint256) {
        return initialUnlockPercentage;
    }

 
}
