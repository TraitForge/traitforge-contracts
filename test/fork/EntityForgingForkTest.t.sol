// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { Fork_Test } from "./Fork.t.sol";
import { FixEntityForging } from "script/deployment/FixEntityForging.s.sol";
import { EntityForging } from "contracts/EntityForging.sol";
import { console } from "@forge-std/console.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";

contract EntityForgingForkTest is Fork_Test {
    address sender = 0x225b791581185B73Eb52156942369843E8B0Eec7;
    address whaleETH = 0xF977814e90dA44bFA03b6295A0616a897441aceC;

    uint256[] lowerIds = [
        22,
        // higherId:  694
        1134,
        // h,igherId:  341
        1133,
        // h,igherId:  473
        1133,
        // h,igherId:  199
        1132,
        // h,igherId:  466
        1198,
        // h,igherId:  1456
        1595,
        // h,igherId:  473
        372,
        // h,igherId:  453
        1457,
        // h,igherId:  472
        1258,
        // h,igherId:  543
        1031,
        // h,igherId:  30
        1260,
        // h,igherId:  901
        1249,
        // h,igherId:  1322
        466,
        // h,igherId:  889
        1266,
        // h,igherId:  238
        1253,
        // h,igherId:  597
        244,
        // h,igherId:  470
        1460,
        // h,igherId:  773
        417,
        // h,igherId:  450
        1321,
        // h,igherId:  1485
        1205,
        // h,igherId:  373
        270,
        // h,igherId:  452
        1198,
        // h,igherId:  462
        472,
        // h,igherId:  474
        1271,
        // h,igherId:  1457
        1332,
        // h,igherId:  44
        1139,
        // h,igherId:  1487
        210,
        // h,igherId:  720
        1457,
        // h,igherId:  598
        1199,
        // h,igherId:  1486
        1197,
        // h,igherId:  1199
        162,
        // h,igherId:  372
        1524,
        // h,igherId:  1632
        1671,
        // h,igherId:  474
        1199,
        // h,igherId:  443
        466,
        // h,igherId:  474
        1694,
        // h,igherId:  417
        1723,
        // h,igherId:  1763
        290,
        // h,igherId:  730
        1672,
        // h,igherId:  1691
        1266,
        // h,igherId:  479
        1691,
        // h,igherId:  1769
        1737,
        // h,igherId:  1785
        1752,
        // h,igherId:  1769
        1715,
        // h,igherId:  470
        470,
        // h,igherId:  474
        1670,
        // h,igherId:  1762
        472,
        // h,igherId:  772
        1762,
        // h,igherId:  476
        1752,
        // h,igherId:  1795
        1341,
        // h,igherId:  24
        1691,
        // h,igherId:  1799
        1762,
        // h,igherId:  475
        310,
        // h,igherId:  620
        1791,
        // h,igherId:  1793
        1330,
        // h,igherId:  853
        1781,
        // h,igherId:  344
        69,
        // h,igherId:  691
        1772,
        // h,igherId:  474
        1517,
        // h,igherId:  1585
        1762,
        // h,igherId:  468
        38,
        // h,igherId:  991
        1762,
        // h,igherId:  469
        1762,
        // h,igherId:  1773
        1680,
        // h,igherId:  1812
        1671,
        // h,igherId:  469
        1671,
        // h,igherId:  1773
        1670,
        // h,igherId:  1671
        1768,
        // h,igherId:  1817
        1772,
        // h,igherId:  1773
        1079,
        // h,igherId:  1196
        1460,
        // h,igherId:  1490
        1773,
        // h,igherId:  466
        1773,
        // h,igherId:  472
        1793,
        // h,igherId:  1826
        385,
        // h,igherId:  70
        1196,
        // h,igherId:  1199
        1773,
        // h,igherId:  470
        1079,
        // h,igherId:  1460
        1516,
        // h,igherId:  829
        1196,
        // h,igherId:  1457
        1460,
        // h,igherId:  1462
        241,
        // h,igherId:  624
        1196,
        // h,igherId:  1485
        1079,
        // h,igherId:  1461
        1199,
        // h,igherId:  1460
        1490,
        // h,igherId:  1612
        1490,
        // h,igherId:  38
        1831,
        // h,igherId:  1840
        1838,
        // h,igherId:  1840
        1802,
        // h,igherId:  1833
        478,
        // h,igherId:  77
        1079,
        // h,igherId:  1776
        1717,
        // h,igherId:  1829
        1723,
        // h,igherId:  1835
        1839,
        // h,igherId:  1840
        1853,
        // h,igherId:  1855
        1842,
        // h,igherId:  1843
        1854,
        // h,igherId:  290
        1134,
        // h,igherId:  640
        1824,
        // h,igherId:  1831
        372,
        // h,igherId:  637
        1351,
        // h,igherId:  349
        1838,
        // h,igherId:  1841
        1677,
        // h,igherId:  33
        1793,
        // h,igherId:  1889
        1691,
        // h,igherId:  1889
        1473,
        // h,igherId:  1683
        1843,
        // h,igherId:  1888
        1855,
        // h,igherId:  1888
        1858,
        // h,igherId:  1898
        1858,
        // h,igherId:  1899
        1840,
        // h,igherId:  1849
        1853,
        // h,igherId:  1902
        1888,
        // h,igherId:  1902
        1530,
        // h,igherId:  914
        1037,
        // h,igherId:  443
        25,
        // h,igherId:  290
        1903,
        // h,igherId:  1904
        1882,
        // h,igherId:  1902
        1668,
        // h,igherId:  1907
        1772,
        // h,igherId:  1857
        1671,
        // h,igherId:  1857
        1762,
        // h,igherId:  1857
        1490,
        // h,igherId:  1776
        1849,
        // h,igherId:  1915
        1841,
        // h,igherId:  1849
        1902,
        // h,igherId:  1919
        1909,
        // h,igherId:  1920
        1843,
        // h,igherId:  1918
        1857,
        // h,igherId:  466
        1857,
        // h,igherId:  472
        1079,
        // h,igherId:  1171
        1793,
        // h,igherId:  1924
        1822,
        // h,igherId:  1837
        1841,
        // h,igherId:  1925
        1796,
        // h,igherId:  1926
        1827,
        // h,igherId:  1926
        1803,
        // h,igherId:  1926
        1772,
        // h,igherId:  1934
        1671,
        // h,igherId:  1934
        1843,
        // h,igherId:  1928
        1857,
        // h,igherId:  1933
        1935,
        // h,igherId:  474
        1773,
        // h,igherId:  1933
        1857,
        // h,igherId:  1935
        1773,
        // h,igherId:  1935
        1797,
        // h,igherId:  69
        1902,
        // h,igherId:  1928
        1831,
        // h,igherId:  1906
        1922,
        // h,igherId:  1950
        1813,
        // h,igherId:  1942
        1818,
        // h,igherId:  1942
        1855,
        // h,igherId:  1928
        1795,
        // h,igherId:  1942
        1904,
        // h,igherId:  1950
        1253,
        // h,igherId:  1497
        1819,
        // h,igherId:  1942
        1913,
        // h,igherId:  1942
        1899,
        // h,igherId:  1922
        1912,
        // h,igherId:  1942
        1035,
        // h,igherId:  1079
        1840,
        // h,igherId:  1925
        1919,
        // h,igherId:  1965
        1922,
        // h,igherId:  1966
        1196,
        // h,igherId:  1221
        1079,
        // h,igherId:  1970
        1840,
        // h,igherId:  1971
        1915,
        // h,igherId:  1971
        1919,
        // h,igherId:  1973
        1904,
        // h,igherId:  1975
        1832,
        // h,igherId:  70
        2016,
        // h,igherId:  624
        421,
        // h,igherId:  629
        1231,
        // h,igherId:  2010
        1484,
        // h,igherId:  1488
        1196,
        // h,igherId:  1204
        1194,
        // h,igherId:  2033
        1982,
        // h,igherId:  999
        1462,
        // h,igherId:  1970
        1833,
        // h,igherId:  1907
        1925,
        // h,igherId:  2042
        1260,
        // h,igherId:  1293
        1844,
        // h,igherId:  1855
        2032,
        // h,igherId:  2037
        1829,
        // h,igherId:  2037
        1330,
        // h,igherId:  2046
        1204,
        // h,igherId:  1486
        1028,
        // h,igherId:  1460
        1907,
        // h,igherId:  2031
        2067,
        // h,igherId:  913
        165,
        // h,igherId:  25
        1903,
        // h,igherId:  1930
        1996,
        // h,igherId:  77
        1750,
        // h,igherId:  350
        1711,
        // h,igherId:  1914
        1711,
        // h,igherId:  1815
        1711,
        // h,igherId:  1801
        1833,
        // h,igherId:  2074
        1711,
        // h,igherId:  1820
        1711,
        // h,igherId:  1936
        1711,
        // h,igherId:  1819
        1711,
        // h,igherId:  1813
        1926,
        // h,igherId:  1956
        1936,
        // h,igherId:  1969
        2091,
        // h,igherId:  2101
        1966,
        // h,igherId:  2102
        1861,
        // h,igherId:  726
        199,
        // h,igherId:  1996
        548,
        // h,igherId:  586
        1221,
        // h,igherId:  132
        1054,
        // h,igherId:  1072
        1996,
        // h,igherId:  466
        1902,
        // h,igherId:  2049
        1904,
        // h,igherId:  2114
        1853,
        // h,igherId:  1973
        1856,
        // h,igherId:  2116
        1462,
        // h,igherId:  724
        1925,
        // h,igherId:  2118
        1971,
        // h,igherId:  2118
        1838,
        // h,igherId:  2118
        1888,
        // h,igherId:  2121
        1919,
        // h,igherId:  2120
        1919,
        // h,igherId:  2119
        1939,
        // h,igherId:  2114
        1974,
        // h,igherId:  2120
        1966,
        // h,igherId:  2126
        1975,
        // h,igherId:  2126
        2122,
        // h,igherId:  2126
        2125,
        // h,igherId:  2129
        2115,
        // h,igherId:  2128
        1908
        // h,igherId:  2127
    ];
    uint256[] higherIds = [
        694,
        // 1134
        341,
        // 1133
        473,
        // 1133
        199,
        // 1132
        466,
        // 1198
        1456,
        // 1,595
        473,
        // 3,72
        453,
        // 1,457
        472,
        // 1,258
        543,
        // 1,031
        30,
        // 1,260
        901,
        // 1,249
        1322,
        // 4,66
        889,
        // 1,266
        238,
        // 1,253
        597,
        // 2,44
        470,
        // 1,460
        773,
        // 4,17
        450,
        // 1,321
        1485,
        // 1,205
        373,
        // 2,70
        452,
        // 1,198
        462,
        // 4,72
        474,
        // 1,271
        1457,
        // 1,332
        44,
        // 1,139
        1487,
        // 2,10
        720,
        // 1,457
        598,
        // 1,199
        1486,
        // 1,197
        1199,
        // 1,62
        372,
        // 1,524
        1632,
        // 1,671
        474,
        // 1,199
        443,
        // 4,66
        474,
        // 1,694
        417,
        // 1,723
        1763,
        // 2,90
        730,
        // 1,672
        1691,
        // 1,266
        479,
        // 1,691
        1769,
        // 1,737
        1785,
        // 1,752
        1769,
        // 1,715
        470,
        // 4,70
        474,
        // 1,670
        1762,
        // 4,72
        772,
        // 1,762
        476,
        // 1,752
        1795,
        // 1,341
        24,
        // 1,691
        1799,
        // 1,762
        475,
        // 3,10
        620,
        // 1,791
        1793,
        // 1,330
        853,
        // 1,781
        344,
        // 6,9
        691,
        // 1,772
        474,
        // 1,517
        1585,
        // 1,762
        468,
        // 3,8
        991,
        // 1,762
        469,
        // 1,762
        1773,
        // 1,680
        1812,
        // 1,671
        469,
        // 1,671
        1773,
        // 1,670
        1671,
        // 1,768
        1817,
        // 1,772
        1773,
        // 1,079
        1196,
        // 1,460
        1490,
        // 1,773
        466,
        // 1,773
        472,
        // 1,793
        1826,
        // 3,85
        70,
        // 1,196
        1199,
        // 1,773
        470,
        // 1,079
        1460,
        // 1,516
        829,
        // 1,196
        1457,
        // 1,460
        1462,
        // 2,41
        624,
        // 1,196
        1485,
        // 1,079
        1461,
        // 1,199
        1460,
        // 1,490
        1612,
        // 1,490
        38,
        // 1,831
        1840,
        // 1,838
        1840,
        // 1,802
        1833,
        // 4,78
        77,
        // 1,079
        1776,
        // 1,717
        1829,
        // 1,723
        1835,
        // 1,839
        1840,
        // 1,853
        1855,
        // 1,842
        1843,
        // 1,854
        290,
        // 1,134
        640,
        // 1,824
        1831,
        // 3,72
        637,
        // 1,351
        349,
        // 1,838
        1841,
        // 1,677
        33,
        // 1,793
        1889,
        // 1,691
        1889,
        // 1,473
        1683,
        // 1,843
        1888,
        // 1,855
        1888,
        // 1,858
        1898,
        // 1,858
        1899,
        // 1,840
        1849,
        // 1,853
        1902,
        // 1,888
        1902,
        // 1,530
        914,
        // 1,037
        443,
        // 2,5
        290,
        // 1,903
        1904,
        // 1,882
        1902,
        // 1,668
        1907,
        // 1,772
        1857,
        // 1,671
        1857,
        // 1,762
        1857,
        // 1,490
        1776,
        // 1,849
        1915,
        // 1,841
        1849,
        // 1,902
        1919,
        // 1,909
        1920,
        // 1,843
        1918,
        // 1,857
        466,
        // 1,857
        472,
        // 1,079
        1171,
        // 1,793
        1924,
        // 1,822
        1837,
        // 1,841
        1925,
        // 1,796
        1926,
        // 1,827
        1926,
        // 1,803
        1926,
        // 1,772
        1934,
        // 1,671
        1934,
        // 1,843
        1928,
        // 1,857
        1933,
        // 1,935
        474,
        // 1,773
        1933,
        // 1,857
        1935,
        // 1,773
        1935,
        // 1,797
        69,
        // 1,902
        1928,
        // 1,831
        1906,
        // 1,922
        1950,
        // 1,813
        1942,
        // 1,818
        1942,
        // 1,855
        1928,
        // 1,795
        1942,
        // 1,904
        1950,
        // 1,253
        1497,
        // 1,819
        1942,
        // 1,913
        1942,
        // 1,899
        1922,
        // 1,912
        1942,
        // 1,035
        1079,
        // 1,840
        1925,
        // 1,919
        1965,
        // 1,922
        1966,
        // 1,196
        1221,
        // 1,079
        1970,
        // 1,840
        1971,
        // 1,915
        1971,
        // 1,919
        1973,
        // 1,904
        1975,
        // 1,832
        70,
        // 2,016
        624,
        // 4,21
        629,
        // 1,231
        2010,
        // 1,484
        1488,
        // 1,196
        1204,
        // 1,194
        2033,
        // 1,982
        999,
        // 1,462
        1970,
        // 1,833
        1907,
        // 1,925
        2042,
        // 1,260
        1293,
        // 1,844
        1855,
        // 2,032
        2037,
        // 1,829
        2037,
        // 1,330
        2046,
        // 1,204
        1486,
        // 1,028
        1460,
        // 1,907
        2031,
        // 2,067
        913,
        // 1,65
        25,
        // 1,903
        1930,
        // 1,996
        77,
        // 1,750
        350,
        // 1,711
        1914,
        // 1,711
        1815,
        // 1,711
        1801,
        // 1,833
        2074,
        // 1,711
        1820,
        // 1,711
        1936,
        // 1,711
        1819,
        // 1,711
        1813,
        // 1,926
        1956,
        // 1,936
        1969,
        // 2,091
        2101,
        // 1,966
        2102,
        // 1,861
        726,
        // 1,99
        1996,
        // 5,48
        586,
        // 1,221
        132,
        // 1,054
        1072,
        // 1,996
        466,
        // 1,902
        2049,
        // 1,904
        2114,
        // 1,853
        1973,
        // 1,856
        2116,
        // 1,462
        724,
        // 1,925
        2118,
        // 1,971
        2118,
        // 1,838
        2118,
        // 1,888
        2121,
        // 1,919
        2120,
        // 1,919
        2119,
        // 1,939
        2114,
        // 1,974
        2120,
        // 1,966
        2126,
        // 1,975
        2126,
        // 2,122
        2126,
        // 2,125
        2129,
        // 2,115
        2128,
        // 1,908
        2127
    ];

    function setUp() public override {
        super.setUp();
        AddressProvider ap = AddressProvider(addressProvider);
        vm.prank(whaleETH);
        payable(sender).call{ value: 1 ether }("");
    }

    function test_listForForging() public {
        uint256 price = TraitForgeNft(traitForgeNft).calculateMintPrice();
        bytes32[] memory proofs = new bytes32[](0);
        vm.startPrank(sender);
        uint256 tokenId = TraitForgeNft(traitForgeNft).mintToken{ value: price }(proofs);
        console.log("tokenId: ", tokenId);
        EntityForging(entityForging).listForForging(tokenId, 1 ether);
        EntityForging.Listing memory listing = EntityForging(entityForging).getListingForTokenId(tokenId);
        assertEq(listing.tokenId, tokenId);
        assertEq(listing.fee, 1 ether);
        assertEq(listing.isListed, true);
        assertEq(listing.account, sender);

        // now we cancel the listing
        EntityForging(entityForging).cancelListingForForging(tokenId);
        EntityForging.Listing memory listing1 = EntityForging(entityForging).getListingForTokenId(tokenId);
        assertEq(listing1.tokenId, 0);
        assertEq(listing1.fee, 0);
        assertEq(listing1.isListed, false);
        assertEq(listing1.account, address(0));
    }

    function test_forgeFork() public {
        uint256 balanceBf = nukeFund.balance;
        vm.prank(sender);
        EntityForging(entityForging).forgeWithListed{ value: 0.048708 ether }(697, 1132);
        console.log("balance: ", nukeFund.balance - balanceBf);
    }

    function test_compareMigratedForgePairsData() public {
        for (uint256 i = 0; i < lowerIds.length; i++) {
            bool forged = EntityForging(entityForging).forgedPairs(lowerIds[i], higherIds[i]);
            assertEq(forged, true);
        }
    }
}
