defmodule NotebookApi.Repo do
  use Ecto.Repo,
    otp_app: :notebook_api,
    adapter: Ecto.Adapters.Postgres
end
