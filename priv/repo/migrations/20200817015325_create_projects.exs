defmodule Termina.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :text, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:projects, [:name])

  end
end
