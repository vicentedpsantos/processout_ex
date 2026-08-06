defmodule ProcessOut.NativeAPM.ParameterValue do
  @moduledoc """
  Value of a Native APM payment parameter.
  """

  use ProcessOut.Resource

  field :key
  field :value
end
