defmodule NotebookApiWeb.KindControllerTest do
  use NotebookApiWeb.ConnCase

  alias NotebookApi.Kinds
  alias NotebookApi.Kinds.Kind

  @create_attrs %{
    description: "some description"
  }
  @update_attrs %{
    description: "some updated description"
  }
  @invalid_attrs %{description: nil}

  def fixture(:kind) do
    {:ok, kind} = Kinds.create_kind(@create_attrs)
    kind
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all kinds", %{conn: conn} do
      conn = get(conn, Routes.kind_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create kind" do
    test "renders kind when data is valid", %{conn: conn} do
      conn = post(conn, Routes.kind_path(conn, :create), kind: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.kind_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.kind_path(conn, :create), kind: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update kind" do
    setup [:create_kind]

    test "renders kind when data is valid", %{conn: conn, kind: %Kind{id: id} = kind} do
      conn = put(conn, Routes.kind_path(conn, :update, kind), kind: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.kind_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, kind: kind} do
      conn = put(conn, Routes.kind_path(conn, :update, kind), kind: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete kind" do
    setup [:create_kind]

    test "deletes chosen kind", %{conn: conn, kind: kind} do
      conn = delete(conn, Routes.kind_path(conn, :delete, kind))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.kind_path(conn, :show, kind))
      end
    end
  end

  defp create_kind(_) do
    kind = fixture(:kind)
    %{kind: kind}
  end
end
