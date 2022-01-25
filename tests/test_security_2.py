import brownie


def test_security_2(Security2, testERC20, deployer, accounts):
    # test can be executed only when paused by governance

    operator = accounts[1]
    governance = accounts[2]
    otherUser = accounts[3]

    s = Security2.deploy(governance, operator, {"from": deployer})

    amt = 100
    testERC20.mint(s, amt)
    assert testERC20.balanceOf(s) == amt

    data = testERC20.transfer.encode_input(governance, amt)

    with brownie.reverts("Pausable: not paused"):
        s.emergencyExecute(testERC20, 0, data, False, 200000, {"from": operator})

    s.SCRAM({"from": governance})

    with brownie.reverts("Only Governance"):
        s.emergencyExecute(testERC20, 0, data, False, 200000, {"from": operator})

    with brownie.reverts("Only Governance"):
        s.emergencyExecute(testERC20, 0, data, False, 200000, {"from": otherUser})

    s.emergencyExecute(testERC20, 0, data, False, 200000, {"from": governance})

    assert testERC20.balanceOf(governance) == amt
