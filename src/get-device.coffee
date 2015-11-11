http = require 'http'

class GetDevice
  constructor: ({@datastore}={}) ->

  do: (job, callback) =>
    {responseId} = job.metadata
    try
      query = JSON.parse job.rawData
    catch error
      return callback null, @generateResponse 400, responseId

    @datastore.findOne query, (error, result) =>
      return callback null, @generateResponse 500, responseId if error?
      callback null, @generateResponse 200, responseId, result

  generateResponse: (code, responseId, data) =>
    metadata:
      code: code
      status: http.STATUS_CODES[code]
      responseId: responseId
    rawData: JSON.stringify data

module.exports = GetDevice
