defmodule Latchex.LatchTest do
  use ExUnit.Case

  alias Latchex.Latch

  setup do
    Logger.disable(self())
    latch = start_supervised!({Latch, %{flush_threshold: 1000}})
    %{latch: latch}
  end

  test "implements LatchBehaviour::write", %{latch: _latch} do
    assert :ok = Latchex.Latch.write("Test Entry")
  end

  test "fails to accept an entry that does not have a String.Char implementstion", %{latch: _latch} do
    assert_raise Protocol.UndefinedError, fn -> Latchex.Latch.write(%{something: "cool"}) end
  end

  test "write multiple entries" do
    Latch.start_link()
    for i <- 1..1000 do
      Latch.write("Entry ##{i}")
    end
  end
end
