// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { EntityForging } from "contracts/EntityForging.sol";
import { IEntityForging } from "contracts/interfaces/IEntityForging.sol";

contract FixEntityForging is BaseScript {
    uint256[272] indexes = [
        1,
        11,
        10,
        23,
        31,
        35,
        44,
        63,
        71,
        78,
        79,
        88,
        89,
        93,
        99,
        102,
        109,
        111,
        114,
        116,
        120,
        128,
        129,
        148,
        155,
        156,
        164,
        166,
        172,
        178,
        189,
        194,
        199,
        200,
        201,
        214,
        216,
        225,
        258,
        259,
        275,
        276,
        277,
        279,
        280,
        281,
        282,
        283,
        284,
        285,
        286,
        303,
        304,
        305,
        306,
        307,
        308,
        309,
        317,
        318,
        325,
        329,
        344,
        351,
        363,
        365,
        366,
        372,
        379,
        382,
        383,
        387,
        390,
        391,
        398,
        400,
        407,
        410,
        419,
        426,
        433,
        435,
        436,
        437,
        448,
        451,
        462,
        463,
        465,
        469,
        471,
        472,
        473,
        474,
        475,
        477,
        478,
        479,
        480,
        481,
        483,
        484,
        488,
        489,
        491,
        496,
        497,
        504,
        505,
        506,
        507,
        508,
        509,
        510,
        512,
        514,
        515,
        516,
        517,
        518,
        522,
        523,
        524,
        525,
        526,
        527,
        528,
        530,
        531,
        532,
        533,
        535,
        536,
        539,
        540,
        541,
        545,
        546,
        547,
        548,
        549,
        551,
        558,
        559,
        560,
        561,
        564,
        565,
        566,
        567,
        568,
        569,
        570,
        572,
        573,
        575,
        579,
        581,
        582,
        583,
        584,
        588,
        589,
        595,
        603,
        604,
        615,
        621,
        622,
        623,
        630,
        631,
        632,
        633,
        634,
        635,
        636,
        637,
        638,
        639,
        640,
        651,
        670,
        702,
        706,
        709,
        710,
        711,
        712,
        713,
        714,
        730,
        744,
        745,
        747,
        748,
        750,
        762,
        764,
        765,
        766,
        767,
        768,
        769,
        770,
        771,
        772,
        773,
        783,
        784,
        785,
        786,
        794,
        795,
        796,
        799,
        800,
        801,
        802,
        803,
        805,
        806,
        807,
        808,
        809,
        810,
        811,
        812,
        813,
        814,
        815,
        816,
        817,
        818,
        819,
        820,
        821,
        822,
        823,
        824,
        825,
        826,
        827,
        828,
        830,
        831,
        832,
        833,
        834,
        835,
        836,
        837,
        838,
        839,
        840,
        843,
        844,
        845,
        846,
        848,
        852,
        853,
        854,
        855,
        856,
        857,
        858,
        862,
        863,
        864,
        865,
        866
    ];

    EntityForging.Listing[] public listings;
    uint256 public count;

    function run() public virtual initConfig returns (address) {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        // HERE is The former EntityForging address
        address formerEntityForging = AddressProvider(addressProvider).getEntityForging();
        console.log("former EntityForging is at address: ", formerEntityForging);

        // HERE is The new EntityForging address
        address newEntityForging = address(0xe4A3118CdD82eE54e775B8507485A75aAEB3BdE1);
        console.log("new EntityForging is at address: ", newEntityForging);

        /////////////////// MIGRATING DATA ///////////////////
        _migrateEntityForgingData(formerEntityForging, newEntityForging);
        return newEntityForging;
    }

    function _deployEntityForging() internal returns (address) {
        return address(new EntityForging(addressProvider));
    }

    function _migrateEntityForgingData(address _formerEntityForging, address _newEntityForging) internal {
        count = EntityForging(_formerEntityForging).listingCount();
        for (uint256 i = 0; i < indexes.length; i++) {
            EntityForging.Listing memory l = EntityForging(_formerEntityForging).getListings(indexes[i]);
            if (l.isListed) {
                listings.push(l);
                console.log("listing index: ", i);
            }
        }

        console.log("listings: ", listings.length);
        console.log("count: ", count);

        uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(deployerKey);
        EntityForging(_newEntityForging).migrateListingData(listings, 0, 100, count);
        EntityForging(_newEntityForging).migrateListingData(listings, 100, 200, count);
        EntityForging(_newEntityForging).migrateListingData(listings, 200, 272, count);
        vm.stopBroadcast();
    }
}

// // listing index:  1
//  10
//  11
//  23
//  31
//  35
//  44
//  63
//  71
//  78
//  79
//  88
//  89
//  93
//  99
// // listing index:  102
//  109
//  111
//  114
//  116
//  120
//  128
//  129
//  148
//  155
//  156
//  164
//  166
//  172
//  178
//  189
//  194
//  199
//  200
// // listing index:  201
//  214
//  216
//  225
//  258
//  259
//  275
//  276
//  277
//  279
//  280
//  281
//  282
//  283
//  284
//  285
//  286
// // listing index:  303
//  304
//  305
//  306
//  307
//  308
//  309
//  317
//  318
//  325
//  329
//  344
//  351
//  363
//  365
//  366
//  372
//  379
//  382
//  383
//  387
//  390
//  391
//  398
//  400
//  407
//  410
//  419
//  426
//  433
//  435
//  436
//  437
//  448
//  451
//  462
//  463
//  465
//  469
//  471
//  472
//  473
//  474
//  475
//  477
//  478
//  479
//  480
//  481
//  483
//  484
//  488
//  489
//  491
//  496
//  497
//  504
//  505
//  506
//  507
//  508
//  509
//  510
//  512
//  514
//  515
//  516
//  517
//  518
//  522
//  523
//  524
//  525
//  526
//  527
//  528
//  530
//  531
//  532
//  533
//  535
//  536
//  539
//  540
//  541
//  545
//  546
//  547
//  548
//  549
//  551
//  558
//  559
//  560
//  561
//  564
//  565
//  566
//  567
//  568
//  569
//  570
//  572
//  573
//  575
//  579
//  581
//  582
//  583
//  584
//  588
//  589
//  595
//  603
//  604
//  615
//  621
//  622
//  623
//  630
//  631
//  632
//  633
//  634
//  635
//  636
//  637
//  638
//  639
//  640
//  651
//  670
//  702
//  706
//  709
//  710
//  711
//  712
//  713
//  714
//  730
//  744
//  745
//  747
//  748
//  750
//  762
//  764
//  765
//  766
//  767
//  768
//  769
//  770
//  771
//  772
//  773
//  783
//  784
//  785
//  786
//  794
//  795
//  796
//  799
//  800
//  801
//  802
//  803
//  805
//  806
//  807
//  808
//  809
//  810
//  811
//  812
//  813
//  814
//  815
//  816
//  817
//  818
//  819
//  820
//  821
//  822
//  823
//  824
//  825
//  826
//  827
//  828
//  830
//  831
//  832
//  833
//  834
//  835
//  836
//  837
//  838
//  839
//  840
//  843
//  844
//  845
//  846
//  848
//  852
//  853
//  854
//  855
//  856
//  857
//  858
//  862
//  863
//  864
//  865
//  866
