const ArtToken = artifacts.require("../contracts/ArtToken.sol"); 

require("chai").use(require("chai-as-promised")).should();


contract("Art Token" , (accounts) => {
    let token 

    before(async () => {
        token = await ArtToken.deployed(); 
    })

    describe('deployment', async () => {
        it('deploys successfully', async () => {
          const address = token.address
          assert.notEqual(address, 0x0)
          assert.notEqual(address, '')
          assert.notEqual(address, null)
          assert.notEqual(address, undefined)
        })
    
        it('has a name', async () => {
          const name = await token.name()
          assert.equal(name, "ArtToken Collection")
        })
    
 
        describe('token distribution', async () => {
            let result
        
            it('mints tokens', async () => {
                await token.mint( "new token", 'https://www.token-uri.com/nft', 5, true)
        
                // It should increase the total supply
                result = await token.totalSupply()
                assert.equal(result.toString(), '1', 'total supply is correct')
        
                // It increments owner balance
                result = await token.balanceOf(accounts[0])
                assert.equal(result.toString(), '1', 'balanceOf is correct')
        
                // Token should belong to owner
                result = await token.ownerOf('1')
                assert.equal(result.toString(), accounts[0].toString(), 'ownerOf is correct')
                result = await token.tokenOfOwnerByIndex(accounts[0], 0)
        
                // Owner can see all tokens
                let balanceOf = await token.balanceOf(accounts[0])
                let tokenIds = []
                for (let i = 0; i < balanceOf; i++) {
                let id = await token.tokenOfOwnerByIndex(accounts[0], i)
                tokenIds.push(id.toString())
                }
                let expected = ['1']
                assert.equal(tokenIds.toString(), expected.toString(), 'tokenIds are correct')
        
                // Token URI Correct
                let tokenURI = await token.tokenURI('1')
                assert.equal(tokenURI, 'https://www.token-uri.com/nft')


                // check if i can buy a token 
                await token.buyToken("1" , {from: accounts[1] , value: 5});
                result = await token.ownerOf('1') 
                assert.equal(result.toString(), accounts[1].toString(), 'ownerOf is correct')
 
            })
          })
 
 

      })


});