defmodule NotebookApiWeb.KindController do
  use NotebookApiWeb, :controller

  alias NotebookApi.Kinds
  alias NotebookApi.Kinds.Kind

  action_fallback NotebookApiWeb.FallbackController

  def index(conn, _params) do
    kinds = Kinds.list_kinds()
    render(conn, "index.json", kinds: kinds)
  end

  def create(conn, %{"kind" => kind_params}) do
    with {:ok, %Kind{} = kind} <- Kinds.create_kind(kind_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.kind_path(conn, :show, kind))
      |> render("show.json", kind: kind)
    end
  end

  def show(conn, %{"id" => id}) do
    kind = Kinds.get_kind!(id)
    render(conn, "show.json", kind: kind)
  end

  def update(conn, %{"id" => id, "kind" => kind_params}) do
    kind = Kinds.get_kind!(id)

    with {:ok, %Kind{} = kind} <- Kinds.update_kind(kind, kind_params) do
      render(conn, "show.json", kind: kind)
    end
  end

  def delete(conn, %{"id" => id}) do
    kind = Kinds.get_kind!(id)

    with {:ok, %Kind{}} <- Kinds.delete_kind(kind) do
      send_resp(conn, :no_content, "")
    end
  end
end
