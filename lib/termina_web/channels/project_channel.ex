defmodule TerminaWeb.ProjectChannel do
  use TerminaWeb, :channel

  import TerminaWeb.ChangesetView, only: [translate_errors: 1]

  alias Termina.{Projects, Terms}

  @impl true
  def join("project:all", _payload, socket) do
    projects = Projects.list_projects()
    {:ok, %{projects: projects}, socket}
  end

  def join("project:" <> project_id, _payload, socket) do
    terms = project_id |> String.to_integer() |> Terms.list_terms()
    {:ok, %{terms: terms}, socket}
  end

  @impl true

  # 创建项目
  def handle_in("+project" = event, payload, socket) do
    create_resource(event, Projects, :create_project, payload, socket)
  end

  # 复制项目
  def handle_in(
    "~project",
    %{
      "original_id" => original_id,
      "new_name" => new_name
    },
    socket
  ) do
    case Projects.copy_project!(original_id, new_name) do
      {:ok, project} ->
        broadcast(socket, "+project", project)
        {:reply, {:ok, project}, socket}
      {:error, _} ->
        {:reply, :error, socket}
    end
  end

  # 导入词条
  def handle_in(
    "<terms" = event,
    %{
      "from" => from_id, 
      "to" => to_id,
      "on_conflict" => on_conflict
    },
    socket
  ) when on_conflict in ~w[keep overwrite] do
    Terms.import_terms(from_id, to_id, String.to_existing_atom(on_conflict))
    TerminaWeb.Endpoint.broadcast("project:#{to_id}", event, %{terms: Terms.list_terms(to_id)})
    {:reply, :ok, socket}
  end

  # 创建词条
  def handle_in("+term" = event, payload, socket) do
    create_resource(event, Terms, :create_term, payload, socket)
  end

  # 更新项目
  def handle_in("^project" = event, payload, socket) do
    update_resource(event, Projects, :get_project!, :update_project, payload, socket)
  end

  # 更新词条
  def handle_in("^term" = event, payload, socket) do
    update_resource(event, Terms, :get_term!, :update_term, payload, socket)
  end

  # 删除项目
  def handle_in("-project" = event, payload, socket) do
    delete_resource(event, Projects, :get_project!, :delete_project, payload, socket)
  end

  # 删除词条
  def handle_in("-term" = event, payload, socket) do
    delete_resource(event, Terms, :get_term!, :delete_term, payload, socket)
  end

  defp create_resource(event, context, func, payload, socket) do
    case apply(context, func, [payload]) do
      {:ok, resource} -> 
        broadcast(socket, event, resource)
        {:reply, {:ok, resource}, socket}
      {:error, changeset} -> 
        {:reply, {:error,  translate_errors(changeset)}, socket}
    end
  end

  defp update_resource(event, context, get, update, payload, socket) do
    resource = apply(context, get, [payload["id"]])
    case apply(context, update, [resource, payload]) do
      {:ok, resource} ->
        broadcast(socket, event, resource)
        {:reply, {:ok, resource}, socket}
      {:error, changeset} ->
        {:reply, {:error, translate_errors(changeset)}, socket}
    end
  end

  defp delete_resource(event, context, get, delete, payload, socket) do
    resource = apply(context, get, [payload["id"]])
    case apply(context, delete, [resource]) do
      {:ok, resource} ->
        broadcast(socket, event, resource)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, translate_errors(changeset)}, socket}
    end
  end
end
