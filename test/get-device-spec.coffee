mongojs = require 'mongojs'
Datastore = require 'meshblu-core-datastore'
MongoKey  = require 'meshblu-core-manager-device/src/mongo-key'
GetDevice = require '../'

describe 'GetDevice', ->
  beforeEach (done) ->
    database = mongojs('meshblu-core-task-get-device', ['devices'])
    @datastore = new Datastore {
      database,
      collection: 'devices'
    }

    database.devices.remove done

  beforeEach ->
    @uuidAliasResolver = resolve: (uuid, callback) => callback(null, uuid)
    @sut = new GetDevice {@datastore, @uuidAliasResolver}

  describe '->do', ->
    describe 'when the device does not exist in the datastore', ->
      beforeEach (done) ->
        request =
          metadata:
            responseId: 'used-as-biofuel'
            auth:
              uuid: 'thank-you-for-considering'
              token: 'the-environment'
            toUuid: 'thank-you-for-considering'

        @sut.do request, (error, @response) => done error

      it 'should respond with a 404', ->
        expect(@response.metadata.code).to.equal 404

    describe 'when the device does exists in the datastore', ->
      beforeEach (done) ->
        record =
          uuid: 'thank-you-for-considering'
          token: 'never-gonna-guess-me'
          meshblu:
            tokens:
              'GpJaXFa3XlPf657YgIpc20STnKf2j+DcTA1iRP5JJcg=': {}
        @datastore.insert record, done

      describe 'when called', ->
        beforeEach (done) ->
          request =
            metadata:
              responseId: 'used-as-biofuel'
              auth:
                uuid: 'thank-you-for-considering'
                token: 'the-environment'
              toUuid: 'thank-you-for-considering'

          @sut.do request, (error, @response) => done error

        it 'should respond with a 200', ->
          expect(@response.metadata.code).to.equal 200

        it 'should return the data', ->
          expect(@response.data).to.contain uuid: 'thank-you-for-considering'

    describe 'when the device with an escaped key exists', ->
      beforeEach (done) ->
        record =
          uuid: 'i-hate-you-for-considering'
          token: 'never-gonna-guess-me-haha'
          online: true
          cheeseburger: 'yes'
          meshblu:
            tokens:
              'GpJaXFa3XlPf657YgIpc20STnKf2j+DcTA1iRP5JJcg=': {}

        record[MongoKey.escape('$foo')] = 'bar'

        @datastore.insert record, done

      describe 'when called', ->
        beforeEach (done) ->
          request =
            metadata:
              responseId: 'used-as-biofuel'
              auth:
                uuid: 'i-hate-you-for-considering'
                token: 'never-gonna-guess-me-haha'
              toUuid: 'i-hate-you-for-considering'

          @sut.do request, (error, @response) => done error

        it 'should respond with a 200', ->
          expect(@response.metadata.code).to.equal 200

        it 'should return the data', ->
          expect(@response.data.uuid).to.equal 'i-hate-you-for-considering'
          expect(@response.data.$foo).to.equal 'bar'
          expect(@response.data.cheeseburger).to.equal 'yes'
