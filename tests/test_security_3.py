import brownie
import sha3


def test_security_3(
    TestImplementation, TestEmergencyImplementation, deployer, accounts, chain
):
    # test can be executed only when paused by governance

    operator = accounts[1]
    governance = accounts[2]

    tei = TestEmergencyImplementation.deploy({"from": deployer})

    s = TestImplementation.deploy(governance, operator, tei, {"from": deployer})

    assert s.emergencyImplementation() == tei.address

    tx = s.functionToReplace()

    assert "TestEvent" in tx.events

    s.SCRAM({"from": governance})

    tx = s.functionToReplace()

    k = sha3.keccak_256()
    k.update(b"TestEmergencyEvent()")

    assert tx.events[0]["topic1"] == "0x" + k.hexdigest()

    with brownie.reverts("Only Governance"):
        s.setEmergencyImplementation(operator, {"from": operator})

    s.setEmergencyImplementation(operator, {"from": governance})
