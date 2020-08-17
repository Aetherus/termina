defmodule Termina.Repo.Migrations.CreateTerms do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :english, :text, null: false
      add :chinese, :text, null: false
      add :part_of_speech, :text, null: false
      add :description, :text

      timestamps()
    end

    create index(:terms, [:project_id])
    create unique_index(:terms, [:english, :part_of_speech, :project_id])
  end
end
