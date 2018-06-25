defmodule PubSub.Consumer do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use GenServer
      import PubSub.Consumer

      def start_link() do
        GenServer.start_link(__MODULE__, :ok)
      end

      def init(_) do
        {:ok, []}
      end
    end
  end

  defmacro consume(pattern, do: block) do
    quote do
      def handle_cast({:deliver, topic, unquote(pattern)}, state) do
        state = unquote(block)
        {:noreply, state}
      end
    end
  end
end
