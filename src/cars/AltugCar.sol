// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./Car.sol";

contract AltugCar is Car {
    constructor(Monaco _monaco) Car(_monaco) {}

    function takeYourTurn(Monaco.CarData[] calldata allCars, uint256 myCarIndex)
        external
        override
    {
        Monaco.CarData memory myCar = allCars[myCarIndex];

        // Calculate the amount of acceleration we can buy
        uint256 accelerationAmount = getAccelerationUntilCost(myCar);
        uint256 shellCost = monaco.getShellCost(1);
        uint256 myBalance = myCar.balance;
        uint256 mySpeed = myCar.speed;

        if (myCarIndex == 0) {
            if (myCar.y > 600) {
                // Go crazy on final push by spending the maximum amount
                myBalance -= safeBuyAcceleration(accelerationAmount);
            } else {
                // Try to save money by buying speed until the cost of a shell
                myBalance -= safeBuyAcceleration(
                    getAccelerationUntilShell(myCar)
                );
            }

            if (allCars[1].balance < shellCost) {
                // If previous player has no money, inflate the cost of a shell
                if (myBalance > shellCost) {
                    safeBuyShell(1);
                }
            }
        } else if (myCarIndex == 1) {
            uint256 firstCarSpeed = allCars[0].speed;
            if (firstCarSpeed > mySpeed) {
                uint256 speedDifference = firstCarSpeed - mySpeed;
                uint256 speedDifferencePrice = monaco.getAccelerateCost(
                    speedDifference
                );
                // If the price of a shell is cheaper than trying to catch up,
                // buy a shell to stop the first player
                if (speedDifferencePrice > shellCost) {
                    safeBuyShell(1);
                } else {
                    // Try to catch up to the first place while being economic
                    safeBuyAcceleration(
                        min(speedDifference + 1, accelerationAmount)
                    );
                }
            } else {
                // Get faster economically
                safeBuyAcceleration(accelerationAmount / 2);
            }
        } else {
            // Buy all the acceleration that we can to catch up
            safeBuyAcceleration(accelerationAmount);
        }
    }

    function safeBuyAcceleration(uint256 amount)
        internal
        returns (uint256 cost)
    {
        // Safety net for amount being 0
        if (amount > 0) {
            cost = monaco.buyAcceleration(amount);
        }
    }

    function safeBuyShell(uint256 amount) internal returns (uint256 cost) {
        // Safety net for amount being 0
        if (amount > 0) {
            cost = monaco.buyShell(amount);
        }
    }

    // Calculate the amount of acceleration to buy until the price reaches the
    // price of a shell, limited by the current maximum cost
    function getAccelerationUntilShell(Monaco.CarData memory car)
        internal
        view
        returns (uint256 acceleration)
    {
        uint256 shellCost = monaco.getShellCost(1);
        uint256 accelerationCost = monaco.getAccelerateCost(car.speed);

        if (accelerationCost > shellCost) {
            return 0;
        }

        uint256 balance = min(shellCost - accelerationCost, maxCost(car));
        while (balance > monaco.getAccelerateCost(acceleration + 1)) {
            ++acceleration;
        }
        return acceleration - 1;
    }

    // Calculate the amount of acceleration to buy until the current maximum cost
    function getAccelerationUntilCost(Monaco.CarData memory car)
        internal
        view
        returns (uint256 acceleration)
    {
        uint256 balance = min(car.balance, maxCost(car));
        while (balance > monaco.getAccelerateCost(acceleration + 1)) {
            ++acceleration;
        }
    }

    // Maximum amount of price spent on a move with respect to distance
    function maxCost(Monaco.CarData memory car)
        internal
        pure
        returns (uint256)
    {
        return car.y > 600 ? 2000 : 200;
    }

    // Minimum of the two numbers
    function min(uint256 a, uint256 b) internal pure returns (uint256 _min) {
        _min = a < b ? a : b;
    }
}
