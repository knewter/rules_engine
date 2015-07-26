defmodule RulesTimingBench do
  use Benchfella
  alias RulesEngine.Document
  alias RulesEngine.Patient
  alias RulesEngine.Guidance
  alias RulesEngine.Diagnosis

  @num1 100
  @num2 10_000
  @rule (
    quote do
      case var!(patient).bmi do
        x when x >= 40 ->
          %Guidance{
            diagnosis: %Diagnosis{id: 1111},
            text: "Consider the following..."
          }
        x when x < 18 ->
          %Guidance{
            diagnosis: %Diagnosis{id: 2222},
            text: "Consider the following..."
          }
        _ ->
          nil
      end
    end
  )
  @rules1 Stream.repeatedly(fn() -> @rule end) |> Enum.take(@num1)
  @rules2 Stream.repeatedly(fn() -> @rule end) |> Enum.take(@num2)
  @crules1 Stream.repeatedly(fn() -> {RulesEngine.Rules.BMI, :apply} end) |> Enum.take(@num1)
  @crules2 Stream.repeatedly(fn() -> {RulesEngine.Rules.BMI, :apply} end) |> Enum.take(@num2)

  @document %Document{
    patient: %Patient{
      bmi: 40
    }
  }

  bench "running #{@num1} rules" do
    RulesEngine.apply_rules(@document, @rules1)
  end
  bench "running #{@num2} rules" do
    RulesEngine.apply_rules(@document, @rules2)
  end

  bench "running #{@num1} compiled rules" do
    RulesEngine.apply_rules(@document, @crules1)
  end
  bench "running #{@num2} compiled rules" do
    RulesEngine.apply_rules(@document, @crules2)
  end
end
