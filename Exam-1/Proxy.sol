// implement a proxy contract that accepts any function call and forwards it to a target contract.
// The function signatures/paramaters needed are provided but you will need to create your own state variables
pragma solidity ^0.4.24;

contract Proxy {
    address target;

  constructor(address _target) {
      target = _target;
  }

  function() {
      require(target != address(0));
      assembly {
        let ptr := mload(0x40)
        calldatacopy(ptr, 0, calldatasize)
        let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
        let size := returndatasize
        returndatacopy(ptr, 0, size)

        switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
  }

  function execute() returns (bool) {
      require(target != address(0));
      assembly {
        let ptr := mload(0x40)
        calldatacopy(ptr, 0, calldatasize)
        let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
        let size := returndatasize
        returndatacopy(ptr, 0, size)

        switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
  }
}