BaseRecordsInterface = require 'shared/interfaces/base_records_interface.coffee'

module.exports = class MessageChannelRecordsInterface extends BaseRecordsInterface
  model:
    singular:    'message_channel'
    plural:      'message_channel'
    apiEndpoint: 'message_channel'


  subscribe: (options = {}) ->
    @fetch
      action: 'subscribe'
      params: options