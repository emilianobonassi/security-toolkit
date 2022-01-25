import brownie
import sha3


def test_security_4(
    TestSecurity4, TestEmergencyImplementation, deployer, accounts, chain
):
    # only allowlist can execute when set
    # operators and gov can allowlist
    # operators cannot disallow
    # governance can disallow

    operator = accounts[1]
    governance = accounts[2]
    otherUser = accounts[3]

    tei = TestEmergencyImplementation.deploy({"from": deployer})

    s = TestSecurity4.deploy(governance, operator, tei, {"from": deployer})

    s.functionToReplace({"from": otherUser})

    with brownie.reverts("Only Governance"):
        s.enableAllowlist({"from": operator})

    s.enableAllowlist({"from": governance})
    assert s.allowlistEnabled() == True

    with brownie.reverts("User not allowed"):
        s.functionToReplace({"from": otherUser})

    s.allow([otherUser], {"from": governance})
    s.allow([otherUser], {"from": operator})

    s.functionToReplace({"from": otherUser})

    with brownie.reverts("Only Governance"):
        s.disallow([otherUser], {"from": operator})

    s.disallow([otherUser], {"from": governance})

    s.disableAllowlist({"from": governance})
    assert s.allowlistEnabled() == False

    with brownie.reverts("Only Governance"):
        s.disableAllowlist({"from": operator})

    s.functionToReplace({"from": otherUser})
