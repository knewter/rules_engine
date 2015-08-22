defmodule Transformer do
  def generate_elixir({:if, condition, first, second}) do
    {:if, [context: Elixir, import: Kernel],
      [
        generate_elixir(condition),
        [do: generate_elixir(first), else: generate_elixir(second)]
      ]
    }
  end
  def generate_elixir(true), do: true
  def generate_elixir(false), do: false
  def generate_elixir({:var, var_name}) do
    {:var!, [context: Elixir, import: Kernel], [{var_name, [], Elixir}]}
  end
  def generate_elixir({:>, first, second}) do
    {:>, [context: Elixir, import: Kernel], [generate_elixir(first), generate_elixir(second)]}
  end
  def generate_elixir(x) when is_integer(x), do: x
end
