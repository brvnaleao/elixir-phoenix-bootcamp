defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset


  @required_params [:title]

  schema "topics" do
    field :title, :string
  end

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, @required_params) #cast(params, [:title])
    |> validate_required(@required_params)

  end

end
