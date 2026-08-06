defmodule ProcessOut.NativeAPM.Response do
  @moduledoc """
  Native APM payment response.
  """

  use ProcessOut.Resource

  field :state
  field :parameter_definitions, cast: ProcessOut.NativeAPM.ParameterDefinition
  field :parameter_values, cast: ProcessOut.NativeAPM.ParameterValue
end
