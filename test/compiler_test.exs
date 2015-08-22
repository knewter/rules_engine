defmodule Compiler do
  def compile(ast) do
    quoted = Transformer.generate_elixir(ast)

    fn(input) ->
      {val, _binding} = Code.eval_quoted(quoted, [bmi: input])
      val
    end
  end
end

defmodule CompilerTest do
  use ExUnit.Case

  # We'll copy over the same AST we used in the transformer test
  @ast {:if, {
               :>,
               {:var, :bmi},
               40
             },
             true,
             false
       }

  @input 41
  @bad_input 40

  test "we can evaluate some AST" do
    compiled = @ast |> Compiler.compile
    assert compiled.(@input) == true
    assert compiled.(@bad_input) == false
  end
end
