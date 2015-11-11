GetDevice = require '../src/get-device'

describe 'GetDevice', ->
  beforeEach ->
    @datastore =
      findOne: sinon.stub()
    @sut = new GetDevice datastore: @datastore

  describe '->do', ->
    describe 'when called with a type query', ->
      beforeEach (done) ->
        @datastore.findOne.yields null, uuid: 'really-great-chevy', type: 'exploding-star'
        job =
          metadata:
            responseId: 'supernova'
          rawData: '{"type":"exploding-star"}'

        @sut.do job, (error, @response) => done error

      it 'should have a responseId', ->
        expect(@response.metadata.responseId).to.equal 'supernova'

      it 'should have a status code of 200', ->
        expect(@response.metadata.code).to.equal 200

      it 'should have a responseId', ->
        expect(@response.metadata.status).to.equal 'OK'

      it 'should have a device in the response', ->
        expect(JSON.parse(@response.rawData)).to.deep.equal uuid: 'really-great-chevy', type: 'exploding-star'

    describe 'when called with a different type query', ->
      beforeEach (done) ->
        @datastore.findOne.yields null, uuid: 'hanged-by-the-british', type: 'put-er-there'
        job =
          metadata:
            responseId: 'welcome-aboard'
          rawData: '{"type":"put-er-there"}'

        @sut.do job, (error, @response) => done error

      it 'should have a responseId', ->
        expect(@response.metadata.responseId).to.equal 'welcome-aboard'

      it 'should have a status code of 200', ->
        expect(@response.metadata.code).to.equal 200

      it 'should have a responseId', ->
        expect(@response.metadata.status).to.equal 'OK'

      it 'should have a device in the response', ->
        expect(JSON.parse(@response.rawData)).to.deep.equal uuid: 'hanged-by-the-british', type: 'put-er-there'

    describe 'when called with an invalid query', ->
      beforeEach (done) ->
        job =
          metadata:
            responseId: 'gallows-humor'
          rawData: 'this should break'

        @sut.do job, (error, @response) => done error

      it 'should have a responseId', ->
        expect(@response.metadata.responseId).to.equal 'gallows-humor'

      it 'should have a status code of 400', ->
        expect(@response.metadata.code).to.equal 400

      it 'should have a responseId', ->
        expect(@response.metadata.status).to.equal 'Bad Request'

    describe 'when findOne yields an error', ->
      beforeEach (done) ->
        @datastore.findOne.yields new Error "it-is-definitely-broke"
        
        job =
          metadata:
            responseId: 'harpoon'
          rawData: '{"$$set":"sweet"}'

        @sut.do job, (error, @response) => done error

      it 'should have a responseId', ->
        expect(@response.metadata.responseId).to.equal 'harpoon'

      it 'should have a status code of 400', ->
        expect(@response.metadata.code).to.equal 500

      it 'should have a responseId', ->
        expect(@response.metadata.status).to.equal 'Internal Server Error'
