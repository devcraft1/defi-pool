// SPDX-License-Identifier:MIT
// pragma solidity >=0.4.24 <0.9.0;

// import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/evm-contracts/src/v0.4/ChainlinkClient.sol";
// import "github.com/Arachnid/solidity-stringutils/strings.sol";

// contract TeslaConsumer is ChainlinkClient {
//     using strings for *;

//     uint256 odometer;
//     uint256 chargeState;
//     int256 vehicleLongitude;
//     int256 vehicleLatitude;

//     address private oracle;
//     bytes32 private jobId;
//     uint256 private constant fee = 0.1 * 1 ether;

//     event vehicleDetails(
//         uint256 _odometer,
//         uint256 _chargeState,
//         int256 _vehicleLongitude,
//         int256 _vehicleLatitude
//     );

//     /**
//      * Network: Kovan
//      * Oracle: Chainlink - 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
//      * Job ID: Chainlink - 29fa9aa13bf1468788b7cc4a500a45b8
//      * Fee: 0.1 LINK
//      */
//     constructor() public {
//         setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
//         setChainlinkOracle(0x4accF1064d662eBC5341D418B0656552B7385500);
//         jobId = "d3f74dc2467e42ebb96f496ef731ebec";
//     }

//     /**
//      * Create a Chainlink request to retrieve API response, find the target
//      * data, then multiply by 1000000000000000000 (to remove decimal places from data).
//      */
//     function unlockVehicle(string memory _vehicleId) public {
//         Chainlink.Request memory req = buildChainlinkRequest(
//             jobId,
//             address(this),
//             this.unlockVehicleCallback.selector
//         );
//         req.add("apiToken", "");
//         req.add("vehicleId", _vehicleId);
//         req.add("action", "unlock");
//         sendChainlinkRequestTo(chainlinkOracleAddress(), req, fee);
//     }

//     /**
//      * Create a Chainlink request to retrieve API response, find the target
//      * data, then multiply by 1000000000000000000 (to remove decimal places from data).
//      */
//     function unlockVehicleCallback(bytes32 _requestId, bytes32 _vehicleData)
//         public
//         recordChainlinkFulfillment(_requestId)
//     {
//         //first split the results into individual strings based on the delimiter
//         var s = bytes32ToString(_vehicleData).toSlice();
//         var delim = ",".toSlice();

//         //store each string in an array
//         string[] memory splitResults = new string[](s.count(delim) + 1);
//         for (uint256 i = 0; i < splitResults.length; i++) {
//             splitResults[i] = s.split(delim).toString();
//         }

//         //Now for each one, convert to uint
//         odometer = stringToUint(splitResults[0]);
//         chargeState = stringToUint(splitResults[1]);
//         uint256 tmpLongitude = stringToUint(splitResults[2]);
//         uint256 tmpLatitude = stringToUint(splitResults[3]);

//         //Now store location coordinates in signed variables. Will always be positive, but will check in the next step if need to make negative
//         vehicleLongitude = int256(tmpLongitude);
//         vehicleLatitude = int256(tmpLatitude);

//         //Finally, check first byte in the string for the location variables. If it was a '-', then multiply location coordinate by -1
//         //first get the first byte of each location coordinate string
//         bytes memory longitudeBytes = bytes(splitResults[2]);
//         bytes memory latitudeBytes = bytes(splitResults[3]);

//         //First check longitude
//         if (uint256(longitudeBytes[0]) == 0x2d) {
//             //first byte was a '-', multiply result by -1
//             vehicleLongitude = vehicleLongitude * -1;
//         }

//         //Now check latitude
//         if (uint256(latitudeBytes[0]) == 0x2d) {
//             //first byte was a '-', multiply result by -1
//             vehicleLatitude = vehicleLatitude * -1;
//         }

//         //Emit an event with the vehicle data
//         emit vehicleDetails(
//             odometer,
//             chargeState,
//             vehicleLongitude,
//             vehicleLatitude
//         );
//     }

//     function getVehicleData()
//         public
//         view
//         returns (
//             uint256,
//             uint256,
//             int256,
//             int256
//         )
//     {
//         return (odometer, chargeState, vehicleLongitude, vehicleLatitude);
//     }

//     function bytes32ToString(bytes32 x) constant returns (string memory) {
//         bytes memory bytesString = new bytes(32);
//         uint256 charCount = 0;
//         for (uint256 j = 0; j < 32; j++) {
//             bytes1 char = bytes1(bytes32(uint256(x) * 2**(8 * j)));
//             if (char != 0) {
//                 bytesString[charCount] = char;
//                 charCount++;
//             }
//         }
//         bytes memory bytesStringTrimmed = new bytes(charCount);
//         for (j = 0; j < charCount; j++) {
//             bytesStringTrimmed[j] = bytesString[j];
//         }
//         return string(bytesStringTrimmed);
//     }

//     function stringToUint(string memory s) constant returns (uint256 result) {
//         bytes memory b = bytes(s);
//         uint256 i;
//         result = 0;

//         for (i = 0; i < b.length; i++) {
//             uint256 c = uint256(b[i]);
//             if (c >= 48 && c <= 57) {
//                 result = result * 10 + (c - 48);
//             }
//         }
//     }
// }
