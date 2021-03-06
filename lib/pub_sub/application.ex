defmodule PubSub.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: PubSub.Topic.DynamicSupervisor}
    ]

    opts = [strategy: :one_for_one, name: PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
