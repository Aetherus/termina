defmodule Termina.Terms do
  @moduledoc """
  The Terms context.
  """

  import Ecto.Query, warn: false
  alias Termina.Repo

  alias Termina.Terms.Term

  @spec import_terms(integer | String.t, integer | String.t, :keep | :overwrite) :: any
  def import_terms(from_project_id, to_project_id, on_conflict \\ "keep") do
    sql = sql_for_import(on_conflict)
    Ecto.Adapters.SQL.query!(Repo, sql, [to_project_id, from_project_id])
  end

  defp sql_for_import(:keep) do
    """
    insert into terms (english, chinese, part_of_speech, description, project_id, inserted_at, updated_at)
    select english,
           chinese,
           part_of_speech,
           description, 
           $1 as project_id, 
           now() as inserted_at,
           now() as updated_at
    from terms
    where project_id = $2
    on conflict (english, part_of_speech, project_id) do nothing
    """
  end

  defp sql_for_import(:overwrite) do
    """
    insert into terms (english, chinese, part_of_speech, description, project_id, inserted_at, updated_at)
    select english, 
           chinese, 
           part_of_speech, 
           description, 
           $1 as project_id, 
           now() as inserted_at, 
           now() as updated_at
    from terms
    where project_id = $2
    on conflict (english, part_of_speech, project_id) do update
    set chinese = excluded.chinese, 
        description = excluded.description,
        updated_at = now()
    """
  end

  @doc """
  Returns the list of terms.

  ## Examples

      iex> list_terms()
      [%Term{}, ...]

  """
  def list_terms(project_id, order_field \\ :english, order \\ :asc) do
    from(t in Term, where: t.project_id == ^project_id, order_by: [{^order, ^order_field}])
    |> Repo.all()
  end

  @doc """
  Gets a single term.

  Raises `Ecto.NoResultsError` if the Term does not exist.

  ## Examples

      iex> get_term!(123)
      %Term{}

      iex> get_term!(456)
      ** (Ecto.NoResultsError)

  """
  def get_term!(id), do: Repo.get!(Term, id)

  @doc """
  Creates a term.

  ## Examples

      iex> create_term(%{field: value})
      {:ok, %Term{}}

      iex> create_term(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_term(attrs \\ %{}) do
    %Term{}
    |> Term.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a term.

  ## Examples

      iex> update_term(term, %{field: new_value})
      {:ok, %Term{}}

      iex> update_term(term, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_term(%Term{} = term, attrs) do
    term
    |> Term.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a term.

  ## Examples

      iex> delete_term(term)
      {:ok, %Term{}}

      iex> delete_term(term)
      {:error, %Ecto.Changeset{}}

  """
  def delete_term(%Term{} = term) do
    Repo.delete(term)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking term changes.

  ## Examples

      iex> change_term(term)
      %Ecto.Changeset{data: %Term{}}

  """
  def change_term(%Term{} = term, attrs \\ %{}) do
    Term.changeset(term, attrs)
  end
end
