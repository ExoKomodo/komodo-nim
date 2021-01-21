import unittest

import komodo/core

test "Test game":
    var game = newGame()

    checkpoint("Running game...")
    game.run()
