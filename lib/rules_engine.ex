defmodule RulesEngine.Document do
  defstruct [:patient]
end

defmodule RulesEngine.Patient do
  defstruct [:bmi]
end

defmodule RulesEngine.Guidance do
  defstruct [:diagnosis, :text]
end

defmodule RulesEngine.Diagnosis do
  defstruct [:id]
end

defmodule RulesEngine.RulesOutput do
  defstruct guidances: []

  def into(original) do
    {original, fn
        source, {:cont, nil} -> source
        source, {:cont, guidance=%RulesEngine.Guidance{}} ->
          %__MODULE__{source | guidances: [guidance|source.guidances]}
        source, :done -> source
        source, :halt -> :ok
      end
    }
  end
end

defimpl Collectable, for: RulesEngine.RulesOutput do
  defdelegate into(original), to: RulesEngine.RulesOutput
end

defmodule RulesEngine do
  alias RulesEngine.Document
  alias RulesEngine.RulesOutput
  alias RulesEngine.Guidance

  def apply_rules(document=%Document{}, rules) do
    for rule <- rules, into: %RulesOutput{} do
      case rule do
        {mod, fun} ->
          apply(mod, fun, [document])
        rule ->
          {output, _binding} = Code.eval_quoted(rule, [document: document, patient: document.patient], __ENV__)
          output
      end
    end
  end
end
