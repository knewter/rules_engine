defmodule RulesEngine.Document do
  defstruct [:patient]
end

defmodule RulesEngine.Patient do
  defstruct [:bmi]
end

defmodule RulesEngine.RulesOutput do
  defstruct guidances: []
end

defmodule RulesEngine.Guidance do
  defstruct [:diagnosis, :text]
end

defmodule RulesEngine.Diagnosis do
  defstruct [:id]
end

defmodule RulesEngine do
  alias RulesEngine.Document
  alias RulesEngine.RulesOutput
  alias RulesEngine.Guidance

  def apply_rules(document=%Document{}, rules) do
    apply_rules(document, rules, %RulesOutput{})
  end
  def apply_rules(document=%Document{}, [{mod, fun}|rest], rules_output) do
    output = apply(mod, fun, [document])
    case output do
      nil -> apply_rules(document, rest, rules_output)
      guidance = %Guidance{} ->
        apply_rules(document, rest, %RulesOutput{rules_output|guidances: [guidance|rules_output.guidances]})
    end
  end
  def apply_rules(document=%Document{}, [rule|rest], rules_output) do
    {output, _binding} = Code.eval_quoted(rule, [document: document, patient: document.patient], __ENV__)
    case output do
      nil -> apply_rules(document, rest, rules_output)
      guidance = %Guidance{} ->
        apply_rules(document, rest, %RulesOutput{rules_output|guidances: [guidance|rules_output.guidances]})
    end
  end
  def apply_rules(_document, [], rules_output), do: rules_output
end
