defmodule SampleConsumer do
  require Logger
  use PubSub.Consumer

  consume %{id: _id} do
    Logger.info(fn -> "Got message with ID" end)
  end

  consume message do
    Logger.info(fn -> "Message: #{message}" end)
  end
end
