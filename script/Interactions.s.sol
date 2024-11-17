// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig, CodeConstants} from "script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/Mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        (uint256 subId, ) = createSubscription(vrfCoordinator);
        return (subId, vrfCoordinator);
    }

    function createSubscription(
        address vrfCoordinator
    ) public returns (uint256, address) {
        console.log(
            "Creating subscription with vrfCoordinator: %s on chain Id %s",
            vrfCoordinator,
            block.chainid
        );
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator)
            .createSubscription();
        vm.stopBroadcast();

        console.log("Subscription Id: %s", subId);
        console.log("Subscription created successfully");

        return (subId, vrfCoordinator);
    }

    function run() public {}
}

contract FundSubscription is Script, CodeConstants {
    uint256 public constant FUN_AMOUNT = 3 ether; // 3 LINK

    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subId = helperConfig.getConfig().subscriptionId;
        address link = helperConfig.getConfig().link;
        fundSubscription(vrfCoordinator, subId, link);
    }

    function fundSubscription(
        address vrfCoordinator,
        uint256 subId,
        address linkToken
    ) public {
        console.log(
            "Funding subscription with vrfCoordinator: %s, subId: %s, linkToken: %s",
            vrfCoordinator,
            subId,
            linkToken
        );

        if (block.chainid == LOCAL_CHAIN_ID) {
            console.log("Funding subscription on local chain");
            vm.startBroadcast();
            console.log("started broadcadst local");
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(
                subId,
                FUN_AMOUNT
            );
            vm.stopBroadcast();
            console.log("finished broadcast local");
        } else {
            console.log("Funding subscription on remote chain");
            vm.startBroadcast();
            console.log("started broadcast remote");
            LinkToken(linkToken).transferAndCall(
                vrfCoordinator,
                FUN_AMOUNT,
                abi.encode(subId)
            );
            vm.stopBroadcast();
            console.log("finished broadcast remote");
        }

        console.log("Subscription funded successfully");
    }

    function run() public {
        fundSubscriptionUsingConfig();
    }
}

contract AddConsumer is Script {
    function addConsumerUsingConfig(address mostRecentlyDeployed) public {
        HelperConfig helperConfig = new HelperConfig();
        uint256 subId = helperConfig.getConfig().subscriptionId;
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        addConsumer(mostRecentlyDeployed, vrfCoordinator, subId);
    }

    function addConsumer(
        address contractToAddtoVrf,
        address vrfCoordinator,
        uint256 subId
    ) public {
        console.log(
            "Adding consumer with contractToAddtoVrf: %s, vrfCoordinator: %s, subId: %s",
            contractToAddtoVrf,
            vrfCoordinator,
            subId
        );

        vm.startBroadcast();
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(
            subId,
            contractToAddtoVrf
        );
        vm.stopBroadcast();

        console.log("Consumer added successfully");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );
        addConsumerUsingConfig(mostRecentlyDeployed);
    }
}
