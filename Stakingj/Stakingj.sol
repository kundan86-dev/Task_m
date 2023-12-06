// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "@openzeppelin/contracts/utils/Counters.sol";

contract StakingContract {

    using Counters for Counters.Counter;
    Counters.Counter private stakeNumber;

    IERC20 private token;
    uint256 private rateOfIntrest = 1;

    struct stakersInformation {
    uint256 stakedTokenAmount;
    uint256 timeWhenUserStaked;
    uint256 stakeTimePeriod;
    bool stakeEnded;
    }
    mapping(uint256 => address) public ownerOfStakeNumber;
    mapping(uint256 => stakersInformation) public stakerInformationOfStakeNumber;
    mapping(address => uint256) public rewardsOfStaker;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function stakeToken(uint256 numberOfTokens, uint256 tarrif) external returns (uint256) {
    stakeNumber.increment();

    require(numberOfTokens > 0, "You cannot stake 0 amount of token");
    require(token.balanceOf(msg.sender) >= numberOfTokens, "You do not have enough tokens that you entered for stake");
    require(tarrif == 2 || tarrif == 4 || tarrif == 6 || tarrif == 8 || tarrif == 10, "Tarrif for plans is only - 2,4,6,8,10 Minutes");

     uint256 current_time = block.timestamp;
     ownerOfStakeNumber[stakeNumber.current()] = msg.sender;

    require(token.transferFrom(msg.sender, address(this), numberOfTokens), "Please approve this contract to spend your stake amount in your ERC20 token contract");

    stakerInformationOfStakeNumber[stakeNumber.current()].stakedTokenAmount += numberOfTokens;
    stakerInformationOfStakeNumber[stakeNumber.current()].timeWhenUserStaked = current_time;
    stakerInformationOfStakeNumber[stakeNumber.current()].stakeTimePeriod = tarrif * 60;
    stakerInformationOfStakeNumber[stakeNumber.current()].stakeEnded = false;

 return stakeNumber.current();
}

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
}

    /*
        1. By calling this function user can calculate rewards of token which they staked
    */

    function calculateYourReward(uint256 _stakeNumber) public {
    uint256 current_time = block.timestamp;
    uint256 stakingDuration = current_time - stakerInformationOfStakeNumber[_stakeNumber].timeWhenUserStaked;
    uint256 time = min(stakingDuration, stakerInformationOfStakeNumber[_stakeNumber].stakeTimePeriod);

    rewardsOfStaker[ownerOfStakeNumber[_stakeNumber]] = rewardsOfStaker[ownerOfStakeNumber[_stakeNumber]] + (stakerInformationOfStakeNumber[_stakeNumber].stakedTokenAmount * rateOfIntrest * time) / 100;
    stakerInformationOfStakeNumber[_stakeNumber].timeWhenUserStaked = current_time;
    // [_stakeNumber].stakeTimePeriod = stakerInformationOfStakeNumber[_stakeNumber].stakeTimePeriod - time;
    stakerInformationOfStakeNumber[_stakeNumber].stakeTimePeriod = stakerInformationOfStakeNumber[_stakeNumber].stakeTimePeriod - time;

 }
/*
        1. By calling this function user can claim rewards if they staked thier token and staking period is overed
    */
    function widthrawYourReward(address yourAddress) public {
    uint256[] memory userids = findYourAllStakingId(yourAddress);
    require(userids.length > 0, "You are not staker");

    for (uint256 i = 0; i < userids.length; i++) {
    if (!stakerInformationOfStakeNumber[userids[i]].stakeEnded) {
        calculateYourReward(userids[i]);
    }
    }

    require(rewardsOfStaker[yourAddress] > 0, "You staking time period is not overed");
    token.transfer(msg.sender, rewardsOfStaker[yourAddress]);
    rewardsOfStaker[yourAddress] = 0;
 }

/*
        1. By calling this function user can claim amount if they staked thier token and staking period is overed
    */

    function widthrawYourAmount(address yourAddress) public {
    uint256[] memory userids = findYourAllStakingId(yourAddress);
    require(userids.length > 0, "You don not have amount to claim");

    for (uint256 i = 0; i < userids.length; i++) {
        if (!stakerInformationOfStakeNumber[userids[i]].stakeEnded) {
        token.transfer(msg.sender, stakerInformationOfStakeNumber[userids[i]].stakedTokenAmount);
        stakerInformationOfStakeNumber[userids[i]].stakedTokenAmount = 0;
        stakerInformationOfStakeNumber[userids[i]].stakeEnded = true;
        }
    }
}

/*
        1. By calling this function user can see their staking informations
    */

    function getYourStakeDetails(address yourAddress) public view returns (uint256[] memory, stakersInformation[] memory) {
        uint256 count = 0;
        for(uint256 i = 0; i <= stakeNumber.current(); i++) {
            if (ownerOfStakeNumber[i] == yourAddress) {
            count++;
            }
        }

    stakersInformation[] memory stakingInfos = new stakersInformation[](count);
    uint256[] memory userids = new uint256[](count);
    uint256 index = 0;

    for (uint256 i = 0; i <= stakeNumber.current(); i++) {
        if (ownerOfStakeNumber[i] == yourAddress) {
        stakingInfos[index] = stakerInformationOfStakeNumber[i];
        userids[index] = i;
        index++;
    }
        if (index > count) {
        break;
        }
 }
 return (userids, stakingInfos);
 }
 /*
        1. By calling this function user can see their choosed plan time duration by using thir staking id
    */

function stakeTime(uint256 id) view public returns (uint256) {
return stakerInformationOfStakeNumber[id].timeWhenUserStaked;
 }

function CurrentTime() internal view returns (uint256) {
 return block.timestamp;
 }

/*
        1. By calling this function user can get their all staking ids
    */

    function findYourAllStakingId(address yourAddress) public view returns (uint256[] memory) {
    uint256 count = 0;
    for (uint256 i = 0; i <= stakeNumber.current(); i++) {
            if (ownerOfStakeNumber[i] == yourAddress) {
        count++;
        }
    }

    uint256[] memory userids = new uint256[](count);
    uint256 index = 0;
    for (uint256 i = 0; i <= stakeNumber.current(); i++) {
        if (ownerOfStakeNumber[i] == yourAddress) {
            userids[index] = i;
            index++;
        }
    }
return userids;
 }
}

