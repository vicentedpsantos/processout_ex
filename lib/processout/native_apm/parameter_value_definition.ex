defmodule ProcessOut.NativeAPM.ParameterValueDefinition do
  @moduledoc """
  Definition of an available value for a Native APM payment parameter.
  """

  use ProcessOut.Resource

  field :value
  field :default
  field :display_name
end
