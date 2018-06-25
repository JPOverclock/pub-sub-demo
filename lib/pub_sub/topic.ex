defmodule PubSub.Topic do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, {name, [], []}, name: {:global, name})
  end

  def init({name, subscribers, messages}) do
    {:ok, %{name: name, subscribers: subscribers, messages: messages}}
  end

  def subscribe(topic, subscriber) do
    topic |> GenServer.cast({:subscribe, subscriber})
  end

  def publish(topic, message) do
    topic |> GenServer.cast({:publish, message})
  end

  def get_name(topic) do
    topic |> GenServer.call({:get_name})
  end

  def handle_cast({:subscribe, subscriber}, %{subscribers: subscribers, messages: messages, name: name} = state) do
    subscriber |> send_messages(name, messages)
    {:noreply, %{state | subscribers: [subscriber | subscribers]}}
  end

  def handle_cast({:publish, message}, %{subscribers: subscribers, messages: messages, name: name} = state) do
    subscribers
      |> Task.async_stream(fn(sub) -> send_message(sub, name, message) end)
      |> Enum.to_list()
    {:noreply, %{state | messages: [message | messages]}}
  end

  def handle_call({:get_name}, _from, %{name: name} = state) do
    {:reply, name, state}
  end

  defp send_messages(subscriber, name, messages) do
    messages
      |> Task.async_stream(fn(msg) -> send_message(subscriber, name, msg) end)
      |> Enum.to_list()
  end

  defp send_message(subscriber, name, message) do
    subscriber |> GenServer.cast({:deliver, name, message})
  end
end
