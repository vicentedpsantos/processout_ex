defmodule ProcessOut.DunningAction do
  @moduledoc """
  Action to take during a dunning cycle step.
  """

  use ProcessOut.Resource

  field :action
  field :delay_in_days
end
