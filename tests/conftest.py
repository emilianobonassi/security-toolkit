import pytest


@pytest.fixture
def deployer(accounts):
    yield accounts[0]


@pytest.fixture
def testERC20(deployer, TestERC20):
    yield TestERC20.deploy({"from": deployer})


@pytest.fixture
def testERC721(deployer, TestERC721):
    yield TestERC721.deploy({"from": deployer})


@pytest.fixture
def testERC1155(deployer, TestERC1155):
    yield TestERC1155.deploy({"from": deployer})
