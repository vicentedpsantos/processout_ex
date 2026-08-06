defmodule ProcessOut.ExportLayout.Configuration do
  @moduledoc """
  Configuration of an export layout.
  """

  use ProcessOut.Resource

  field :columns, cast: ProcessOut.ExportLayout.Configuration.Column
  field :time, cast: ProcessOut.ExportLayout.Configuration.Time
  field :amount, cast: ProcessOut.ExportLayout.Configuration.Amount
end
