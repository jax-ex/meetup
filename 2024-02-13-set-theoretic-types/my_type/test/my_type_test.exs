defmodule MyTypeTest do
  use ExUnit.Case
  doctest MyType

  test "greets the world" do
    assert MyType.hello() == :world
  end
end
