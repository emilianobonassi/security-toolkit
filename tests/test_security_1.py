import brownie


def test_security_1(TestSecurity1, testERC20, testERC721, deployer, accounts, chain):
    # - can be paused by operator or governance
    # - unpaused only by governance
    # - withdraw only whenPaused by governance
    # - governance operator change addresses

    operator = accounts[1]
    governance = accounts[2]
    otherUser = accounts[3]

    s = TestSecurity1.deploy(governance, operator, {"from": deployer})

    assert s.governance() == governance
    assert s.operator() == operator

    # Test pause
    with brownie.reverts("Only Operator or Governance"):
        s.SCRAM({"from": otherUser})

    s.SCRAM({"from": operator})
    assert s.paused() == True
    chain.undo()

    s.SCRAM({"from": governance})
    assert s.paused() == True

    # Test unpause
    with brownie.reverts("Only Governance"):
        s.unpause({"from": otherUser})

    with brownie.reverts("Only Governance"):
        s.unpause({"from": operator})

    s.unpause({"from": governance})
    assert s.paused() == False

    # Test withdraw
    amt = 100
    testERC20.mint(s, amt)
    assert testERC20.balanceOf(s) == amt

    with brownie.reverts("Pausable: not paused"):
        s.emergencyWithdrawERC20ETH(testERC20, {"from": governance})

    chain.snapshot()

    s.SCRAM({"from": governance})

    with brownie.reverts("Only Governance"):
        s.emergencyWithdrawERC20ETH(testERC20, {"from": operator})

    with brownie.reverts("Only Governance"):
        s.emergencyWithdrawERC20ETH(testERC20, {"from": otherUser})

    s.emergencyWithdrawERC20ETH(testERC20, {"from": governance})

    assert testERC20.balanceOf(governance) == amt

    chain.revert()

    deployer.transfer(s, amt)
    addressZero = "0x0000000000000000000000000000000000000000"
    assert s.balance() == amt

    chain.snapshot()

    s.SCRAM({"from": governance})

    with brownie.reverts("Only Governance"):
        s.emergencyWithdrawERC20ETH(addressZero, {"from": operator})

    with brownie.reverts("Only Governance"):
        s.emergencyWithdrawERC20ETH(addressZero, {"from": otherUser})

    prebalance = governance.balance()

    s.emergencyWithdrawERC20ETH(addressZero, {"from": governance})

    assert governance.balance() - prebalance == amt

    chain.revert()

    tokenId = 123
    testERC721.mint(deployer, tokenId)
    testERC721.transferFrom(deployer, s, tokenId)
    assert testERC721.ownerOf(tokenId) == s.address

    chain.snapshot()

    s.SCRAM({"from": governance})

    with brownie.reverts("Only Governance"):
        s.emergencyWithdrawERC721(testERC721, tokenId, True, {"from": operator})

    with brownie.reverts("Only Governance"):
        s.emergencyWithdrawERC721(testERC721, tokenId, True, {"from": otherUser})

    s.emergencyWithdrawERC721(testERC721, tokenId, True, {"from": governance})

    assert testERC721.ownerOf(tokenId) == governance.address

    chain.revert()

    # Only governance can change operator

    chain.snapshot()

    with brownie.reverts("Only Governance"):
        s.setOperator(deployer, {"from": otherUser})

    with brownie.reverts("Only Governance"):
        s.setOperator(deployer, {"from": operator})

    s.setOperator(deployer, {"from": governance})

    assert s.operator() == deployer.address

    chain.revert()

    # Only governance can change governance

    chain.snapshot()

    with brownie.reverts("Only Governance"):
        s.setGovernance(deployer, {"from": otherUser})

    with brownie.reverts("Only Governance"):
        s.setGovernance(deployer, {"from": operator})

    s.setGovernance(deployer, {"from": governance})
    assert s.governance() == governance.address

    with brownie.reverts("Only Proposed Governance"):
        s.acceptGovernance({"from": otherUser})

    with brownie.reverts("Only Proposed Governance"):
        s.acceptGovernance({"from": operator})

    with brownie.reverts("Only Proposed Governance"):
        s.acceptGovernance({"from": governance})

    s.acceptGovernance({"from": deployer})
    assert s.governance() == deployer.address

    chain.revert()
