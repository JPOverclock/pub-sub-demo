defmodule PubSub do
  def create_topic(name) do
    topic = {PubSub.Topic, name}
    DynamicSupervisor.start_child(PubSub.Topic.DynamicSupervisor, topic)
  end

  def publish(:undefined, _) do
    {:error, "Topic does not exist"}
  end

  def publish(topic, message) when is_pid(topic) do
    topic |> PubSub.Topic.publish(message)
  end

  def publish(topic, message) when is_atom(topic) do
    topic = :global.whereis_name(topic)
    topic |> publish(message)
  end

  def subscribe(:undefined, _) do
    {:error, "Topic does not exist"}
  end

  def subscribe(consumer, topic) when is_pid(topic) do
    topic |> PubSub.Topic.subscribe(consumer)
  end

  def subscribe(consumer, topic) when is_atom(topic) do
    pid = find_topic(topic)
    subscribe(consumer, pid)
  end

  def find_topic(name) when is_atom(name) do
    :global.whereis_name(name)
  end
end
