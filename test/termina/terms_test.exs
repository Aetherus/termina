defmodule Termina.TermsTest do
  use Termina.DataCase

  alias Termina.Terms

  describe "terms" do
    alias Termina.Terms.Term
    alias Termina.Projects

    @valid_attrs %{chinese: "some chinese", description: "some description", english: "some english", part_of_speech: "some part_of_speech"}
    @update_attrs %{chinese: "some updated chinese", description: "some updated description", english: "some updated english", part_of_speech: "some updated part_of_speech"}
    @invalid_attrs %{chinese: nil, description: nil, english: nil, part_of_speech: nil}

    setup do
      {:ok, project} = Projects.create_project(%{name: "foo"})
      [
        project: project,
        valid_attrs: Map.put(@valid_attrs, :project_id, project.id),
        update_attrs: Map.put(@update_attrs, :project_id, project.id),
        invalid_attrs: Map.put(@invalid_attrs, :project_id, nil)
      ]
    end

    def term_fixture(context, attrs \\ %{}) do
      {:ok, term} =
        attrs
        |> Enum.into(context.valid_attrs)
        |> Terms.create_term()

      term
    end

    test "list_terms/1 returns all terms in a project", context do
      term = term_fixture(context)
      assert Terms.list_terms(context.project.id) == [term]
    end

    test "get_term!/1 returns the term with given id", context do
      term = term_fixture(context)
      assert Terms.get_term!(term.id) == term
    end

    test "create_term/1 with valid data creates a term", context do
      assert {:ok, %Term{} = term} = Terms.create_term(context.valid_attrs)
      assert term.chinese == "some chinese"
      assert term.description == "some description"
      assert term.english == "some english"
      assert term.part_of_speech == "some part_of_speech"
      assert term.project_id == context.project.id
    end

    test "create_term/1 with invalid data returns error changeset", context do
      assert {:error, %Ecto.Changeset{}} = Terms.create_term(context.invalid_attrs)
    end

    test "update_term/2 with valid data updates the term", context do
      term = term_fixture(context)
      assert {:ok, %Term{} = term} = Terms.update_term(term, context.update_attrs)
      assert term.chinese == "some updated chinese"
      assert term.description == "some updated description"
      assert term.english == "some updated english"
      assert term.part_of_speech == "some updated part_of_speech"
    end

    test "update_term/2 with invalid data returns error changeset", context do
      term = term_fixture(context)
      assert {:error, %Ecto.Changeset{}} = Terms.update_term(term, context.invalid_attrs)
      assert term == Terms.get_term!(term.id)
    end

    test "delete_term/1 deletes the term", context do
      term = term_fixture(context)
      assert {:ok, %Term{}} = Terms.delete_term(term)
      assert_raise Ecto.NoResultsError, fn -> Terms.get_term!(term.id) end
    end

    test "change_term/1 returns a term changeset", context do
      term = term_fixture(context)
      assert %Ecto.Changeset{} = Terms.change_term(term)
    end
  end
end
