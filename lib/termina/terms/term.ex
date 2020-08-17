defmodule Termina.Terms.Term do
  use Ecto.Schema
  import Ecto.Changeset

  schema "terms" do
    belongs_to :project, Termina.Projects.Project

    field :english, :string
    field :chinese, :string
    field :part_of_speech, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:english, :chinese, :part_of_speech, :description, :project_id])
    |> validate_required([:english, :chinese, :part_of_speech, :project_id])
    |> assoc_constraint(:project)
    |> unique_constraint([:english, :part_of_speech, :project_id])
  end
end
