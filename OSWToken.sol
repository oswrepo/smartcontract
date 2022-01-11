// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/Arrays.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import './TokenTimelock.sol';

pragma solidity ^0.8.0;
/**
 * For security issues: contact@openstream.world
 */

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

pragma solidity ^0.8.0;

contract OSWToken is ERC20, ERC20Burnable, ERC20Snapshot, Ownable, Pausable {
    
    using SafeMath for uint;

    uint256 private totalTokens;
    uint256 private l2ePool;
    uint256 private forgePool;
    uint256 private reservePool;
    uint256 private marketingPool;
    uint256 private foundingPool;
    uint256 private devPool;
    uint256 private marketingTeamPool;
    uint256 private advisorPool;
    uint256 private investorPool;
    uint256 private airdropPool;
    uint256 private seedPool;
    uint256 private privatePool;
    uint256 private publicPool;
    uint256 private liquidPool;

    address private marketingAddrLock;
    address private reserveAddrLock;
    address private foundingAddrLock;
    address private devAddrLock;
    address private marketingTeamAddrLock;
    address private advisorAddrLock;
    address private investorAddrLock;
    address private seedAddrLock;
    address private privateAddrLock;

    constructor() ERC20("OpenStream World", "OSW") {
        totalTokens = 680 * 10 ** 6 * 10 ** uint256(decimals()); // 680M
        TimelockFactory timelockFactory = new TimelockFactory();

        // Ecosystem Growth: 57.5%
        // --- Livestream-to-earn: 28%
        l2ePool = totalTokens * 28/100;
        // --- Stream Node Forgers: 15%
        forgePool = totalTokens * 15/100;
        // --- Reserve capital: 7%
        reservePool = totalTokens * 7/100;
        // --- Marketing: 7.5%
        marketingPool = totalTokens * 75/1000;
        // Team & Advisors: 15.5%
        // --- Founding team: 6%
        foundingPool = totalTokens * 6/100;
        // --- Development Team: 3.7%
        devPool = totalTokens * 37/1000;
        // --- Marketing Team: 3.3%
        marketingTeamPool = totalTokens * 33/1000;
        // --- Advisors: 2.5%
        advisorPool = totalTokens * 25/1000;
        // Early Investor: 7%
        investorPool = totalTokens * 7/100;
        // Airdrop: 0.37%
        airdropPool = totalTokens * 37/10000;
        // Token Sale: 16,63%
        // --- Seed Sale: 8.6%
        seedPool = totalTokens * 86/1000;
        // --- Private Sale: 6%
        privatePool = totalTokens * 6/100;
        // --- Public Sale: 2.03%
        publicPool = totalTokens * 203/10000;
        // Exchange Liquidity Provision: 3%
        liquidPool = totalTokens * 3/100;

        // Start Locking Pool
        _mint(0xfee931A403613041f78B213e1784A0E0422Ab9F5, marketingPool * 2/10);
        marketingAddrLock = timelockFactory.createTimelock(this, 0xfee931A403613041f78B213e1784A0E0422Ab9F5, block.timestamp + 30 days, (marketingPool * 8/10)/24, 30 days);
        _mint(marketingAddrLock, marketingPool * 8/10);

        reserveAddrLock = timelockFactory.createTimelock(this, 0x7A77f302496D42dD34Ff16854661b942786D8398, block.timestamp + 365 days, reservePool/24, 30 days);
        _mint(reserveAddrLock, reservePool);

        foundingAddrLock = timelockFactory.createTimelock(this, 0x4822240ABC787e1108a012De945d10e6bf1F78A4, block.timestamp + 180 days, foundingPool/36, 30 days);
        _mint(foundingAddrLock, foundingPool);

        devAddrLock = timelockFactory.createTimelock(this, 0x323Cfe583c1A0c376DeFDeA5dB959A2f81882c16, block.timestamp + 30 days, devPool/36, 30 days);
        _mint(devAddrLock, devPool);

        marketingTeamAddrLock = timelockFactory.createTimelock(this, 0x61747f64909451A781806b8ad38Bc74fC9882024, block.timestamp + 30 days, marketingTeamPool/36, 30 days);
        _mint(marketingTeamAddrLock, marketingTeamPool);

        advisorAddrLock = timelockFactory.createTimelock(this, 0x30fBCEE8e74486E7Db1D370FB7eaE634F0aD4BB7, block.timestamp + 180 days, advisorPool/12, 30 days);
        _mint(advisorAddrLock, advisorPool);

        investorAddrLock = timelockFactory.createTimelock(this, 0x4197D73Fc2d681972F32AF48b061D3286d5f4309, block.timestamp + 180 days, investorPool/12, 30 days);
        _mint(investorAddrLock, investorPool);

        _mint(0x7ef8738F7E6038E6887A5F13e87E462165F5b94B, seedPool * 1/10);
        seedAddrLock = timelockFactory.createTimelock(this, 0x7ef8738F7E6038E6887A5F13e87E462165F5b94B, block.timestamp + 30 days, (seedPool * 9/10)/12, 30 days);
        _mint(seedAddrLock, seedPool * 9/10);
    
        _mint(0x243425D150A9ADA6D3db7212955A3f4c0c35a02a, privatePool * 16/100);
        privateAddrLock = timelockFactory.createTimelock(this, 0x243425D150A9ADA6D3db7212955A3f4c0c35a02a, block.timestamp + 30 days, (privatePool * 84/100)/10, 30 days);
        _mint(privateAddrLock, privatePool * 84/100);

        // Livestream to earn Pool, Node Forge Pool, Public Pool & Exchange Liquidity Provision unlock right from start
        _mint(0xec8EfD0C69D53E76bB1e43bB474aD9d082a6c5B9, l2ePool);
        _mint(0xC8Fd6867c5Ae8ACe36a572984d9bB56d74060691, forgePool);
        _mint(0xC30B35d5a8C2332396E2FB97B100A3e8DA8Cd2D5, publicPool);
        _mint(0x13b73969D850Fb8597bEaAc0F98408A52AFf2301, liquidPool);
        _mint(owner(), airdropPool);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= totalTokens, "Exceed Max total supply");
        _mint(to, amount);
    }

    function snapshot() external onlyOwner {
        _snapshot();
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function getBurnedAmountTotal() external view returns (uint256 _amount) {
        return totalTokens.sub(totalSupply());
    }
}