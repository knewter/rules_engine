defmodule RulesEngine.Rules.BMI do
  alias RulesEngine.Guidance
  alias RulesEngine.Diagnosis

  def apply(document) do
    case document.patient.bmi do
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
end
