defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%{})

    render conn, "new.html", changeset: changeset

  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(topic)

    case Discuss.Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset

    end
  end

  def index(conn, _params) do
    topics = Discuss.Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do

    topic = Discuss.Repo.get(Topic, topic_id) # returns a struct
    changeset = Map.from_struct(topic)
    |> Topic.changeset() #expects a map

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => title}) do

    topic = Discuss.Repo.get!(Topic, topic_id)
    changeset = Ecto.Changeset.change topic, %{title: title["title"]}

    case title["title"] do

      "" -> render conn, "edit.html", changeset: changeset, topic: topic

      _ ->
        case Discuss.Repo.update changeset do
          {:ok, _struct} ->
            conn
            |> put_flash(:info, "Topic Updated")
            |> redirect(to: Routes.topic_path(conn, :index))
          {:error, changeset} ->
              render conn, "edit.html", changeset: changeset
        end

    end


  end

end
