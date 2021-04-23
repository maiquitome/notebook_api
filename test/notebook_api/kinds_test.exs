defmodule NotebookApi.KindsTest do
  use NotebookApi.DataCase

  alias NotebookApi.Kinds

  describe "kinds" do
    alias NotebookApi.Kinds.Kind

    @valid_attrs %{description: "some description"}
    @update_attrs %{description: "some updated description"}
    @invalid_attrs %{description: nil}

    def kind_fixture(attrs \\ %{}) do
      {:ok, kind} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Kinds.create_kind()

      kind
    end

    test "list_kinds/0 returns all kinds" do
      kind = kind_fixture()
      assert Kinds.list_kinds() == [kind]
    end

    test "get_kind!/1 returns the kind with given id" do
      kind = kind_fixture()
      assert Kinds.get_kind!(kind.id) == kind
    end

    test "create_kind/1 with valid data creates a kind" do
      assert {:ok, %Kind{} = kind} = Kinds.create_kind(@valid_attrs)
      assert kind.description == "some description"
    end

    test "create_kind/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Kinds.create_kind(@invalid_attrs)
    end

    test "update_kind/2 with valid data updates the kind" do
      kind = kind_fixture()
      assert {:ok, %Kind{} = kind} = Kinds.update_kind(kind, @update_attrs)
      assert kind.description == "some updated description"
    end

    test "update_kind/2 with invalid data returns error changeset" do
      kind = kind_fixture()
      assert {:error, %Ecto.Changeset{}} = Kinds.update_kind(kind, @invalid_attrs)
      assert kind == Kinds.get_kind!(kind.id)
    end

    test "delete_kind/1 deletes the kind" do
      kind = kind_fixture()
      assert {:ok, %Kind{}} = Kinds.delete_kind(kind)
      assert_raise Ecto.NoResultsError, fn -> Kinds.get_kind!(kind.id) end
    end

    test "change_kind/1 returns a kind changeset" do
      kind = kind_fixture()
      assert %Ecto.Changeset{} = Kinds.change_kind(kind)
    end
  end
end
