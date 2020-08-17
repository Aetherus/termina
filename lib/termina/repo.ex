defmodule Termina.Repo do
  use Ecto.Repo,
    otp_app: :termina,
    adapter: Ecto.Adapters.Postgres
end
