defmodule Latchex.LatchBehaviour do
  @moduledoc false

  @type entry_t :: String.Chars.t()
  @type error_t :: any()

  @callback write(entry_t) :: {:ok} | {:error, error_t}
end
