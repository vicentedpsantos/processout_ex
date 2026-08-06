defmodule ProcessOut.Webhook do
  @moduledoc """
  Webhook delivery attempt for an event.
  """

  use ProcessOut.Resource

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :event, cast: ProcessOut.Event
  field :event_id
  field :request_url
  field :request_method
  field :response_body
  field :response_code
  field :response_headers
  field :response_time_ms
  field :status
  field :created_at
  field :release_at
end
