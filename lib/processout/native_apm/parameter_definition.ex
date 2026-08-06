defmodule ProcessOut.NativeAPM.ParameterDefinition do
  @moduledoc """
  Definition of a parameter required by a Native APM payment.
  """

  use ProcessOut.Resource

  field :key
  field :type
  field :required
  field :length
  field :display_name
  field :available_values, cast: ProcessOut.NativeAPM.ParameterValueDefinition
end
