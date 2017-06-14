request = require 'request'

module.exports = (options, maxRequests, interval = 1000) ->
    new Promise (resolve, reject) ->
        success = options.success or 200
        delete options.success
        errorMessage = options.errorMessage or 'No success.'
        delete options.errorMessage

        makeRequest = (intervalID) ->
            request options, (error, response, body) ->
                if response?.statusCode is success
                    clearInterval intervalID
                    resolve response

        requests = 0
        intervalID = setInterval ->
            if ++requests is maxRequests
                clearInterval intervalID
                reject errorMessage
            makeRequest intervalID
        , interval
        makeRequest()