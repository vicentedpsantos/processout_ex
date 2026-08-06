defmodule ProcessOut.APIVersion do
  @moduledoc """
  Version of the ProcessOut API.
  """

  use ProcessOut.Resource

  field :name
  field :description
  field :created_at
end
