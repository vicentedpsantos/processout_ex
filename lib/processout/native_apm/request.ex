defmodule ProcessOut.NativeAPM.Request do
  @moduledoc """
  Native APM payment request parameter values.
  """

  use ProcessOut.Resource

  field :parameter_values, cast: ProcessOut.NativeAPM.ParameterValue
end
