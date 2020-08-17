defmodule Termina.TermsTest do
  use Termina.DataCase

  alias Termina.Terms

  describe "terms" do
    alias Termina.Terms.Term

    @valid_attrs %{chinese: "some chinese", description: "some description", english: "some english", part_of_speech: "some part_of_speech"}
    @update_attrs %{chinese: "some updated chinese", description: "some updated description", english: "some updated english", part_of_speech: "some updated part_of_speech"}
    @invalid_attrs %{chinese: nil, description: nil, english: nil, part_of_speech: nil}

    def term_fixture(attrs \\ %{}) do
      {:ok, term} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Terms.create_term()

      term
    end

    test "list_terms/0 returns all terms" do
      term = term_fixture()
      assert Terms.list_terms() == [term]
    end

    test "get_term!/1 returns the term with given id" do
      term = term_fixture()
      assert Terms.get_term!(term.id) == term
    end

    test "create_term/1 with valid data creates a term" do
      assert {:ok, %Term{} = term} = Terms.create_term(@valid_attrs)
      assert term.chinese == "some chinese"
      assert term.description == "some description"
      assert term.english == "some english"
      assert term.part_of_speech == "some part_of_speech"
    end

    test "create_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Terms.create_term(@invalid_attrs)
    end

    test "update_term/2 with valid data updates the term" do
      term = term_fixture()
      assert {:ok, %Term{} = term} = Terms.update_term(term, @update_attrs)
      assert term.chinese == "some updated chinese"
      assert term.description == "some updated description"
      assert term.english == "some updated english"
      assert term.part_of_speech == "some updated part_of_speech"
    end

    test "update_term/2 with invalid data returns error changeset" do
      term = term_fixture()
      assert {:error, %Ecto.Changeset{}} = Terms.update_term(term, @invalid_attrs)
      assert term == Terms.get_term!(term.id)
    end

    test "delete_term/1 deletes the term" do
      term = term_fixture()
      assert {:ok, %Term{}} = Terms.delete_term(term)
      assert_raise Ecto.NoResultsError, fn -> Terms.get_term!(term.id) end
    end

    test "change_term/1 returns a term changeset" do
      term = term_fixture()
      assert %Ecto.Changeset{} = Terms.change_term(term)
    end
  end
end
