http = require 'http'

class GetDevice
  constructor: ({@datastore,@uuidAliasResolver}) ->

  do: (job, callback) =>
    {toUuid} = job.metadata

    @uuidAliasResolver.resolve toUuid, (error, uuid) =>
      return callback error if error?

      @datastore.findOne {uuid}, (error, result) =>
        return callback error if error?
        return callback null, metadata: code: 404 unless result?

        response =
          metadata:
            code: 200
          data: result

        return callback null, response

module.exports = GetDevice
