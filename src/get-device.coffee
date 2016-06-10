http          = require 'http'
DeviceManager = require 'meshblu-core-manager-device'

class GetDevice
  constructor: ({datastore,uuidAliasResolver}) ->
     @deviceManager = new DeviceManager {datastore, uuidAliasResolver}

  do: (job, callback) =>
    { toUuid } = job.metadata

    @deviceManager.findOne { uuid: toUuid }, (error, device) =>
      return callback error if error?
      return callback null, metadata: code: 404 unless device?

      response =
        metadata:
          code: 200
        data: device

      return callback null, response

module.exports = GetDevice
