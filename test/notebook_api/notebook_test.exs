defmodule NotebookApi.NotebookTest do
  use NotebookApi.DataCase

  alias NotebookApi.Notebook

  describe "contacts" do
    alias NotebookApi.Notebook.Contact

    @valid_attrs %{birthdate: ~D[2010-04-17], email: "some email", name: "some name"}
    @update_attrs %{birthdate: ~D[2011-05-18], email: "some updated email", name: "some updated name"}
    @invalid_attrs %{birthdate: nil, email: nil, name: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notebook.create_contact()

      contact
    end

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Notebook.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Notebook.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Notebook.create_contact(@valid_attrs)
      assert contact.birthdate == ~D[2010-04-17]
      assert contact.email == "some email"
      assert contact.name == "some name"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notebook.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{} = contact} = Notebook.update_contact(contact, @update_attrs)
      assert contact.birthdate == ~D[2011-05-18]
      assert contact.email == "some updated email"
      assert contact.name == "some updated name"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Notebook.update_contact(contact, @invalid_attrs)
      assert contact == Notebook.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Notebook.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Notebook.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Notebook.change_contact(contact)
    end
  end
end
