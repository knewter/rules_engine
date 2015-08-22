defmodule TransformerTest do
  use ExUnit.Case

  # So we'll define a simple representation of a program we'd like to be able to
  # compile to elixir.  This is very similar to the underlying Elixir AST at
  # present, but at least it's something custom.
  @ast {:if, {
               :>,
               {:var, :bmi},
               40
             },
             true,
             false
       }

  # And here's the elixir we want this to compile to.
  @elixir_ast {:if, [context: Elixir, import: Kernel],
                [{:>, [context: Elixir, import: Kernel],
                  [
                    {:var!, [context: Elixir, import: Kernel],
                      [{:bmi, [], Elixir}]
                    },
                    40
                  ]
                 },
                 [do: true, else: false]]}

  # Now we'll write a test that confirms that our transformer can generate an
  # elixir ast from our custom ast
  test "we can compile our AST into the Elixir AST" do
    compiled = @ast |> Transformer.generate_elixir
    assert compiled == @elixir_ast
  end
end
