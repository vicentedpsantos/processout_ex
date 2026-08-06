defmodule ProcessOut.ExportLayout.Configuration.Amount do
  @moduledoc """
  Amount formatting settings of an export layout configuration.
  """

  use ProcessOut.Resource

  field :precision
  field :separator
end
