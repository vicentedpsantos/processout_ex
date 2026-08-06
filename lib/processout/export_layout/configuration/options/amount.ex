defmodule ProcessOut.ExportLayout.Configuration.Options.Amount do
  @moduledoc """
  Available amount formatting options for an export layout configuration.
  """

  use ProcessOut.Resource

  field :precision
  field :separator
end
