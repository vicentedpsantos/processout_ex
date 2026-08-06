defmodule ProcessOut.ExportLayout.Configuration.Column do
  @moduledoc """
  Column of an export layout configuration.
  """

  use ProcessOut.Resource

  field :name
  field :rename
end
