defmodule ProcessOut.Webhook.Endpoint do
  @moduledoc """
  Endpoint webhooks are sent to.
  """

  use ProcessOut.Resource

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :url
  field :events_whitelist
  field :sandbox
  field :created_at
end
