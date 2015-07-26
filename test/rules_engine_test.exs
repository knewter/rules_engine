defmodule RulesEngineTest do
  use ExUnit.Case
  alias RulesEngine.Document
  alias RulesEngine.Patient
  alias RulesEngine.RulesOutput
  alias RulesEngine.Guidance
  alias RulesEngine.Diagnosis

  @rules [
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
  ]

  # For patient,
  #   if patient.bmi >= 40,
  #   then event.guidance.diagnosis == [diagnosis.id(1111)] && event.guidance.text == "Consider the following..."
  #   else if patient.bmi < 18
  #   then event.guidance.diagnosis == [diagnosis.id(2222)] && event.guidance.text == "Consider the following..."

  test "basic output" do
    document_40 = %Document{
      patient: %Patient{
        bmi: 40
      }
    }
    document_30 = %Document{
      patient: %Patient{
        bmi: 30
      }
    }
    document_17 = %Document{
      patient: %Patient{
        bmi: 17
      }
    }

    %RulesOutput{guidances: [guidance|_]} = RulesEngine.apply_rules(document_40, @rules)
    assert guidance.diagnosis == %Diagnosis{id: 1111}
    assert guidance.text == "Consider the following..."

    assert %RulesOutput{guidances: []} = RulesEngine.apply_rules(document_30, @rules)

    %RulesOutput{guidances: [guidance|_]} = RulesEngine.apply_rules(document_17, @rules)
    assert guidance.diagnosis == %Diagnosis{id: 2222}
    assert guidance.text == "Consider the following..."
  end
end
