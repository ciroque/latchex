defmodule Latchex.Latch do
  use GenServer

#  @behaviour Latchex.LatchBehaviour

  require Logger

  ## ####################
  ## Public API

  def write(entry) do
    Logger.info("#{__MODULE__} write: #{entry}")
    GenServer.call(__MODULE__, {:write, entry})
  end

  ## ####################
  ## Public API

  def start_link() do
    start_link(%{flush_threshold: 1000})
  end

  def start_link(params) do
    GenServer.start_link(__MODULE__, params, name: __MODULE__)
  end

  def init(params) do
    Logger.debug("#{__MODULE__} init given params: #{inspect(params)}")

    new_params = %{primary_cache: []} |> Map.merge(params)

    Logger.debug("#{__MODULE__} init returning params: #{inspect(new_params)}")
    {:ok, new_params}
  end

  ## ####################
  ## Public API

  def handle_call({:write, entry}, _from, %{primary_cache: primary_cache, flush_threshold: flush_threshold} = state) do
    Logger.debug("#{__MODULE__} handle_cast write: threshold: #{flush_threshold}, entry: #{entry}")
    updated_cache = [entry | primary_cache]
    Logger.debug("#{__MODULE__} handle_cast write: #{inspect(updated_cache)}}")
    {:reply, :ok, state |> Map.put(:primary_cache, updated_cache)}
  end
end
